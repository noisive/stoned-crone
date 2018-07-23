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
    let formatter = DateFormatter()
    
    formatter.dateFormat = "yyyy-MM-dd" // ISO date format.
    
    let mondaysDate = getMondaysDate()
    
    // Cancel all previously scheduled notifications so that duplicates don't get added when we recreate the events
    UIApplication.shared.cancelAllLocalNotifications()
    
    var dayIndex = 0;
    
    while (dayIndex < VC.NUMBER_OF_DAYS_IN_SECTION) {
        
        // Data is stored with Monday = 0
        var searchDate = Calendar.current.date(byAdding: .day, value: dayIndex, to: mondaysDate)!
        
        // ------------------------------------------------------------------
        // Temporary change to make data static based on first week in timetable data.
        // This means the same week of data is displayed every week.
        // FEATURE remove this when more than one week of data is loaded.

        let firstEventDateString = getFirstEventDate()

        if (firstEventDateString == "0xCC"){
           print("Error: first event date string not found/set")
        }else{
            // TODO: Check date if no class on monday.
            let firstMondaysDate = getMondaysDate()
            searchDate = Calendar.current.date(byAdding: .day, value: dayIndex, to: firstMondaysDate)!
        }
        
        
        // End temp change -------------------------------------------------
        
        
        
        for event in getEventsForDate(searchDate: searchDate) {
            
            let eventArr = event.components(separatedBy: "|")
            // TODO these are sometimes force-unwrapped, causing crashes when the data is erroneous. Should be handled.
            
            //Define all data from CSV file and cast to correct data type.
            let uid = CLong(eventArr[0])!
            let dayNumber = Int(eventArr[1])! - 1 //Minus 1 as Monday should be 0
            let startTime = Int(eventArr[2])! - 8 // We start the day at 8 am
            let duration = Int(eventArr[3])
            let colour = eventArr[4]
            let type = eventArr[5]
            let paperCode = eventArr[6]
            let paperName = eventArr[7]
            let latitude = Double(eventArr[8])
            let longitude = Double(eventArr[9])
            let roomCode = eventArr[10]
            let roomName = eventArr[11]
            let building = eventArr[12]
            let eventDateString = eventArr[13]

            
            let eventDate = formatter.date(from: eventDateString)
            
            let lesson = Lesson(uid: uid, classID: paperCode, start: startTime, duration: duration!, colour: colour, code: paperCode, type: type, roomShort: roomCode, roomFull: roomName, building: building, paperName: paperName, day: dayNumber, eventDate: (eventDate)!, latitude: latitude!, longitude: longitude!)
            
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
    
//VC.lessonData.append(Lesson(uid: 20, classID: "COSC341", start: 3, duration: 4, colour: "", code: "COSC345", type: "Lecture", roomShort: "TG08", roomFull: "St. Davids theatre", paperName: "Software Engineering", day: 0, eventDate: Date(), latitude: -45.866714, longitude: 170.512027))
// VC.lessonData.append(Lesson(uid: 21, classID: "COSC301", start: 3, duration: 4, colour: "", code: "COSC301", type: "Lab", roomShort: "OWG38", roomFull: "St. Davids theatre", paperName: "Software", day: 0, eventDate: Date(), latitude: -45.866714, longitude: 170.512027))
////    
//  VC.lessonData.append(Lesson(uid: 22, classID: "COSC341", start: 3, duration: 4, colour: "", code: "PHYC18", type: "Tutorial", roomShort: "OWG34", roomFull: "St. Davids theatre", paperName: "Phyc", day: 0, eventDate: Date(), latitude: -45.866714, longitude: 170.512027))
////    
////
//    VC.hourData[4][2] = nil
//    VC.hourData[4][3] = ((lesson: 20, lesson2: nil))
//    VC.hourData[4][4] = ((lesson: 20, lesson2: nil))
//    VC.hourData[4][6] = ((lesson: 21, lesson2: 22))
//    
//    
//    
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

