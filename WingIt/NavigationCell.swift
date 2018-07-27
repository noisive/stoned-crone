//
//  NavigationCell.swift
//  WingIt
//
//  Created by Eli Labes on 18/04/18.
//  Copyright © 2018 Noisive. All rights reserved.
//

import UIKit

class NavigationCell: UITableViewCell {

    //MARK: Outlets & Variables
    //================================================================
    
    //Outlets
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    //Variables
    private let CORNER_RADIUS: CGFloat = 5.0
    var preferredStatusBarStyle: UIStatusBarStyle{return .lightContent}

    //MARK: Nib loading
    //================================================================
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    //MARK: Delegates
    //================================================================
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

// Required for UIBarStyle to set correctly
extension UITabBarController {
    open override var childViewControllerForStatusBarStyle: UIViewController? {
        return selectedViewController
    }
}
extension UINavigationController {
    open override var childViewControllerForStatusBarStyle: UIViewController? {
        return visibleViewController
    }
}
