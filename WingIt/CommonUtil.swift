//
//  Helper.swift
//  WingIt
//
//  Created by William Warren on 10/2/17.
//  Copyright © 2017 Noisive. All rights reserved.
//



import Foundation



public func getBackgroundColorFromLesson(type: String, fallback: Lesson) -> UIColor {
    switch type {
    case "Lecture":
        return AppColors.LECTURE_COLOR.withAlphaComponent(0.2)
    case "Lab":
        return AppColors.LAB_COLOR.withAlphaComponent(0.2)
    case "Computer Lab":
        return AppColors.LAB_COLOR.withAlphaComponent(0.2)
    case "Tutorial":
        return AppColors.TUTORIAL_COLOR.withAlphaComponent(0.2)
    case "Practical":
        return AppColors.LAB_COLOR.withAlphaComponent(0.2)
    default:
        return UIColor.init(hexString: fallback.colour)
    }
}

public func getBarBackgroundColorFromLesson(type: String, fallback: Lesson) -> UIColor {
    return getBackgroundColorFromLesson(type: type, fallback: fallback).withAlphaComponent(1)
}

// Call this function when each item is initialised to schedule a
// notification [minsBeforeNotification] minutes before that event.
// @param the event struct to be used.
func setNotification (event: Lesson){
    
    var minsBeforeNotification = 15 // Default to 15 mins before lecture
    if isKeyPresentInUserDefaults(key: "noticePeriod"){
        minsBeforeNotification = UserDefaults.standard.integer(forKey: "noticePeriod")
    }
    
    
    //---------------------------------------------------------------------------------------------
    // This section of code has an alternative after it, for if there are multiple weeks of data. Change them when this is implemented. FEATURE
    
    // Get Monday's date, then transform fire date based on lesson's weekday
    var dateFormatter = DateFormatter()
    let today = todaysDate()
    // Todo: potentially change this to a call to getDayOfWeek
    let todayWeekday: Int = getDayOfWeek()
    
    // Gives date of most recent Monday
    var mondaysDate: Date {
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
    }
    
    // Add the day to monday
    var interval = DateComponents()
    interval.day = event.day
    
    // Start time plus 7 gives correct hours for before lecture
    interval.hour = event.startTime + 7
    interval.minute = 60 - minsBeforeNotification
    
    let notificationTimeAndDate = Calendar.current.date(byAdding: interval, to: mondaysDate)!
    
    // End weekday date code
    //-----------------------------------------------------------------------------------------------
    
    
    
    /* This section of code loads the notification for the actual event date, rather than the weekday. Use this for when multiple weeks are loaded.
     
     // Add the notification time to the date of the event
     var interval = DateComponents()
     // Start time plus 7 gives correct hours for before lecture
     interval.hour = event.startTime + 7
     interval.minute = 60 - minsBeforeNotification
     
     let notificationTimeAndDate = Calendar.current.date(byAdding: interval, to: event.eventDate)!
     
     */
    
    let localNotification = UILocalNotification()
    localNotification.timeZone = TimeZone(identifier: "NZST")
    
    // first check notification isn't in the past. if it is, skip the rest.
    if notificationTimeAndDate < today{
        return
    }
    localNotification.fireDate = notificationTimeAndDate
    localNotification.soundName = UILocalNotificationDefaultSoundName
    
    var eventTime = event.startTime + 8
    if eventTime > 12{
        eventTime -= 12
    }
    // Message example: COSC345 Lecture coming up at 11
    let notificationMessage = "\((event.code)!) \((event.type)!) starts at \(eventTime) in \((event.roomShort)!)"
    localNotification.alertBody = notificationMessage
    
    
    UIApplication.shared.scheduleLocalNotification(localNotification)
    
    // DEBUG print out currently scheduled notifications
    // print(UIApplication.shared.scheduledLocalNotifications!)
}

func storeUserPass(username: String, password: String){
    var saveSuccessful: Bool = KeychainWrapper.standard.set(username, forKey: "WingItStoredUser")
    if saveSuccessful{
        saveSuccessful = KeychainWrapper.standard.set(password, forKey: "WingItStoredPass")
    }
    if saveSuccessful{
        print("saved username and password successfully!")
    }
}

func removeStoredUserPass(){
    KeychainWrapper.standard.removeObject(forKey: "WingItStoredUser")
    KeychainWrapper.standard.removeObject(forKey: "WingItStoredPass")
    
}
func retrieveStoredUsername() -> String{
    // Check unwrap is not nil (ie no value stored)
    if let name = KeychainWrapper.standard.string(forKey: "WingItStoredUser"){
        return name
    }else{
        return ""
    }
}

func retrieveStoredPassword() -> String{
    // Check unwrap is not nil (ie no value stored)
    if let pass = KeychainWrapper.standard.string(forKey: "WingItStoredPass"){
        return pass
    }else{
        return ""
    }
}

func isKeyPresentInUserDefaults(key: String) -> Bool {
    return UserDefaults.standard.object(forKey: key) != nil
}



// Usage: let color2 = UIColor(rgb: 0xFFFFFF)
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
    // Convert string (format "#FFFFFF") to hex int (format 0xFFFFFF)
    convenience init(hexString:String) {
        let hexString:NSString = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased() as NSString
        let scanner            = Scanner(string: hexString as String)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
}

// Hides keyboard if another part of the screen is tapped.
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

func checkAndRemoveBadDateData() -> Bool{
    // Resets data if bad date. //
    //    let fileManager = FileManager.default
    let dataPath = NSHomeDirectory()+"/Library/Caches/data.csv"
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd" // ISO date format.
    let firstEventDateString = getFirstEventDate()
    enum DateError: Error {
        case BadDate
    }
    do{
        guard let _ = formatter.date(from: firstEventDateString) else{
            throw DateError.BadDate
        }
    }catch{
        
        do {
            print("Date format unacceptable. Deleting data...")
            try FileManager.default.removeItem(at: NSURL(fileURLWithPath: dataPath) as URL)
            // Get user to log in again...
            return true
            
        } catch let error as NSError {
            print("Error: \(error.domain)")
        }
    }
    
    /*
     // Hard code year limits.
     // TODO make this adapt.
     if let firstEventDateNum = Int(firstEventDateString) {
     if (timeInterval > Int((upperInterval?.timeIntervalSince1970)!) || firstEventDateNum < Int((lowerInterval?.timeIntervalSince1970)!)) {
     do {
     try FileManager.default.removeItem(at: NSURL(fileURLWithPath: dataPath) as URL)
     } catch let error as NSError {
     print("Error: \(error.domain)")
     }
     }
     }*/
    return false
}

// Delete all files in app cache dir, including our data csvs.
func clearCache(){
    let fileManager = FileManager.default
    let cacheURL = try! fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    do {
        let cachePath = cacheURL.path
        let fileNames = try fileManager.contentsOfDirectory(atPath: "\(cachePath)")
        
        for fileName in fileNames {
            
            //                    if (fileName == "cache.db-wal")
            //                    {
            let filePathName = "\(cachePath)/\(fileName)"
            
            try fileManager.removeItem(atPath: filePathName)
            //                    }
        }
        
        //            let files = try fileManager.contentsOfDirectory(atPath: "\(cachePath)")
        
        
    } catch {
        print("Could not clear: \(error)")
    }
}

func copyTestData(){
    let fileManager = FileManager.default
    let cacheURL = try! fileManager
        .url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    let dataURL = cacheURL.appendingPathComponent("data.csv")
    //    let bundle = Bundle(for: type(of: self))
    let testDataURL = Bundle.main.url(forResource: "testData", withExtension: "csv")!
    do{
        if fileManager.fileExists(atPath: dataURL.path) {
            try fileManager.removeItem(at: dataURL)
        }
        try fileManager.copyItem(at: testDataURL, to: dataURL)
                if let versionNum = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as? String {
                    let versionFileURL = cacheURL.appendingPathComponent(".version")
                    try versionNum.write(to: versionFileURL, atomically: false, encoding: .utf8)
                }
    }catch let error as NSError {
        print("Error:\(error.description)")
    }
}

