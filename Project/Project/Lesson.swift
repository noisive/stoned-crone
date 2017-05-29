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
}

struct Lesson {
    
    var classID : String!
    var startTime : Int!
    var length : Int!
    var code : String!
    var type : classType!
    var roomShort : String!
    var roomFull : String!
    var paperName : String!
    var day : Int!
    
    init(classID: String, start : Int, length: Int, code: String, type: classType, roomShort: String, roomFull : String, paperName: String, day: Int) {
        
        self.classID = classID
        self.startTime = start
        self.length = length
        self.code = code
        self.type = type
        self.roomShort = roomShort
        self.roomFull = roomFull
        self.paperName = paperName
        self.day = day
        
    }
    
}
