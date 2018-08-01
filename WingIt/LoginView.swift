//
//  LoginViewController.swift
//  WingIt
//
//  Created by William Shaw on 5/27/17.
//  Copyright © 2017 Eli Labes. All rights reserved.
//

/* CONTROL FLOW:
 This webview relies on calling a function to load a webpage.
 It returns control when it is finished loading, via the method "webViewDidFinishLoad".
 This is where logic controls whether to attempt further steps of the login process,
 or to display a login box and wait for user input, etc.
 "beginLogin()" is call when the login button is pushed, via its button outlet/delegate.
 Function "textFieldShouldReturn" is triggered when enter/return is pressed when typing in a login field.
 This either moves to the next field or calls beginLogin() as well,
 but has some extra checks and messages in place for empty fields.
 
 As per usual, viewDidAppear and viewDidLoad() are the first functions called in this file.
 */

import UIKit

class LoginView: UIViewController, UIWebViewDelegate, UITextFieldDelegate, PLoginState {
    
    //MARK: Outlets and Variables
    //==========================================================================
    
    //Outlets
    @IBOutlet weak var loginContainer: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var savePasswordSwitch: UISwitch!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var loginTitle: UILabel!
    @IBOutlet weak var genericpasswordSigninButton: UIButton!
    
    //Variables
    public var isUpdatingMode: Bool!
    private var PWIsStored: Bool = false
    override var preferredStatusBarStyle: UIStatusBarStyle{return .default}
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let reachability = Reachability()!

    //Constants
    private let CORNER_RADIUS: CGFloat = 3.5;
    
    //HTML and JS
    private let webCheckError: String = "document.getElementsByClassName('sv-panel-danger').length > 0;"
    private let webErrorReason: String = "document.getElementsByClassName('sv-panel sv-panel-danger')[0].getElementsByTagName('strong')[0].innerHTML"
    private let webClickLogin: String = "document.getElementsByClassName('sv-btn sv-btn-block sv-btn-primary')[0].click();"
    private let webClickTimetable: String = "document.getElementsByClassName('uo_see_more')[document.getElementsByClassName('uo_see_more').length - 1].getElementsByTagName('a')[0].click();"
    private let webClickNextWeek: String = "document.getElementsByClassName('sv-btn sv-btn-block sv-btn-default')[1].click();"
    private let webCheckHeader: String = "document.getElementsByClassName('sv-h1-small')[0].innerHTML"
    private let webLogout: String = "document.getElementsByClassName('sv-navbar-text sv-visible-xs-block')[0].getElementsByTagName('a')[0].click()"
    private let webInsertFunctions: String = "window.getJSArray = function() {\n" +
    "return content = document.getElementById('ttb_timetable').getElementsByTagName('script')[0].innerHTML.trim();}"
    private let webGrabCode: String = "window.getJSArray()"
    private let monitorScript: String = "var intervalHandle" +
        "var monitorState = 0" +
        "window.monitorUpdate = function(cb) {" +
        "intervalHandle = setInterval(() => {" +
        "var newDate = document.getElementsByClassName('sitsjqtttitle')[0].innerHTML" +
        "if (newDate.indexOf('Updating') !== -1) {" +
        "monitorState = 1" +
        "} else if (monitorState === 1) {" +
        "monitorState = 0" +
        "clearInterval(intervalHandle)" +
        "cb()" +
        "}" +
        "}, 50)" +
        "}" +
        "window.loadNextWeek = function() {" +
        "ttb_timetable_move('N')" +
        "monitorUpdate(() => {" +
        "window.location.href = 'https://com.noisive'" +
        "})" +
    "}"
    private let loadNextWeek: String = "window.loadNextWeek()"
    private var initialLoad: Bool = false
    
    
    //MARK: View loading.
    // These are the first functions called.
    //==========================================================================
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.hideCancelOnNoData()
        self.checkNetworkAlert()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLooks()
        setupLogic()
    }
    
    //MARK: Delegates
    //==========================================================================
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 130), animated: true)
    }
    
    // Starts webview loading with a specific requested URL. Calls webViewDidFinishLoad when finished.
    internal func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print("CALLED \(String(describing: request.url?.absoluteString))")
        
        if request.url?.absoluteString == "https://com.noisive" {
            print("JS CALLBACK")
            return false
        }
        // Calls webViewDidFinishLoad when finished.
        return true
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if (!webView.isLoading) {
            
            let error:Bool = NSString(string: webView.stringByEvaluatingJavaScript(from: webCheckError)!).boolValue
            if (error) {
                // Get the error given by eVision.
                let reason:String = NSString(string: webView.stringByEvaluatingJavaScript(from: self.webErrorReason)!) as String
                enableLoginContainer(withErrorMessage: reason, startTyping: false)
                return
            }
            var header:String = NSString(string: webView.stringByEvaluatingJavaScript(from: self.webCheckHeader)!) as String
            header = header.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            
            //Web view initial load, grab stored details
            if (header == "" && !initialLoad) {
                initialLoad = true
                enableLoginContainer()
            }
            
            switch header {
            case "System Message":
                break;
            case "Home":
                webView.stringByEvaluatingJavaScript(from: self.webClickTimetable)
                if self.isUpdatingMode {
                    SVProgressHUD.setStatus("Updating your timetable...")
                }else{
                    SVProgressHUD.setStatus("Retrieving your timetable...")
                }
                break;
            case "Timetable":
                grabTTJsonFromEvisionPage()
                break;
            default:
                break;
            }
        }
    }
    
    //MARK: Functions
    //==========================================================================
    
    private func setupLogic() {
        //Setup delegates
        usernameField.delegate = self
        passwordField.delegate = self
        webView.delegate = self
        
        if (retrieveStoredUsername() != "" && retrieveStoredPassword() != "") {
            self.PWIsStored = true
        }
        
        // Remove keyboard when tapping away
        let dismissGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.endEditing))
        self.scrollView.addGestureRecognizer(dismissGesture)
        
        if fakeLogin { // Skip loading evision
//            sleep(1) // Otherwise too fast to close view before it opens
            enableLoginContainer(startTyping: true)
            return
        }
        //Setup webview with initial load. Moves to viewDidFinishLoading when done.
        let urlBase: URL? = URL(string: "https://evision.otago.ac.nz")
        if let url = urlBase {
            let loadRequest: URLRequest = URLRequest(url: url)
            webView.loadRequest(loadRequest)
        }
    }
    
    private func setupLooks() {
        loginContainer.layer.shadowColor = UIColor.black.cgColor
        loginContainer.layer.shadowOpacity = 0.3
        loginContainer.layer.shadowOffset = CGSize.zero
        loginContainer.layer.shadowRadius = 3
        loginContainer.clipsToBounds = false
        loginContainer.layer.cornerRadius = CORNER_RADIUS;
        
        loginButton.layer.cornerRadius = CORNER_RADIUS;
        
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.show(withStatus: "Loading eVision...")
        self.loginContainer.alpha = 0
        
        self.genericpasswordSigninButton.isHidden = !OnePasswordExtension.shared().isAppExtensionAvailable()
        
        if self.isUpdatingMode == nil {
            self.isUpdatingMode = false
        }
        if self.isUpdatingMode {
            self.loginTitle.text = "Log in to Update"
            self.loginButton.setTitle("UPDATE", for: .normal)
        }else{
            self.loginButton.setTitle("LOG IN", for: .normal)
            self.loginTitle.text = "Log in to eVision"
        }
//        #if debug
        if debugLogin {
            scrollView.isHidden = true
            scrollView.isOpaque = false
            SVProgressHUD.dismiss()
            loginContainer.isHidden = true
            loginContainer.isOpaque = false
            webView.isHidden = false
            webView.frame = self.view.bounds
            webView.scalesPageToFit = true
//            scrollView.drawsBackground = false
        }
//        #endif
    }

    // Triggered when enter/return pressed when typing in login field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {    
        guard let usernameText = self.usernameField.text else { return false }
        guard let passwordText = self.passwordField.text else { return false }
        
        switch textField {
        case self.usernameField:
            if (usernameText.isEmpty) {
                self.handleAlert(title: "Username Empty", description: "Please enter your eVision username.")
            } else if (!usernameText.isEmpty && passwordText.isEmpty) {
                self.passwordField.becomeFirstResponder()
            } else {
                self.beginLogin()
            }
        case self.passwordField:
            if (passwordText.isEmpty) {
                self.handleAlert(title: "Password Empty", description: "Please enter your eVision password.")
            } else if (usernameText.isEmpty && !passwordText.isEmpty) {
                self.usernameField.becomeFirstResponder()
            } else {
                self.beginLogin()
            }
        default:
            print("Unknown text field")
        }
        return true
    }
    
    private func beginLogin() {
        self.endEditing()
        if let user = usernameField.text, let password = passwordField.text {
            // Set field text in actual webpage.
            self.webView.stringByEvaluatingJavaScript(from: "document.getElementById('MUA_CODE.DUMMY.MENSYS').value = '\(user)';")
            self.webView.stringByEvaluatingJavaScript(from: "document.getElementById('PASSWORD.DUMMY.MENSYS').value = '\(password)';")
            
            if self.savePasswordSwitch.isOn {
                storeUserPass(username: user, password: password)
                self.PWIsStored = true
            } else {
                self.PWIsStored = false
                removeStoredUserPass()
            }
            if user.lowercased() == "wingitdemo" && password == "Ilikedevs" {
                copyTestData()
                endWithSuccessfulLogin()
                return
            }
            disableLoginContainer(message: "Logging you in...")
            //Fire request to click login
            webView.stringByEvaluatingJavaScript(from: self.webClickLogin)
        } else { // Error getting text from one of the fields
            SVProgressHUD.dismiss()
            self.handleAlert(title: "Login Error", description: "Please ensure your login details are entered correctly.")
        }
    }
    
    private func handleAlert(title: String, description: String) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @objc private func endEditing() {
        self.view.endEditing(true)
        // Move login box back to centre of screen.
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }

    func enableLoginContainer(withErrorMessage errorMessage: String? = nil, startTyping: Bool = true){
        
        if self.PWIsStored {
            restoreSavedDetails()
        }
        // NOTE: If details are remembered, this func will skip the login
        // box and do the rest of the logging in automatically.
        if self.PWIsStored {
            beginLogin()
            return
        }
//        #if debug
        if debugLogin {
            // Return here if you want to see without login box at all.
            return
        }
//        #endif
        // Manual login time
        SVProgressHUD.dismiss()
        UIView.animate(withDuration: 0.3, animations: {
            self.loginContainer.alpha = 1
        }, completion: { (success) in
            self.loginButton.isEnabled = true
            if errorMessage != nil {
                SVProgressHUD.showError(withStatus: errorMessage)
            }
            if startTyping {
                // Move login box up out of way of keyboard
                self.scrollView.setContentOffset(CGPoint(x: 0, y: 130), animated: true)
                self.usernameField.becomeFirstResponder()
            }
        })
    }
    
    func disableLoginContainer(message: String){
        UIView.animate(withDuration: 0.3, animations: {
            self.loginContainer.alpha = 0
            self.loginButton.isEnabled = false
        }) { (success) in
            SVProgressHUD.show(withStatus: message)
        }
    }
    
    func restoreSavedDetails(){
        usernameField.text = retrieveStoredUsername()
        passwordField.text = retrieveStoredPassword()
        
        if (retrieveStoredUsername() != "" && retrieveStoredPassword() != "") {
            self.savePasswordSwitch.isOn = true
            self.PWIsStored = true
        }
    }
    
    private func hideCancelOnNoData() {
        let fileManager = FileManager.default
        let dataPath = NSHomeDirectory()+"/Library/Caches/data.csv"
        
        if self.isUpdatingMode {
            cancelButton.isEnabled = true
            cancelButton.isHidden = false
        } else {
            // If we don't have data already.
            if (!fileManager.fileExists(atPath: dataPath)) {
                cancelButton.isEnabled = false
                cancelButton.isHidden = true
            } else {
                cancelButton.isEnabled = true
                cancelButton.isHidden = false
            }
        }
    }
    
    private func grabTTJsonFromEvisionPage(){
        webView.stringByEvaluatingJavaScript(from: self.webInsertFunctions)
        
        //Check if the json was grabbed
        if let jsonString:String = webView.stringByEvaluatingJavaScript(from: webGrabCode) {
            let _ = parseEvents(data: jsonString)
            #if DEBUG
//             if ProcessInfo.processInfo.environment["XCInjectBundleInto"] != nil {
            if testing {
//                  if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
                validateTimetable()
            }
            #endif
            SVProgressHUD.showSuccess(withStatus: "Timetable Downloaded")
            webView.stringByEvaluatingJavaScript(from: webClickNextWeek)
            webView.stringByEvaluatingJavaScript(from: webLogout)
            endWithSuccessfulLogin()
        } else {
            //Issue with getting JSON. Display error and log out
            enableLoginContainer(withErrorMessage:  "Something went wrong getting your timetable...")
            webView.stringByEvaluatingJavaScript(from: webClickNextWeek)
            webView.stringByEvaluatingJavaScript(from: webLogout)
        }
    }
    
    private func endWithSuccessfulLogin(){
        initTimetable()
        appDelegate.firstLoadSoScrollToToday = true
        self.present(NavigationService.displayEntryView(), animated: true, completion: nil)
    }
    
    private func checkNetworkAlert(){
        return
        if reachability.connection == .none || noReachabilityArg {
            let alert = UIAlertController(title:  "No Internet Connection", message:  "Make sure your device is connected to the internet.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
                self.reloadInputViews()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                self.dismiss(self)
            }))
            //            alert.accessibilityIdentifier = "No network alert"
            self.present(alert, animated: true)
        }
    }
    
    
    //MARK: Actions
    //==========================================================================
    
    @IBAction func dismiss(_ sender: Any) {
        SVProgressHUD.dismiss()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLoginFromGenericPassword(_ sender: UIButton){
        OnePasswordExtension.shared().findLogin(forURLString: "https://evision.otago.ac.nz", for: self, sender: sender, completion: { (loginDict, error) in
            if loginDict == nil {
//                if error!.code != AppExtensionErrorCodeCancelledByUser {
//                    print("Error invoking GenericPassword App Extension for find login: \(error)");
//                }
                return
            }
            self.usernameField.text = loginDict![AppExtensionUsernameKey] as? String
            self.passwordField.text = loginDict![AppExtensionPasswordKey] as? String
        })
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        self.beginLogin()
    }
    
}
