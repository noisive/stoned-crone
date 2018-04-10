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
    
    @IBOutlet var ToggleSectionOutlet: UISegmentedControl!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var classCounter: UIBarButtonItem!
    
    var lessonData = [Lesson]()

    var thisIsFirstLoad = false
    
    var dateLabel : String = String()
    
    // 7 days if using one week. If you change this, change hourData's initialisation
    let numberOfDaysInSection = 7
    
    var hourData = [[(lesson: CLong?, lesson2: CLong?)?]](repeating: [(lesson: CLong?, lesson2: CLong?)?](repeating: nil, count: 14), count: 7)
    
    
    
    func scrollToCurrentDay(){
        
        // First scroll day
        let indexPath = IndexPath(item: getDayOfWeek()! - 1, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        self.navigationItem.title = Constants.Formats.dayArray[getDayOfWeek()! - 1]

    }

    
    
    @IBAction func updateTimetable(_ sender: Any) {
        
        self.present(NavigationService.displayLoginView(isUpdatingMode: true), animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        thisIsFirstLoad = true

        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: AppColors.NAV_TITLE_COLOR]
            self.navigationController?.navigationBar.prefersLargeTitles = true
            
            navigationItem.largeTitleDisplayMode = .always
        }
        self.navigationController?.navigationBar.shadowImage = UIImage()
    
        
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))

            // These allow tapping on the timetable view or swiping to close the menu
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }

        collectionView.delegate = self
        collectionView.dataSource = self

        

        // Do any additional setup after loading the view, typically from a nib.

        loadWeekData(VC: self)

        // Autoscroll to current day on startup
        scrollToCurrentDay()
        
    

    }
    

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        //1 week of data
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfDaysInSection
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : DayCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as! DayCollectionViewCell
        
        cell.dataByHour = self.hourData[indexPath.row]
        cell.tableViewData = self.lessonData
        cell.tableView.reloadData()
        cell.tableView.separatorColor = AppColors.CELL_SEPERATOR_COLOR
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
    
 
    
    func performSegue(with data: Lesson)  {
        self.navigationController?.pushViewController(NavigationService.displayDetailedClassView(lessonData: data), animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: self.collectionView.frame.size.height)
    }
    
    // FEATURE This may need to change if we are extending the number of days?? - WW
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let dayArray = Constants.Formats.dayArray
        let dayIndex = getCurrentXPage()
        if dayIndex < numberOfDaysInSection {
            self.navigationItem.title = dayArray[dayIndex]
        }
        
        
        var ids = [CLong]()
        hourData[getCurrentXPage()].forEach { (data:(lesson1: CLong?, lesson2: CLong?)?) in
            if let datas = data {
                if datas.lesson1 != nil { ids.append(datas.lesson1!)}
                if datas.lesson2 != nil { ids.append(datas.lesson2!)}
            }
        }
        ids = Array(Set(ids))
        if (ids.count == 0) {
            self.classCounter.title = "No classes today."
        } else if (ids.count == 1) {
            self.classCounter.title = "1 class today."
        } else {
            self.classCounter.title = "\(ids.count) classes today."
        }
    }


    // FEATURE Will also have to change if we are extending the number of days.
    // Currently labels by getting most recent monday, adding offset to that.
    
    
    
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

