//
//  UIDataHandling.swift
//  WingIt
//
//  Created by William Warren on 10/9/17.
//  Copyright © 2017 Noisive. All rights reserved.
//

import Foundation

/** Adds the events retrieved from the C++ lib into the correct timeslots. */
func loadWeekData(VC: TimetableView) {
    
    // Cancel all previously scheduled notifications so that duplicates don't get added when we recreate the events
    UIApplication.shared.cancelAllLocalNotifications()
    
    var dayIndex = 0;
    while (dayIndex < VC.NUMBER_OF_DAYS_IN_SECTION) {
        var mondaysDate = getMondaysDate()
        // ------------------------------------------------------------------
        // Temporary change to make data static based on first week in timetable data.
        // This means the same week of data is displayed every week.
        // FEATURE remove this when more than one week of data is loaded.
        
        let firstEventDateString = getFirstEventDate()
        
        if (firstEventDateString == "0xCC"){
            print("Error: first event date string not found/set")
        }else{
            // TODO: Check date if no class on monday.
            let firstEventDate = dateFromISOString(str: firstEventDateString)
            if firstEventDate != nil {
                mondaysDate = getDateOfMostRecentMonday(from: firstEventDate!)
            }
        }
        // End temp change -------------------------------------------------
        
        // Data is stored with Monday = 0
        let searchDate = Calendar.current.date(byAdding: .day, value: dayIndex, to: mondaysDate)!

        for event in getEventsForDate(searchDate: searchDate) {
            let lesson = Lesson(eventCSVStr: event)
            VC.lessonData.append(lesson)
            setNotification(event: lesson)
            
            let hour = lesson.startTime!
            // Create array spots for each hour a class runs for (i.e. 2 hour tutorial gets two cells)
            for hoursIntoClass in 0..<lesson.duration! {
                if (VC.hourData[dayIndex][hour + hoursIntoClass]?.lesson == nil) {
                    VC.hourData[dayIndex][hour + hoursIntoClass] = (lesson: lesson.uid, nil)
                } else {
                    VC.hourData[dayIndex][hour]?.lesson2 = lesson.uid
                }
            }
        }
        dayIndex += 1
    }
    VC.collectionView.reloadData()
}

/** Retrieves the events for a given date from the C++ library. */
func getEventsForDate(searchDate: Date) -> [String]{
    
    let format = DateFormatter()
    format.dateFormat = "yyyy-MM-dd"
    format.timeZone = TimeZone.init(abbreviation: "NZST")
    let date = format.string(from: searchDate)

    var arr = [String]()
    let num = queryDate(date.cString(using: String.Encoding.utf8))
    var index: Int32 = 0
    
    while (index < num) {
        let str = queryResult(index: index)
        arr.append(str)
        index += 1
    }
    return arr
}

