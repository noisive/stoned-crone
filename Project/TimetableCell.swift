//
//  TimetableCell.swift
//  Project
//
//  Created by Eli Labes on 12/05/17.
//  Copyright © 2017 Eli Labes. All rights reserved.
//

import UIKit

class TimetableCell: UITableViewCell {

    @IBOutlet var lessonCode: UILabel!
    @IBOutlet var lessonRoom: UILabel!
    @IBOutlet var colorView: UIView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var seperatorLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //colorView.layer.cornerRadius = 2
        
    }
}
