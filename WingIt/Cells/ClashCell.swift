//
//  ClashCell.swift
//  Project
//
//  Created by Eli Labes on 21/05/17.
//  Copyright © 2017 Eli Labes. All rights reserved.
//

import UIKit

class ClashCell: UITableViewCell {

    @IBOutlet weak var leftLessonLabel: UILabel!
    @IBOutlet weak var rightLessonLabel: UILabel!
    @IBOutlet var leftLesson: UIView!
    @IBOutlet var rightLesson: UIView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var seperatorLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        leftLesson.layer.cornerRadius = 2
        rightLesson.layer.cornerRadius = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
