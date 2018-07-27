//
//  NotificationUtil.swift
//  WingIt
//
//  Created by William Warren on 7/27/18.
//  Copyright © 2018 Noisive. All rights reserved.
//

import Foundation
import UserNotifications

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
    
    scheduleNotification(datetime: convertNZTtoUTC(date: notificationTimeAndDate), message: notificationMessage, eventID: event.uid)
}

var notificationsAllowed = true
func scheduleNotification(datetime: Date, message: String, soundName: String? = nil, eventID: Int){
    if !notificationsAllowed{ return }
    if #available(iOS 10.0, *) {
        
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = message
        content.sound = UNNotificationSound.default()
        
        // Strip the date component and replace with just a weekday to have this repeat each week
        var cal = Calendar.current
        cal.timeZone = TimeZone(abbreviation: "UTC")!
        let triggerDatetime = cal.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: datetime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDatetime,
//        let triggerWeeklyDatetime = cal.dateComponents([.weekday,.hour,.minute,.second,], from: datetime)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeeklyDatetime,
                                                    repeats: false)
        
        let identifier = "WingItLocalNotification\(eventID)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error)
            }
        })
        // DEBUG: print notification description
        center.getPendingNotificationRequests(completionHandler: { notifs in
            for notif in notifs { print(notif) }
        })
        
    } else { // Pre-iOS 10
        let notification = UILocalNotification()
        notification.fireDate = datetime
        if let sound = soundName {
            notification.soundName = sound
        }else{
            notification.soundName = UILocalNotificationDefaultSoundName
        }
        notification.alertBody = message
        UIApplication.shared.scheduleLocalNotification(notification)
        // DEBUG print out currently scheduled notifications
        print(UIApplication.shared.scheduledLocalNotifications!)
    }
}

func clearLocalNotifications(){
    if #available(iOS 10.0, *) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }else{
        UIApplication.shared.cancelAllLocalNotifications()
    }
}

func getPendingNotificationTimes() -> [Date]{
    var notifDates = Array<Date>()
    if #available(iOS 10.0, *) {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: { notifs in
            for notif in notifs {
                // DEBUG: print notification description
                print(notif)
                let calTrig = notif.trigger as! UNCalendarNotificationTrigger
//                let comps = notif.trigger.dateComponents
//                notifDates.append(notif.trigger.nextTriggerDate()!)
            }
        })
//        let schedNotifs = center.getPendingNotificationRequests(completionHandler: <#([UNNotificationRequest]) -> Void#>)
    }else{
       let schedNotifs = UIApplication.shared.scheduledLocalNotifications ?? []
        for notif in schedNotifs {
            notifDates.append(notif.fireDate!)
        }
    }
    return notifDates
}

func requestNotificationPermission(application: UIApplication){
    if #available(iOS 10.0, *) {
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.badge, .alert, .sound];
        center.requestAuthorization(options: options) {
            (granted, error) in
            if granted {
                notificationsAllowed = true
            }else{
                print("Notifications not allowed")
                notificationsAllowed = false
            }
        }
    }else{
        application.registerUserNotificationSettings( UIUserNotificationSettings(
            types: [.alert, .badge, .sound], categories: nil))
    }
}

