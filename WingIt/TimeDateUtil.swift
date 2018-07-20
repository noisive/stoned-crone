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
//
//// Returns 1 for sunday, 7 for saturday
//func dayOfWeek() -> Int {
//    let myCalendar = Calendar(identifier: .gregorian)
//    let weekDay = myCalendar.component(.weekday, from: todaysDate())
//    return weekDay
//}

func getDayOfWeek() -> Int {
    let todayDate = todaysDate()
    let myCalendar = Calendar(identifier: .gregorian)
    let weekDay = myCalendar.component(.weekday, from: todayDate)
    // Weekday 1 is sunday, we want to return sunday as 7
    if weekDay == 1 {
        return 7
    }else{
        return weekDay - 1
    }
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
    // Allows mocking the date for testing
    if let _ = mockDate {
        return mockDate!
    }else{
        return Date()
    }
    
}

var mockDate: Date?

// If called without argument, will use default date.
func mockDateTime(mockStrO: String?=nil){
    var mockStr: String
    // 1st Oct is a monday. Nice num to work with.
    let defaultDate = "2018-10-01"
    let defaultTime = "+23:00"
    let defaultDateTime = defaultDate + defaultTime
    if let _ = mockStrO {
        mockStr = mockStrO!
    }else{
        mockStr = defaultDate
    }
    let formatter = DateFormatter()
    let formatStr = "yyyy-MM-dd+HH:mm" // ISO datetime format.
    formatter.dateFormat = formatStr
    //    let mockStrWithTime = mockStr + "+13:00"
    if let mockDateOpt = formatter.date(from: mockStr){
        mockDate = mockDateOpt
        //    } else if let mockDateOpt = formatter.date(from: mockStrWithTime){
    } else if let mockDateOpt = formatter.date(from: mockStr + defaultTime){
        mockDate = mockDateOpt
    } else {
        print("Error: Invalid date argument format: \"\(mockStr)\". Will be set to mon, \(defaultDateTime)")
        print("Expect form `mockDate [dateTime]`, where [dateTime] is of form \(formatStr). The time portion is optional.")
        mockDate = formatter.date(from: defaultDate)
    }
}

func HandleLaunchArgs() {
    //    let userDefaults: UserDefaults
    var args = CommandLine.arguments
    
    // Resets app if given argument resetdata, so that tests start from a consistent clean state
    if args.contains("-reset") {
        //        let defaultsName = Bundle.main.bundleIdentifier!
        //    userDefaults.removePersistentDomain(forName: defaultsName)
        clearCache()
    }
    
    
    if args.contains("-UITests") {
        UIApplication.shared.keyWindow?.layer.speed = 100
    }
    
    
    // Resets app if given argument resetdata, so that tests start from a consistent clean state
    if args.contains("-fakeData") {
        copyTestData()
        if !args.contains("-mockDate") {
            mockDateTime() // Will use default
        }
    }
    
    // Expect argument of the form "mockDate [date]",
    // where [date] is of the ISO form yyyy-MM-dd.
    //    if args.contains("-mockDate") {
    //        if let mockDateStr = UserDefaults.standard.string(forKey: "mockDate"){
    if let i = args.index(of: "-mockDate"){
        let mockDateStr = args[i+1]
        mockDateTime(mockStrO: mockDateStr)
    }
    if let i = args.index(of: "-mockTime"){
        let mockTimeStr = args[i+1]
        mockDateTime(mockStrO: mockTimeStr)
    }
    //    }
    
}
