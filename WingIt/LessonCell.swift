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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
