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
    //=======================================================================================================
    
    private static let TIME_OFFSET: Int = 8
    
    //MARK: Static functions
    //=======================================================================================================
    
    public static func get24HourTimeFromIndexPath(row: Int) -> String {
        return row + self.TIME_OFFSET >= 10 ? "\(self.TIME_OFFSET + row):00" : "0\(self.TIME_OFFSET + row):00"
    }
    
}
