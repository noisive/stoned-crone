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

extension Date {
    func dayOfWeek() -> Int {
        if let USDayOfWeek: Int = Calendar.current.dateComponents([.weekday], from: self).weekday {
            return USDayOfWeek
        }
        return 0
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

func getDayOfWeek() -> Int? {
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

