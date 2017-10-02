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
    
    let dateFormatter = DateFormatter()
    // Currently we don't have the date...
    // DateFormatter.dateFormat = "yyyy-MM-dd'T'HH"
    dateFormatter.dateFormat = "HHmm"
    dateFormatter.timeZone = NSTimeZone.default
    
    let notificationTime = (event.startTime-1)*100+60-minsBeforeNotification
    let localNotification = UILocalNotification()
    localNotification.fireDate = dateFormatter.date(from: String(notificationTime))
    // Message example: COSC345 Lecture coming up at 11
    localNotification.alertBody = "\(event.code) \(event.type) coming up at \(event.startTime)"
    localNotification.timeZone = NSTimeZone.default
    
    //set the notification
    UIApplication.shared.scheduleLocalNotification(localNotification)
}
