//
//  BlankCellTableViewCell.swift
//  Project
//
//  Created by Eli Labes on 25/05/17.
//  Copyright © 2017 Eli Labes. All rights reserved.
//

import UIKit

class BlankCellTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet var timeLabel: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
