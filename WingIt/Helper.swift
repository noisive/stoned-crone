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
    
    let minsBeforeNotification = 15
    
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
    interval.day = event.day - 1
    let notificationDate = Calendar.current.date(byAdding: interval, to: mondaysDate)!
    
    // DateFormatter.dateFormat = "yyyy-MM-dd'T'HH"
    dateFormatter.dateFormat = "HHmm"
    dateFormatter.timeZone = TimeZone.autoupdatingCurrent
    
    // Start time plus 7 gives correct hours
    let notificationTime = (event.startTime+7) * 100 + 60 - minsBeforeNotification
    var notificationTimeString = String(notificationTime)
    if notificationTimeString.characters.count < 4 {
        notificationTimeString = "0" + notificationTimeString
    }
    // Concat date and time
    dateFormatter.dateFormat = "ddMMyy"
    let notificationTimeAndDateString = dateFormatter.string(from: notificationDate) + notificationTimeString
    
    dateFormatter.dateFormat = "ddMMyyHHmm"
    let localNotification = UILocalNotification()
    localNotification.timeZone = TimeZone.autoupdatingCurrent
    localNotification.fireDate = dateFormatter.date(from: notificationTimeAndDateString)
    // Message example: COSC345 Lecture coming up at 11
    localNotification.alertBody = "\(event.code) \(event.type) coming up at \(event.startTime)"
    
    
    //set the notification
    UIApplication.shared.scheduleLocalNotification(localNotification)
}


