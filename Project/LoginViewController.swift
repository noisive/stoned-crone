//
//  LoginViewController.swift
//  Project
//
//  Created by William Shaw on 5/27/17.
//  Copyright © 2017 Eli Labes. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UIWebViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var doneButton: UIButton!
    
    let webCheckError = "document.getElementsByClassName('sv-panel-danger').length > 0;"
    
    let webErrorReason = "document.getElementsByClassName('sv-panel sv-panel-danger')[0].getElementsByTagName('strong')[0].innerHTML"
    
    let webClickLogin = "document.getElementsByClassName('sv-btn sv-btn-block sv-btn-primary')[0].click();"
    
    let webClickTimetable = "document.getElementsByClassName('uo_see_more')[document.getElementsByClassName('uo_see_more').length - 1].getElementsByTagName('a')[0].click();"
    
    let webClickNextWeek = "document.getElementsByClassName('sv-btn sv-btn-block sv-btn-default')[1].click();"
    
    let webCheckHeader = "document.getElementsByClassName('sv-h1-small')[0].innerHTML"
    
    let webLogout = "document.getElementsByClassName('sv-navbar-text sv-visible-xs-block')[0].getElementsByTagName('a')[0].click()"
    
    let webInsertFunctions = "window.getJSArray = function() {\n" +
                "return content = document.getElementById('ttb_timetable').getElementsByTagName('script')[0].innerHTML.trim();}" +
                                "\n" +
                "window.getWeekStart = function() {" +
                "var content = document.getElementById('ttb_timetable').getElementsByTagName('script')[0].innerHTML.trim();" +
                "var startIndex = content.indexOf('Now showing dates') + ('Now showing dates '.length);" +
                "return content.substring(startIndex, startIndex + 12);}"

    let webGrabCode = "window.getJSArray()"
    
    let webGrabDate = "window.getWeekStart()"
    
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
        errorLabel.text = "\(reason)"
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if (!webView.isLoading) {
            
            let error:Bool = NSString(string: webView.stringByEvaluatingJavaScript(from: webCheckError)!).boolValue
            if (error) {
                // Get the error given by eVision.
                let reason:String = NSString(string: webView.stringByEvaluatingJavaScript(from: webErrorReason)!) as String
                print("Error detected on page: \(reason)")
                loginReset(reason: reason)
                return;
            }
            
            var header:String = NSString(string: webView.stringByEvaluatingJavaScript(from: webCheckHeader)!) as String
            header = header.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            print("PAGE HEADER: \(header)")
            
            if (header == "" && !once) {
                usernameField.isHidden = false
                passwordField.isHidden = false
                loginButton.isHidden = false
                spinner.stopAnimating()
                spinner.isHidden = true
                once = true
            }
            
            switch header {
                
            case "System Message":
                print("System Message no Danger Panel (probably Logout)")
                spinner.startAnimating()
                spinner.isHidden = true
                _ = self.navigationController?.popToRootViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
                
                break;
                
            case "Home":
                webView.stringByEvaluatingJavaScript(from: webClickTimetable)
                break;
                
            case "Timetable":
                print("Extracting Week")
                webView.stringByEvaluatingJavaScript(from: webInsertFunctions)
                let weekStart:String = NSString(string: webView.stringByEvaluatingJavaScript(from: webGrabDate)!) as String
                let json:String = NSString(string: webView.stringByEvaluatingJavaScript(from: webGrabCode)!) as String
                
                // Here we can pass on the output timetable for one week with the printed date.
                print(weekStart)
                print(json)
                parseTimetable(json.cString(using: String.Encoding.utf8));
                
                doneButton.isHidden = false
                
                webView.stringByEvaluatingJavaScript(from: webClickNextWeek)
                print("Logging out")
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
        webView.stringByEvaluatingJavaScript(from: webClickLogin)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
