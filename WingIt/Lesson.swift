//
//  Lesson.swift
//  Project
//
//  Created by Eli Labes on 15/05/17.
//  Copyright © 2017 Eli Labes. All rights reserved.
//

import Foundation

enum classType {
    case lecture
    case lab
    case tutorial
    case practical
}

struct Lesson {
    
    var uid : CLong!
    var classID : String!
    var startTime : Int!
    var duration : Int!
    var code : String!
    var type : classType!
    var roomShort : String!
    var roomFull : String!
    var paperName : String!
    var day : Int!
    var eventDate: Date
    var colour : String!
    var latitude : Double!
    var longitude : Double!
    
    init(uid: CLong, classID: String, start : Int, duration: Int, colour: String, code: String, type: classType, roomShort: String, roomFull : String, paperName: String, day: Int, eventDate: Date, latitude: Double, longitude: Double) {
    //init(uid: CLong, classID: String, start : Int, length: Int, code: String, type: classType, roomShort: String, roomFull : String, paperName: String, day: Int, latitude: Double, longitude: Double) {
        self.uid = uid;
        self.classID = classID
        self.startTime = start
        self.duration = duration
        self.colour = code
        self.code = code
        self.type = type
        self.roomShort = roomShort
        self.roomFull = roomFull
        self.paperName = paperName
        self.day = day
        self.eventDate = eventDate
        self.latitude = latitude
        self.longitude = longitude
        
    }
    
}
