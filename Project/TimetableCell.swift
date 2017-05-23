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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        colorView.layer.cornerRadius = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
