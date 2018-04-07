//
//  LessonCell.swift
//  WingIt
//
//  Created by Eli Labes on 6/04/18.
//  Copyright © 2018 Noisive. All rights reserved.
//

import UIKit

class LessonCell: UITableViewCell {

    //MARK: Outlets and variables
    //=============================================================
    
    //Misc
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var lessonContainer: UIStackView!
    
    //Left lesson
    @IBOutlet var leftLesson: UIView!
    @IBOutlet var rightLesson: UIView!
    @IBOutlet var leftLessonCode: UILabel!
    @IBOutlet var leftLessonBar: UIView!
    
    //Right lesson
    @IBOutlet var leftLessonRoom: UILabel!
    @IBOutlet var rightLessonCode: UILabel!
    @IBOutlet var rightLessonRoom: UILabel!
    @IBOutlet var rightLessonBar: UIView!
    
    //MARK: Tap handing
    //=============================================================
    
    override func awakeFromNib() {
       
    }
    
    //MARK: Functions
    //=============================================================
    
    public func hideLessons() {
        self.lessonContainer.isHidden = true
    }
    
    public func showLessons() {
        self.lessonContainer.isHidden = false
    }
    
    public func hideLeftLesson() {
        self.leftLesson.isHidden = true
    }
    
    public func hideRightLesson() {
        self.rightLesson.isHidden = true
    }
    
    public func hideLeftLessonLabels() {
        self.leftLessonCode.isHidden = true
        self.leftLessonRoom.isHidden = true
    }
    
    public func hideRightLessonLabels() {
        self.rightLessonCode.isHidden = true
        self.rightLessonRoom.isHidden = true
    }
}
