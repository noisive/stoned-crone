//
//  Helper.swift
//  WingIt
//
//  Created by William Warren on 10/2/17.
//  Copyright © 2017 Noisive. All rights reserved.
//

import Foundation


// Call this function when each item is initialised to schedule a
// notification [minsBeforeNotification] minutes before that event.
// @param the event struct to be used.
func setNotification (event: Lesson){
    
    let minsBeforeNotification = UserDefaults.standard.integer(forKey: "noticePeriod")
    
    
    //---------------------------------------------------------------------------------------------
    // This section of code has an alternative after it, for if there are multiple weeks of data. Change them when this is implemented. FEATURE
    
    // Get Monday's date, then transform fire date based on lesson's weekday
    var dateFormatter = DateFormatter()
    let today = Date()
    let todayWeekday: Int = Calendar.current.component(.weekday, from: today)
    
    // Gives date of most recent Monday
    var mondaysDate: Date {
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
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
    if notificationTimeAndDate < Date(){
        return
    }
    localNotification.fireDate = notificationTimeAndDate
    localNotification.soundName = UILocalNotificationDefaultSoundName
    
    var eventTime = event.startTime + 8
    if eventTime > 12{
        eventTime -= 12
    }
    // Message example: COSC345 Lecture coming up at 11
    let notificationMessage = "\((event.code)!) \((event.type)!) coming up at \(eventTime)"
    localNotification.alertBody = notificationMessage
    
    
    UIApplication.shared.scheduleLocalNotification(localNotification)
    
    // DEBUG print out currently scheduled notifications
    // print(UIApplication.shared.scheduledLocalNotifications!)
}

// Account for the default UMT time, which is giving wrong date regardless of how the timezone is set!!!
func convertUMTtoNZT(current: Date) -> Date{
    var timeDiff = DateComponents()
    //NZ is + 13. Will break for DST, should try to get proper timezones working eventually.
    timeDiff.hour = 13
    let updated = Calendar.current.date(byAdding: timeDiff, to: current)
    return (updated)!
}

func getDayOfWeek() -> Int? {
    let todayDate = Date()
    let myCalendar = Calendar(identifier: .gregorian)
    let weekDay = myCalendar.component(.weekday, from: todayDate)
    // Weekday 1 is sunday, we want to return sunday as 7
    if weekDay == 1 {
        return 7
    }else{
        return weekDay - 1
    }
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
