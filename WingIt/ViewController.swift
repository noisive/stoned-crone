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

class ViewController: UIViewController, UIToolbarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PassData {
    
    @IBOutlet var ToggleSectionOutlet: UISegmentedControl!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var menuButton: UIBarButtonItem!
    
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

    func createDateLabel() {
        let date = calculateDayLabel()
        let dateLabel : UIBarButtonItem = {
            let label = UILabel()
            label.text = date
            label.textColor = Constants.Colors.Theme
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.textAlignment = .right
            label.frame = CGRect(x: 0, y: 0, width: 70, height: 28)
            return UIBarButtonItem(customView: label)
        }()
        self.navigationItem.rightBarButtonItem = dateLabel
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        thisIsFirstLoad = true
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            // These allow tapping on the timetable view or swiping to close the menu
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        loadWeekData(VC: self)
        
        // Autoscroll to current day on startup
        scrollToCurrentDay()
        
        // Puts the current date label in
        createDateLabel()
        
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
        
        cell.tableView.separatorColor = .clear
        cell.hourData = self.hourData[indexPath.row]
        cell.tableViewData = self.lessonData
        cell.tableView.reloadData()
        cell.passDelegate = self
        
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
        //Perform segue here
        self.performSegue(withIdentifier: "ShowDetail", sender: data)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.size.width, height: self.collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    // FEATURE This may need to change if we are extending the number of days?? - WW
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let dayArray = Constants.Formats.dayArray
        let dayIndex = getCurrentXPage()
        if dayIndex < numberOfDaysInSection {
            self.navigationItem.title = dayArray[dayIndex]
        }
        createDateLabel()
    }


    // FEATURE Will also have to change if we are extending the number of days.
    // Currently labels by getting most recent monday, adding offset to that.
    func calculateDayLabel() -> String {
        
        // Gives date of most recent Monday
        let mondaysDate: Date = Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        
        
        let format = DateFormatter()
        format.timeZone = TimeZone.autoupdatingCurrent
        format.timeZone = TimeZone(identifier: "NZST")
        format.dateFormat = "dd/MM"
        let offset = getCurrentXPage()
        
        
        // We are basically just adding 13 to UMT... DK how robust it is, but only thing that seems to work.
        // Test early and late in day.
        let offsetDate = convertUMTtoNZT(current: Calendar.current.date(byAdding: .day, value: offset, to: mondaysDate)!)
        
        return format.string(from: offsetDate)
    }
    
    
    func getCurrentXPage() -> Int {
        let xOffset = collectionView.contentOffset.x
        let width = collectionView.bounds.size.width
        return Int(ceil(xOffset / width))
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let senderObject = sender as! Lesson
        
        let destinationVC = segue.destination as! DetailView
        destinationVC.lessonData = senderObject
        
    }
  
}

