//
//  LoginViewController.swift
//  WingIt
//
//  Created by William Shaw on 5/27/17.
//  Copyright © 2017 Eli Labes. All rights reserved.
//

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

import UIKit

class LoginViewController: UIViewController, UIWebViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var doneButton: UIButton!
    
    let errorColor: UIColor = UIColor(rgb: 0xFF0013)
    let infoColor: UIColor = UIColor(rgb: 0x0052FF)
    
    let webCheckError = "document.getElementsByClassName('sv-panel-danger').length > 0;"
    
    let webErrorReason = "document.getElementsByClassName('sv-panel sv-panel-danger')[0].getElementsByTagName('strong')[0].innerHTML"
    
    let webClickLogin = "document.getElementsByClassName('sv-btn sv-btn-block sv-btn-primary')[0].click();"
    
    let webClickTimetable = "document.getElementsByClassName('uo_see_more')[document.getElementsByClassName('uo_see_more').length - 1].getElementsByTagName('a')[0].click();"
    
    let webClickNextWeek = "document.getElementsByClassName('sv-btn sv-btn-block sv-btn-default')[1].click();"
    
    let webCheckHeader = "document.getElementsByClassName('sv-h1-small')[0].innerHTML"
    
    let webLogout = "document.getElementsByClassName('sv-navbar-text sv-visible-xs-block')[0].getElementsByTagName('a')[0].click()"
    
    let webInsertFunctions = "window.getJSArray = function() {\n" +
                "return content = document.getElementById('ttb_timetable').getElementsByTagName('script')[0].innerHTML.trim();}"

    let webGrabCode = "window.getJSArray()"
    
    let monitorScript = "var intervalHandle" +
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
    
    let loadNextWeek = "window.loadNextWeek()"
    
    var once:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameField.isHidden = true
        passwordField.isHidden = true
        loginButton.isHidden = true
        spinner.startAnimating()
        webView.delegate = self
        webView.loadRequest(URLRequest(url: URL(string: "https://evision.otago.ac.nz")!))
        
        
        loginButton.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
        usernameField.addTarget(self, action: #selector(self.textUpdated), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(self.textUpdated), for: .editingChanged)
        passwordField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func passPrimaryActionTriggered(_ sender: UITextField) {
        if (sender == usernameField) {
            usernameField.resignFirstResponder()
            passwordField.becomeFirstResponder()
        } else if (sender == passwordField) {
            passwordField.resignFirstResponder()
            attemptLogin()
        }
    }
    
    @objc private func textUpdated() {
        if ((usernameField.text?.characters.count)! > 0 && (passwordField.text?.characters.count)! > 0) {
            errorLabel.text = ""
        }
    }
    
    func loginReset(reason:String) {
        webView.loadRequest(URLRequest(url: URL(string: "https://evision.otago.ac.nz")!))
        usernameField.isHidden = false
        passwordField.isHidden = false
        loginButton.isHidden = false
        spinner.isHidden = true
        spinner.stopAnimating()
        passwordField.text = ""
        errorLabel.textColor = errorColor
        errorLabel.text = "\(reason)"
    }
    
//    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
//        print("CALLED \(String(describing: request.url?.absoluteString))")
//        
//        if request.url?.absoluteString == "https://com.noisive" {
//            print("JS CALLBACK")
//            return false
//        }
//        return true
//    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if (!webView.isLoading) {
            
            let error:Bool = NSString(string: webView.stringByEvaluatingJavaScript(from: webCheckError)!).boolValue
            if (error) {
                // Get the error given by eVision.
                let reason:String = NSString(string: webView.stringByEvaluatingJavaScript(from: webErrorReason)!) as String
                loginReset(reason: reason)
                return;
            }
            
            var header:String = NSString(string: webView.stringByEvaluatingJavaScript(from: webCheckHeader)!) as String
            header = header.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            
            if (header == "" && !once) {
                errorLabel.text = "Enter your eVision details"
                usernameField.isHidden = false
                passwordField.isHidden = false
                loginButton.isHidden = false
                spinner.stopAnimating()
                spinner.isHidden = true
                once = true
            }
            
            switch header {
                
            case "System Message":
                spinner.stopAnimating()
                spinner.isHidden = true
                break;
                
            case "Home":
                webView.stringByEvaluatingJavaScript(from: webClickTimetable)
                errorLabel.text = "Retrieving your timetable"
                break;
                
            case "Timetable":
                webView.stringByEvaluatingJavaScript(from: webInsertFunctions)
                let json:String = NSString(string: webView.stringByEvaluatingJavaScript(from: webGrabCode)!) as String
                
                //webView.stringByEvaluatingJavaScript(from: monitorScript)
                //webView.stringByEvaluatingJavaScript(from: loadNextWeek)
                
                // Here we can pass on the output timetable for one week with the printed date.
                //print(json)
                parseTimetable(json.cString(using: String.Encoding.utf8));
                
                errorLabel.text = "Done!"
                
                self.performSegue(withIdentifier: "LoginDoneSegue", sender: self)
                
                webView.stringByEvaluatingJavaScript(from: webClickNextWeek)
                webView.stringByEvaluatingJavaScript(from: webLogout)
                break;
                
            default:
                break;
                
            }
        }
        
    }
    
    @objc private func buttonClicked() {
        if ((usernameField.text?.characters.count)! > 0 && (passwordField.text?.characters.count)! > 0) {
            attemptLogin();
        } else {
            errorLabel.text = "Username & Password required"
        }
    }
    
    func attemptLogin() {
        let user:String = usernameField.text!
        webView.stringByEvaluatingJavaScript(from: "document.getElementById('MUA_CODE.DUMMY.MENSYS').value = '\(user)';")
        let pass:String = passwordField.text!
        webView.stringByEvaluatingJavaScript(from: "document.getElementById('PASSWORD.DUMMY.MENSYS').value = '\(pass)';")
        usernameField.isHidden = true
        passwordField.isHidden = true
        loginButton.isHidden = true
        spinner.isHidden = false
        spinner.startAnimating()
        errorLabel.textColor = infoColor
        errorLabel.text = "Logging you in"
        webView.stringByEvaluatingJavaScript(from: webClickLogin)
    }
    
}
