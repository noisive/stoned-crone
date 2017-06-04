//
//  Constants.swift
//  Project
//
//  Created by Eli Labes on 21/05/17.
//  Copyright © 2017 Eli Labes. All rights reserved.
//

import Foundation



struct Constants {
    struct Colors {
        //Navy Blue
        static let Theme = UIColor(red:0.06, green:0.16, blue:0.31, alpha:1.0)
        
        //Lab Color
        static let labColor = UIColor(red:0.04, green:0.73, blue:0.97, alpha:1.0)
        
        //Lecture Color
        static let lectureColor = UIColor(red:0.83, green:0.83, blue:0.83, alpha:1.0)
        
        //Tutorial Color
        static let tutorialColor = UIColor(red:1.00, green:0.60, blue:0.00, alpha:1.0)
        
        //Exam Color
        static let examColor = UIColor(red:0.06, green:0.31, blue:0.55, alpha:1.0)
        
    }
    struct Formats {
        static let dayArray = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        
        enum classType {
            case lecture
            case lab
            case tutorial
        }
    }
    
   
}
