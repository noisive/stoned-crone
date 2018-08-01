//
//  MenuTableViewController.swift
//  Project
//
//  Created by Eli Labes on 15/05/17.
//  Copyright © 2017 Eli Labes. All rights reserved.
//

import UIKit

class MenuTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: Outlets & Variables
    //=================================================================
    
    //Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var iconContainer: UIView!
    @IBOutlet weak var welcomeMessage: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    
    //Constants
    private let NAVIGATION_DATA: [(title: String, image: UIImage)] = [
        (title: "Today", image: #imageLiteral(resourceName: "Meeting_000000_100")),
        (title: "Log out/change login", image: #imageLiteral(resourceName: "Meeting_000000_100")),
        (title: "About", image: #imageLiteral(resourceName: "Meeting_000000_100"))
    ]
    private let WELCOME_MESSAGES: [String] = [
        "Have a great day!",
        "Thanks for stopping by!",
        "Enjoy class today!"
    ]
    private let CELL_HEIGHT: CGFloat = 60.0
    private let ICON_CORNER_RADIUS: CGFloat = 8.0
    private let NUMBER_OF_SECTIONS: Int = 1;
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: View loading
    //=================================================================
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLooks()
        self.setupDelegates()
    }
    
    //MARK: Functions
    //=================================================================
    
    private func setupDelegates() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func setupLooks() {
        self.tableView.separatorColor = UIColor.white.withAlphaComponent(0.1)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
        self.iconContainer.layer.cornerRadius = self.ICON_CORNER_RADIUS
        self.tableView.separatorColor = AppColors.CELL_SEPERATOR_COLOR
        var preferredStatusBarStyle: UIStatusBarStyle{return .lightContent}
        
        let randomIndex: Int = Int(arc4random_uniform(UInt32(self.WELCOME_MESSAGES.count) + 0))
        self.welcomeMessage.text = self.WELCOME_MESSAGES[randomIndex]
        
        if let versionNum = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as? String {
            versionLabel.text = "Version " + versionNum
        }
            
    }
    
    //MARK: Actions
    //=================================================================
    
    @IBAction func dismiss(_ sender: Any) {
        self.performSegue(withIdentifier: "ShowTimetable", sender: self)
    }
    
    @IBAction func sendFeedback(_ sender: Any) {
        let facebookURL = NSURL(string: "fb://page/1440825302620780")!
        if UIApplication.shared.canOpenURL(facebookURL as URL) {
            UIApplication.shared.openURL(facebookURL as URL)
        } else {
            UIApplication.shared.openURL(NSURL(string: "https://www.facebook.com/1440825302620780")! as URL)
        }
    }
    
    @IBAction func share(_ sender: Any) {
        let text = "Want to track your Univerity timetable? Download WingIt from the app store now! https://www.facebook.com/pg/WingIteVision/"
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    //MARK: Delegates
    //=================================================================
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.NUMBER_OF_SECTIONS
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.NAVIGATION_DATA.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: AppCells.NAVIGATION_CELL, for: indexPath)
        
        let navigationItem = self.NAVIGATION_DATA[indexPath.row]
        
        cell.textLabel?.text = navigationItem.title
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.CELL_HEIGHT
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            // TODO: Make this a better solution. CUrrently, current day isn't remembered when entering menu.
            // But then, maybe this is an ok solution? But exit button should return to current...
            appDelegate.firstLoadSoScrollToToday = true
            self.performSegue(withIdentifier: "ShowTimetable", sender: self)
        } else if indexPath.row == 1 {
            clearCache()
            removeStoredUserPass()
            self.performSegue(withIdentifier: "LogOut", sender: self)
        } else if indexPath.row == 2 {
            self.performSegue(withIdentifier: "ShowAbout", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
//    //MARK: Pass data
//    //=================================================================
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "LogOut" {
//            let destination = segue.destination as! LoginView
//            destination.isUpdatingMode = false
//        }
//    }
}
