//
//  LoginViewController.swift
//  WingIt
//
//  Created by William Shaw on 5/27/17.
//  Copyright © 2017 Eli Labes. All rights reserved.
//

import UIKit

class LoginView: UIViewController, UIWebViewDelegate, UITextFieldDelegate, PLoginState {
    
    //MARK: Outlets and Variables
    //==========================================================================
    
    //Outlets
    @IBOutlet var loginContainer: UIView!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var savePasswordSwitch: UISwitch!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet var loginTitle: UILabel!
    
    //Variables
    public var isUpdatingMode: Bool!
    private var PWIsStored: Bool = false
    
    //Constants
    private let CORNER_RADIUS: CGFloat = 3.5;
    
    //HTML
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
    private var once: Bool = false
    
    
    //MARK: View loading
    //==========================================================================
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            //self.hideCancelOnNoData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLogic()
        setupLooks()
        
        
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.show(withStatus: "Loading eVision...")
        self.loginContainer.alpha = 0
    }
    
    //MARK: Functions
    //==========================================================================
    
    private func setupLooks() {
        loginContainer.layer.shadowColor = UIColor.black.cgColor
        loginContainer.layer.shadowOpacity = 0.3
        loginContainer.layer.shadowOffset = CGSize.zero
        loginContainer.layer.shadowRadius = 3
        loginContainer.clipsToBounds = false
        loginContainer.layer.cornerRadius = CORNER_RADIUS;
        
        loginButton.layer.cornerRadius = CORNER_RADIUS;
        
        UIApplication.shared.statusBarStyle = .default
    }
    
    private func setupLogic() {
        //Setup delegates
        usernameField.delegate = self
        passwordField.delegate = self
        webView.delegate = self
        
        self.loginTitle.text = self.isUpdatingMode ? "Log in to Update" : "Log in to eVision"
        self.loginButton.setTitle(self.isUpdatingMode ? "UPDATE" : "LOGIN", for: .normal)
        
        self.PWIsStored = true
        
        //Setup gestures
        let dismissGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.endEditing))
        self.scrollView.addGestureRecognizer(dismissGesture)
        
        //Setup webview
        let urlBase: URL? = URL(string: "https://evision.otago.ac.nz")
        if let url = urlBase {
            let loadRequest: URLRequest = URLRequest(url: url)
            webView.loadRequest(loadRequest)
        }
    
    }
    
    @objc private func endEditing() {
        self.view.endEditing(true)
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    private func beginLogin() {
        self.endEditing()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.loginContainer.alpha = 0
            self.loginButton.isEnabled = false
        }) { (success) in
            SVProgressHUD.show(withStatus: "Logging you in...")
        }
        
        if let user = usernameField.text, let password = passwordField.text {
            self.webView.stringByEvaluatingJavaScript(from: "document.getElementById('MUA_CODE.DUMMY.MENSYS').value = '\(user)';")
            self.webView.stringByEvaluatingJavaScript(from: "document.getElementById('PASSWORD.DUMMY.MENSYS').value = '\(password)';")
            
            if self.savePasswordSwitch.isOn {
                storeUserPass(username: user, password: password)
                self.PWIsStored = true
            } else {
                self.PWIsStored = false
                removeStoredUserPass()
            }
            
            //Fire request
            webView.stringByEvaluatingJavaScript(from: self.webClickLogin)
        } else {
            SVProgressHUD.dismiss()
            self.handleAlert(title: "Login Error", description: "Please ensure your login details are entered correctly.")
        }
    }
    
    private func handleAlert(title: String, description: String) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
    
    //MARK: Actions
    //==========================================================================
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        self.beginLogin()
    }
    
    //MARK: Delegates
    //==========================================================================
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 130), animated: true)
    }
    
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
    
    internal func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print("CALLED \(String(describing: request.url?.absoluteString))")
        
        if request.url?.absoluteString == "https://com.noisive" {
            print("JS CALLBACK")
            return false
        }
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if (!webView.isLoading) {
            
            let error:Bool = NSString(string: webView.stringByEvaluatingJavaScript(from: webCheckError)!).boolValue
            if (error) {
                // Get the error given by eVision.
                let reason:String = NSString(string: webView.stringByEvaluatingJavaScript(from: self.webErrorReason)!) as String
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.loginContainer.alpha = 1
                }) { (success) in
                    SVProgressHUD.showError(withStatus: reason)
                    self.loginButton.isEnabled = true
                }
                return
            }
            
            var header:String = NSString(string: webView.stringByEvaluatingJavaScript(from: self.webCheckHeader)!) as String
            header = header.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            
            //Web view initial load, grab stored details
            if (header == "" && !once) {
                usernameField.text = retrieveStoredUsername()
                passwordField.text = retrieveStoredPassword()
                
                if (retrieveStoredUsername() != "" && retrieveStoredPassword() != "") {
                    self.savePasswordSwitch.isOn = true
                }
                once = true
                
                SVProgressHUD.dismiss()
                UIView.animate(withDuration: 0.3, animations: {
                    self.loginContainer.alpha = 1
                }, completion: { (success) in
                    self.scrollView.setContentOffset(CGPoint(x: 0, y: 130), animated: true)
                    self.usernameField.becomeFirstResponder()
                })
            }
            
            switch header {
                
            case "System Message":
                break;
                
            case "Home":
                webView.stringByEvaluatingJavaScript(from: self.webClickTimetable)
                SVProgressHUD.setStatus(self.isUpdatingMode ? "Updating your timetable..." : "Retrieving your timetable...")
                break;
                
            case "Timetable":
                webView.stringByEvaluatingJavaScript(from: self.webInsertFunctions)
                
                //Check if the json was grabbed
                if let jsonString:String = webView.stringByEvaluatingJavaScript(from: webGrabCode) {
                    let json: NSString = NSString(string: jsonString)
                    parseEvents(json.cString(using: String.Encoding.utf8.rawValue))
                    initTimetable()
                    self.present(NavigationService.displayEntryView(), animated: true, completion: nil)
                    SVProgressHUD.showSuccess(withStatus: "Timetable Downloaded")
                    webView.stringByEvaluatingJavaScript(from: webClickNextWeek)
                    webView.stringByEvaluatingJavaScript(from: webLogout)
                }
                    //Issue with getting JSON. Display error and log out
                else {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.loginContainer.alpha = 1
                    }) { (success) in
                        SVProgressHUD.showError(withStatus: "Something went wrong getting your timetable...")
                        self.loginButton.isEnabled = true
                    }
                    webView.stringByEvaluatingJavaScript(from: webClickNextWeek)
                    webView.stringByEvaluatingJavaScript(from: webLogout)
                }
                
                break;
                
            default:
                break;
                
            }
        }
    }
}
