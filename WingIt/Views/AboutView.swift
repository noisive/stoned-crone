//
//  AboutView.swift
//  WingIt
//
//  Created by Eli Labes on 12/04/18.
//  Copyright © 2018 Noisive. All rights reserved.
//


import UIKit

class AboutView: UITableViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle{return .lightContent}
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.revealViewController().rearViewRevealWidth = self.view.frame.width
            
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
