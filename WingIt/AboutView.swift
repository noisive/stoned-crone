//
//  AboutView.swift
//  WingIt
//
//  Created by Eli Labes on 12/04/18.
//  Copyright © 2018 Noisive. All rights reserved.
//


import UIKit

class AboutView: UITableViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.revealViewController().rearViewRevealWidth = self.view.frame.width - 50
            
            // These allow tapping on the timetable view or swiping to close the menu
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }


}
