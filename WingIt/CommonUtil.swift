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
    case "Examination":
        return AppColors.EXAM_COLOR.withAlphaComponent(0.2)
    default:
        return UIColor.init(hexString: fallback.colour)
    }
}

public func getBarBackgroundColorFromLesson(type: String, fallback: Lesson) -> UIColor {
    return getBackgroundColorFromLesson(type: type, fallback: fallback).withAlphaComponent(1)
}

/* Call this function when each item is initialised to schedule a
// notification [minsBeforeNotification] minutes before that event.
// Timezone note: All times are stored as UTC, but with numbers that would be
// correct for current region. Only when objectively correct times are
// needed, like for scheduling the notification, are they converted back
// with a function.
// @param the event struct to be used. */
func setNotification (event: Lesson){
    
    var minsBeforeNotification = 15 // Default to 15 mins before lecture
    if isKeyPresentInUserDefaults(key: "noticePeriod"){
        minsBeforeNotification = UserDefaults.standard.integer(forKey: "noticePeriod")
    }
    //---------------------------------------------------------------------------------------------
    // This section of code has an alternative after it, for if there are multiple weeks of data. Change them when this is implemented. FEATURE
    // Get Monday's date, then transform fire date based on lesson's weekday
    let mondaysDate: Date = getMondaysDate()
    // Add the day to monday
    var interval = DateComponents()
    interval.day = event.day - 1
    
    // We want notifications just before the start hour
    interval.hour = event.startTime - 1
    interval.minute = 60 - minsBeforeNotification
    
    var cal = Calendar.current
    cal.timeZone = TimeZone(abbreviation: "UTC")!
    let notificationTimeAndDate = cal.date(byAdding: interval, to: mondaysDate)!
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
    
    // first check notification isn't in the past. if it is, skip the rest.
    if notificationTimeAndDate < todaysDate(){ return }

    var eventTime = event.startTime!
    if eventTime > 12{ eventTime -= 12 }
    // Message example: COSC345 Lecture coming up at 11
    let notificationMessage = "\((event.code)!) \((event.type)!) starts at \(eventTime) in \((event.roomShort)!)"
    
    scheduleNotification(datetime: convertNZTtoUTC(date: notificationTimeAndDate), soundName: UILocalNotificationDefaultSoundName, message: notificationMessage)
}

func scheduleNotification(datetime: Date, soundName: String, message: String){
    
    let localNotification = UILocalNotification()
    localNotification.fireDate = datetime
    localNotification.soundName = soundName
    localNotification.alertBody = message
    UIApplication.shared.scheduleLocalNotification(localNotification)
    // DEBUG print out currently scheduled notifications
    print(UIApplication.shared.scheduledLocalNotifications!)
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
    
    let firstEventDateString = getFirstEventDate()
    enum DateError: Error {
        case BadDate
    }
    do{
        guard let _ = getDateFromISOString(str: firstEventDateString) else{
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
            if fileName == "data.csv" || fileName == ".version" {
                let filePathName = "\(cachePath)/\(fileName)"
                try fileManager.removeItem(atPath: filePathName)
            }
        }
    } catch {
        print("Could not clear: \(error)")
    }
}

func copyTestData(fakeDataURL: URL? = nil){
    let fileManager = FileManager.default
    let cacheURL = try! fileManager
        .url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    let dataURL = cacheURL.appendingPathComponent("data.csv")
    //    let bundle = Bundle(for: type(of: self))
    var testDataURL: URL
    if fakeDataURL == nil {
        testDataURL = Bundle.main.url(forResource: "testData", withExtension: "csv")!
    }else{
        testDataURL = fakeDataURL!
    }
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

var noReachabilityArg = false
var testing = false
var skipLogin = false
func HandleLaunchArgs() {
    //    let userDefaults: UserDefaults
    var args = CommandLine.arguments
    
    // Resets app if given argument reset, so that tests start from a consistent clean state
    if args.contains("-reset") {
        //        let defaultsName = Bundle.main.bundleIdentifier!
        //    userDefaults.removePersistentDomain(forName: defaultsName)
        removeStoredUserPass()
        clearCache()
    }
    if args.contains("-UITests") {
        UIApplication.shared.keyWindow?.layer.speed = 100
    }
    if args.contains("-testing") {
        testing = true
    }
    if args.contains("-skipLogin") {
        skipLogin = true
    }
    if args.contains("-noReachability"){
        noReachabilityArg = true
    }
    if args.contains("-fakeData") {
        copyTestData()
        if !args.contains("-mockDate") {
            mockDateTime() // Will use default
        }
    }
    if let i = args.index(of: "-fakeDataAt"){
        let fakeURL = URL(fileURLWithPath: args[i+1])
        copyTestData(fakeDataURL: fakeURL)
        if !args.contains("-mockDate") {
            mockDateTime() // Will use default
        }
    }
    
    // Expect argument of the form "mockDate [date]",
    // where [date] is of the ISO form yyyy-MM-dd.
    //    if args.contains("-mockDate") {
    //        if let mockDateStr = UserDefaults.standard.string(forKey: "mockDate"){
    if let i = args.index(of: "-mockDate"){
        let mockDateStr = args[i+1]
        mockDateTime(mockStrO: mockDateStr)
    }
    if let i = args.index(of: "-mockTime"){
        let mockTimeStr = args[i+1]
        mockDateTime(mockStrO: mockTimeStr)
    }
    //    }
    
}

func checkVersionFile(){
    // If new version, force update.
    if let versionNum = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as? String {
        let fileManager = FileManager.default
        let cacheURL = try! fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let versionFileURL = cacheURL.appendingPathComponent(".version")
        if !fileManager.fileExists(atPath: versionFileURL.path) {
            do {
                clearCache()
                try versionNum.write(to: versionFileURL, atomically: false, encoding: .utf8)
            } catch { }
        }else{
            do {
                let oldVer = try String(contentsOf: versionFileURL, encoding: .utf8)
                if oldVer != versionNum {
                    clearCache()
                    try versionNum.write(to: versionFileURL, atomically: false, encoding: .utf8)
                }
            } catch { }
        }
    }
}
#if DEBUG

func loadDummyUIForUnitTesting(VC: AppDelegate) -> Bool{
    // If we are running unit tests, don't wait till app has finished launching.
    // Load dummy instead.
    if ProcessInfo.processInfo.environment["XCInjectBundleInto"] != nil {
        let viewController = UIViewController()
        let label = UILabel()
        label.text = "Running tests..."
        label.frame = viewController.view.frame
        label.textAlignment = .center
        label.textColor = .white
        viewController.view.addSubview(label)
        VC.window!.rootViewController = viewController
        return true
    }else{
        return false
    }
}
#endif

extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}
