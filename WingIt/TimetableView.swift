//
//  ViewController.swift
//  Project
//
//  Created by Eli Labes on 11/05/17.
//  Copyright © 2017 Eli Labes. All rights reserved.
//

import UIKit


protocol PassData {
    func performSegue(with data: Lesson)
}

class TimetableView: UIViewController, UIToolbarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PassData {
    
    
    //MARK: Outlets and variables
    //=============================================================
    
    //Outlets
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet weak var classCounterContainer: UIView!
    @IBOutlet var classCounter: UILabel!
    
    //Variables
    public var lessonData : [Lesson] = [Lesson]()
    public var hourData: [[(lesson: CLong?, lesson2: CLong?)?]]!
    private var thisIsFirstLoad: Bool = false
    
    //Constants
    public let NUMBER_OF_DAYS_IN_SECTION: Int = 7
    private let NUMBER_OF_SECTIONS: Int = 1
    private let IPHONE_5_HEIGHT: CGFloat = 568.0
    
    //MARK: View loading
    //=============================================================
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        self.scrollToCurrentDay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLooks()
        self.setupData()
        self.getClassCountForDay()
        self.doesDataNeedUpdate()
    }
    
    override func viewDidLayoutSubviews() {
        self.collectionView.reloadData()
    }
    
    //MARK: Functions
    //=============================================================
    
    private func setupLooks() {
        //Class counter
        self.classCounterContainer.layer.masksToBounds = true
        self.classCounterContainer.layer.cornerRadius = 18
        self.classCounterContainer.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        self.classCounterContainer.layer.borderWidth = 0.5
        
        //Menu
        if self.revealViewController() != nil {
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.revealViewController().rearViewRevealWidth = self.view.frame.width
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        //Navbar
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            
            if self.isDeviceIphone5() {
                navigationItem.largeTitleDisplayMode = .never
            } else {
                navigationItem.largeTitleDisplayMode = .always
            }
        }
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    private func setupData() {
        self.hourData = [[(lesson: CLong?, lesson2: CLong?)?]](repeating: [(lesson: CLong?, lesson2: CLong?)?](repeating: nil, count: 14), count: 7)
        self.thisIsFirstLoad = true
        
        loadWeekData(VC: self)

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func doesDataNeedUpdate() {
        if self.lessonData.count > 1 {
            let firstLesson: Lesson = self.lessonData[0]
            
            let currentWeekFromData = Calendar.current.component(.weekOfYear, from: firstLesson.eventDate)
            var currentWeekFromToday = Calendar.current.component(.weekOfYear, from: Date())
            
            //Current week from date thinks that sunday is a new week, so compensate for that
            if self.getDayOfWeek() == 6 {
                currentWeekFromToday -= 1
            }
            
            if (currentWeekFromData != currentWeekFromToday) {
                RMessage.showNotification(withTitle: "It looks like your timetable is out of date! Update now.", type: .warning, customTypeName: nil, callback: nil)
            }
        }
    }
    
    private func getDayOfWeek() -> Int {
        let weekday = Calendar(identifier: .gregorian).component(.weekday, from: Date())
        return weekday == 1 ? 6 : weekday - 2
    }
    
    private func scrollToCurrentDay(){
        
        let indexPath = IndexPath(item: self.getDayOfWeek(), section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .right, animated: false)
        let dayIndex = getCurrentXPage()
        self.navigationItem.title = Constants.Formats.dayArray[dayIndex]
//        self.navigationItem.title = Constants.Formats.dayArray[self.getDayOfWeek()]
    }
    
    public func isDeviceIphone5() -> Bool {
        if (self.view.frame.size.height == self.IPHONE_5_HEIGHT) {
            return true
        }
        return false
    }
    
    internal func performSegue(with data: Lesson)  {
        self.navigationController?.pushViewController(NavigationService.displayDetailedClassView(lessonData: data), animated: true)
    }
    
    private func getClassCountForDay() {
        var uniqueSubjectIDs = [CLong]()
        self.hourData[self.getCurrentXPage()].forEach { (data:(lesson1: CLong?, lesson2: CLong?)?) in
            if let subject = data {
                if let lessonOne = subject.lesson1 { uniqueSubjectIDs.append(lessonOne)}
                if let lessonTwo = subject.lesson2 { uniqueSubjectIDs.append(lessonTwo)}
            }
        }
        uniqueSubjectIDs = Array(Set(uniqueSubjectIDs))
        self.classCounter.text = "\(uniqueSubjectIDs.count) class" + "\(uniqueSubjectIDs.count != 1 ? "es" : "")"
    }
    
    //MARK: Actions
    //=============================================================
    
    @IBAction func updateTimetable(_ sender: Any) {
        self.present(NavigationService.displayLoginView(isUpdatingMode: true), animated: true, completion: nil)
    }
    
    //MARK: Delegates
    //=============================================================
    
    //Collection view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.NUMBER_OF_SECTIONS
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.NUMBER_OF_DAYS_IN_SECTION
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : DayCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: AppCells.DAY_CELL, for: indexPath) as! DayCollectionViewCell
        
        cell.dataByHour = self.hourData[indexPath.row]
        cell.tableViewData = self.lessonData
        cell.tableView.reloadData()
        cell.passDelegate = self
        cell.currentXOffset = indexPath.row
        
        // Scroll to current time if app has just loaded, otherwise scroll new cell to same time as current one.
        if thisIsFirstLoad {
            cell.scrollToCurrentTime()
            thisIsFirstLoad = false
        }else{
            
            //Get the current page
            if let cellSelected = self.collectionView.indexPathsForVisibleItems.first {
                
                let currCellIndex = IndexPath(row: cellSelected.row, section: 0)
                
                //Get the current cell object for the current page
                let currCell : DayCollectionViewCell = collectionView.cellForItem(at: currCellIndex) as! DayCollectionViewCell
                
                //Get the tableview offeset for the current cell objects tableview
                let currentOffsetY = currCell.tableView.contentOffset.y
                
                cell.tableView.contentOffset.y = currentOffsetY
                
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height)
    }
   
    //Scroll view
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let dayArray = Constants.Formats.dayArray
        let dayIndex = getCurrentXPage()
        if dayIndex < self.NUMBER_OF_DAYS_IN_SECTION {
            self.navigationItem.title = dayArray[dayIndex]
        }
        
        self.getClassCountForDay()
    }
    
    func getCurrentXPage() -> Int {
        let xOffset = collectionView.contentOffset.x
        let width = collectionView.bounds.size.width
        return Int(ceil(xOffset / width))
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let senderObject = sender as! Lesson
            let destinationVC = segue.destination as! DetailView
            destinationVC.lessonData = senderObject
        }
    }
}


