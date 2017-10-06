//
//
//  WingIt
//
//  Created by William Shaw on 5/27/17.
//  Copyright © 2017 Eli Labes. All rights reserved.
//

import UIKit

class LoginDebugController: UIViewController, UIWebViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    
    @objc let errorColor: UIColor = UIColor(rgb: 0xFF0013)
    @objc let infoColor: UIColor = UIColor(rgb: 0x0052FF)
    
    @objc let webCheckError = "document.getElementsByClassName('sv-panel-danger').length > 0;"
    
    @objc let webErrorReason = "document.getElementsByClassName('sv-panel sv-panel-danger')[0].getElementsByTagName('strong')[0].innerHTML"
    
    @objc let webClickLogin = "document.getElementsByClassName('sv-btn sv-btn-block sv-btn-primary')[0].click();"
    
    @objc let webClickTimetable = "document.getElementsByClassName('uo_see_more')[document.getElementsByClassName('uo_see_more').length - 1].getElementsByTagName('a')[0].click();"
    
    @objc let webClickNextWeek = "document.getElementsByClassName('sv-btn sv-btn-block sv-btn-default')[1].click();"
    
    @objc let webCheckHeader = "document.getElementsByClassName('sv-h1-small')[0].innerHTML"
    
    @objc let webLogout = "document.getElementsByClassName('sv-navbar-text sv-visible-xs-block')[0].getElementsByTagName('a')[0].click()"
    
    @objc let webInsertFunctions = "window.getJSArray = function() {\n" +
                "return content = document.getElementById('ttb_timetable').getElementsByTagName('script')[0].innerHTML.trim();}"

    @objc let webGrabCode = "window.getJSArray()"
    
    @objc let monitorScript = "var intervalHandle" +
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
    
    @objc let loadNextWeek = "window.loadNextWeek()"
    
    @objc var once:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        webView.loadRequest(URLRequest(url: URL(string: "https://evision.otago.ac.nz")!))
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    @objc func loginReset(reason:String) {
        webView.loadRequest(URLRequest(url: URL(string: "https://evision.otago.ac.nz")!))

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
            
            
            switch header {
                
            case "System Message":
                break;
                
            case "Home":
                webView.stringByEvaluatingJavaScript(from: webClickTimetable)
                break;
                
            case "Timetable":
                webView.stringByEvaluatingJavaScript(from: webInsertFunctions)
                let json:String = NSString(string: webView.stringByEvaluatingJavaScript(from: webGrabCode)!) as String
                
                //webView.stringByEvaluatingJavaScript(from: monitorScript)
                //webView.stringByEvaluatingJavaScript(from: loadNextWeek)
                
                // Here we can pass on the output timetable for one week with the printed date.
                print(json)
                parseEvents(json.cString(using: String.Encoding.utf8));
                
//                /// _________________________________________ EXAMPLE CPP LIB USAGE
//                
//                let date = Date()
//                let formatter = DateFormatter()
//                
//                formatter.dateFormat = "yyyy-MM-dd" // ISO date format.
//                
//                let today = formatter.string(from: date)
//                
//                let cstr = getEventsByDate(today.cString(using: String.Encoding.utf8), 0)
//                
//                let str = String(cString: cstr!)
//                
//                free(UnsafeMutablePointer(mutating: cstr)) // We must free the memory that C++ created for the pointer.
//                
//                print("\(str)")
//                
//                print("NUM EVENTS = \(numEvents("2017-10-02".cString(using: String.Encoding.utf8)))")
//                
//                /// _________________________________________
 
                
                self.performSegue(withIdentifier: "LoginDoneSegue", sender: self)
                
                webView.stringByEvaluatingJavaScript(from: webClickNextWeek)
                webView.stringByEvaluatingJavaScript(from: webLogout)
                break;
                
            default:
                break;
                
            }
        }
        
    }
    

}
