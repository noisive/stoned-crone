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
    
    // Add the notification time to the date of the event
    var interval = DateComponents()
    // Start time plus 7 gives correct hours for before lecture
    interval.hour = event.startTime + 7
    interval.minute = 60 - minsBeforeNotification
    
    let notificationTimeAndDate = Calendar.current.date(byAdding: interval, to: event.eventDate)!
    
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

