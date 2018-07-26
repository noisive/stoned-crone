//
//  DateUtil.swift
//  WingIt
//
//  Created by Eli Labes on 5/04/18.
//  Copyright © 2018 Noisive. All rights reserved.
//

import Foundation


public class TimeUtil {
    
    //MARK: Static variables
    //=============================================================================
    
    private static let TIME_OFFSET: Int = 8
    
    //MARK: Static functions
    //=============================================================================
    
    public static func get24HourTimeFromIndexPath(row: Int) -> String {
        return row + self.TIME_OFFSET >= 10 ? "\(self.TIME_OFFSET + row):00" : "0\(self.TIME_OFFSET + row):00"
    }
    
}

func getDateFromISOString(str: String) -> Date?{
    let formatter = DateFormatter()
    let defaultTZ = " UTC"
    let defaultTime = "+12:00" + defaultTZ
    let formatStr = "yyyy-MM-dd+HH:mm zzz" // ISO datetime format.
    formatter.dateFormat = formatStr
    var date: Date?
    if let dateOpt = formatter.date(from: str + defaultTZ){
        date = dateOpt
        //    } else if let mockDateOpt = formatter.date(from: mockStrWithTime){
    } else if let dateOpt = formatter.date(from: str + defaultTime){
        date = dateOpt
    } else {
        print("Error: Invalid date argument format: \"\(str)\".")
        print("Expected form \(formatStr) (without the timezone). The time portion is optional.")
    }
    return date
}

func getDayOfWeek(date: Date) -> Int {
    let formatter = DateFormatter()
    let formatStr = "e" // Just gives day of week, with Wed=2
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    formatter.dateFormat = formatStr
    var weekDay = Int(formatter.string(from: date))! - 1 // -1 is hack because this always returns the wrong number.
    if weekDay == -1 { // Sat
        weekDay = 6
    }
    if weekDay == 0 { // Sunday, which we want to treat as 7
        weekDay = 7
    }
    return weekDay
}
func getDayOfWeek() -> Int {
    return getDayOfWeek(date: todaysDate())
}

func getMondaysDate() -> Date {
    let today = todaysDate()
    return getDateOfMostRecentMonday(from: today)
}

func getDateOfMostRecentMonday(from dateI: Date) -> Date {
    var date = dateI
    // Sunday should be treated same week, but is considered the start of the next week
    // so if today is sunday, substract 1 day so the calc is run from saturday.
    if getDayOfWeek() == 7 { //Sunday
        var interval = DateComponents()
        interval.day = -1
        date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
    }
    var comp: DateComponents = Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
    comp.timeZone = TimeZone(secondsFromGMT: 0)
    let mondayDate = Calendar(identifier: .iso8601).date(from: comp)!
    //    print("Monday \(mondayDate)")
    return mondayDate
}

// Account for the default UMT time, which is giving wrong date regardless of how the timezone is set!!!
func convertUMTtoNZT(current: Date) -> Date{
    var timeDiff = DateComponents()
    //NZ is + 13. Will break for DST, should try to get proper timezones working eventually.
    timeDiff.hour = 13
    let updated = Calendar.current.date(byAdding: timeDiff, to: current)
    return (updated)!
}

func todaysDate() -> Date {
    var date: Date
    
    // Allows mocking the date for testing
    if let _ = mockDate {
        date = mockDate!
    }else{
        date = Date()
    }
    #if debug
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(identifier: "UTC")!
    let formatStr = "eee, yyyy-MM-dd+HH:mm zzz" // ISO datetime format.
    formatter.dateFormat = formatStr
    print(formatter.string(from: date))
    #endif
    return date
}

var mockDate: Date?

// If called without argument, will use default date.
func mockDateTime(mockStrO: String?=nil){
    var mockStr: String
    // 1st Oct is a monday. Nice num to work with.
    let defaultDate = "2018-10-01"
    if let _ = mockStrO {
        mockStr = mockStrO!
    }else{
        mockStr = defaultDate
    }
    if let mockDateOpt = getDateFromISOString(str: mockStr){
        mockDate = mockDateOpt
    } else {
        print("Error: Invalid date argument format: \"\(mockStr)\". Will be set to mon, \(defaultDate)")
        mockDate = getDateFromISOString(str: defaultDate)
    }
}

