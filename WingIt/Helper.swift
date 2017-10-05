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
    interval.day = event.day
    
    // Start time plus 7 gives correct hours for before lecture
    interval.hour = event.startTime + 7 - 7
    interval.minute = 60 - minsBeforeNotification - 6
    
    let notificationTimeAndDate = convertUMTtoNZT(current: Calendar.current.date(byAdding: interval, to: mondaysDate)!)
    
    let localNotification = UILocalNotification()
    localNotification.timeZone = TimeZone(identifier: "NZST")
    localNotification.fireDate = notificationTimeAndDate
    // Message example: COSC345 Lecture coming up at 11
    let notificationMessage = "\((event.code)!) \((event.type)!) coming up at \((event.startTime)! + 8)"
    localNotification.alertBody = notificationMessage
    
    
    //set the notification
    UIApplication.shared.scheduleLocalNotification(localNotification)
}

// Account for the default UMT time, which is giving wrong date regardless of how the timezone is set!!!
func convertUMTtoNZT(current: Date) -> Date{
    var timeDiff = DateComponents()
    //NZ is + 13. Will break for DST, should try to get proper timezones working eventually.
    timeDiff.hour = 13
    let updated = Calendar.current.date(byAdding: timeDiff, to: current)
    return (updated)!
}

