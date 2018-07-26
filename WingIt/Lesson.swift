//
//  Lesson.swift
//  Project
//
//  Created by Eli Labes on 15/05/17.
//  Copyright © 2017 Eli Labes. All rights reserved.
//

import Foundation

public class Lesson {
    
    var uid : CLong!
    var classID : String!
    var startTime : Int!
    var duration : Int!
    var code : String!
    var type : String!
    var roomShort : String!
    var roomFull : String!
    var building : String!
    var paperName : String!
    var day : Int!
    var eventDate: Date
    var colour : String!
    var latitude : Double!
    var longitude : Double!
    
    init(uid: CLong, classID: String, start : Int, duration: Int, colour: String, code: String, type: String, roomShort: String, roomFull : String, building: String, paperName: String, day: Int, eventDate: Date, latitude: Double, longitude: Double) {
    //init(uid: CLong, classID: String, start : Int, length: Int, code: String, type: classType, roomShort: String, roomFull : String, paperName: String, day: Int, latitude: Double, longitude: Double) {
        self.uid = uid;
        self.classID = classID
        self.startTime = start
        self.duration = duration
        self.colour = colour
        self.code = code
        self.type = type
        self.roomShort = roomShort
        self.roomFull = roomFull
        self.building = building
        self.paperName = paperName
        self.day = day
        self.eventDate = eventDate
        self.latitude = latitude
        self.longitude = longitude
        
    }
    
    /* Converts a cpp eventString into a Lesson object */
    convenience init(eventCSVStr: String){
        let eventArr = eventCSVStr.components(separatedBy: "|")
        // TODO these are sometimes force-unwrapped, causing crashes when the data is erroneous. Should be handled.
        
        //Define all data from CSV file and cast to correct data type.
        let uid = CLong(eventArr[0])!
        let dayNumber = Int(eventArr[1])!
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
        let eventDate = dateFromISOString(str: eventDateString)
        
        self.init(uid: uid, classID: paperCode, start: startTime, duration: duration!, colour: colour, code: paperCode, type: type, roomShort: roomCode, roomFull: roomName, building: building, paperName: paperName, day: dayNumber, eventDate: (eventDate)!, latitude: latitude!, longitude: longitude!)
    }

}
