//
//  Cwrapper.swift
//  WingIt
//
//  Created by William Warren on 6/3/18.
//  Copyright © 2018 Noisive. All rights reserved.
//

import Foundation
func parseEvents(data: String) -> String{
    
    let CString = B_parseEvents(data.cString(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)))
    let dataString = String(cString: CString!)
    free(UnsafeMutablePointer(mutating: CString)) // We must free the memory that C++ created for the pointer.
    return dataString
}

func getFirstEventDate() -> String{
    let CString = B_getFirstEventDate()
    let dataString = String(cString: CString!)
    free(UnsafeMutablePointer(mutating: CString)) // We must free the memory that C++ created for the pointer.
    return dataString
}

func queryResult(index: Int32) -> String{
    let CString = B_queryResult(index)
    let dataString = String(cString: CString!)
    free(UnsafeMutablePointer(mutating: CString)) // We must free the memory that C++ created for the pointer.
    return dataString
}

