//
//  UIDataHandling.swift
//  WingIt
//
//  Created by William Warren on 10/9/17.
//  Copyright © 2017 Noisive. All rights reserved.
//

import Foundation

/** Adds the events retrieved from the C++ lib into the correct timeslots. */
func loadWeekData(VC: ViewController) {
    let formatter = DateFormatter()
    
    formatter.dateFormat = "yyyy-MM-dd" // ISO date format.
    
    // Gives date of most recent Monday
    let mondaysDate: Date = Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    
    // Cancel all previously scheduled notifications so that duplicates don't get added when we recreate the events
    UIApplication.shared.cancelAllLocalNotifications()
    
    var dayIndex = 0;
    
    while (dayIndex < VC.numberOfDaysInSection) {
        
        // Data is stored with Monday = 0
        var searchDate = Calendar.current.date(byAdding: .day, value: dayIndex, to: mondaysDate)!
        
        // ------------------------------------------------------------------
        // Temporary change to make data static based on first week in timetable data.
        // This means the same week of data is displayed every week.
        // FEATURE remove this when more than one week of data is loaded.

        let firstEventDateCString = getFirstEventDate()
        let firstEventDateString = String(cString: firstEventDateCString!)
        free(UnsafeMutablePointer(mutating: firstEventDateCString)) // We must free the memory that C++ created for the pointer.
        
        let firstMondaysDate = Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: formatter.date(from: firstEventDateString)!))
        searchDate = Calendar.current.date(byAdding: .day, value: dayIndex, to: firstMondaysDate!)!
        
        
        // End temp change -------------------------------------------------
        
        
        
        for event in getEventsForDate(searchDate: searchDate) {
            
            let eventArr = event.components(separatedBy: ",")
            
            //Define all data from CSV file and cast to correct data type.
            let uid = CLong(eventArr[0])!
            let dayNumber = Int(eventArr[1])! - 1 //Minus 1 as Monday should be 0
            let startTime = Int(eventArr[2])! - 8
            let duration = Int(eventArr[3])
            let types = getClassType(classString: eventArr[5])
            let paperCode = eventArr[6]
            let paperName = eventArr[7]
            let latitude = Double(eventArr[8])
            let longitude = Double(eventArr[9])
            let roomCode = eventArr[10]
            let roomName = eventArr[11]
            let eventDateString = eventArr[13]
            
            let eventDate = formatter.date(from: eventDateString)
            
            let lesson = Lesson(uid: uid, classID: paperCode, start: startTime, duration: duration!, code: paperCode, type: types, roomShort: roomCode, roomFull: roomName, paperName: paperName, day: dayNumber, eventDate: (eventDate)!, latitude: latitude!, longitude: longitude!)
            
            setNotification(event: lesson)
            
            let hour = lesson.startTime!
            
            VC.lessonData.append(lesson)
            
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
        let cstr = queryResult(index)
        let str = String(cString: cstr!)
        free(UnsafeMutablePointer(mutating: cstr)) // We must free the memory that C++ created for the pointer.
        arr.append(str)
        index += 1
    }
    return arr
}

func getClassType(classString: String) -> classType {
    switch classString {
    case "Lecture":
        return .lecture
    case "Practical":
        return .practical
    case "Computer Lab":
        return .lab
    case "Tutorial":
        return .tutorial
    default:
        print("Error, unknown class type. Return default color: lecture")
        return .lecture
    }
}
