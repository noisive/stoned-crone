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
    
    /** Adds the events retrieved from the C++ lib into the correct timeslots. */
    func loadWeekData() {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd" // ISO date format.
        
        // Gives date of most recent Monday
        let mondaysDate: Date = Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        
        // Cancel all previously scheduled notifications so that duplicates don't get added when we recreate the events
        UIApplication.shared.cancelAllLocalNotifications()
        
        var dayIndex = 0;
        
        while (dayIndex < numberOfDaysInSection) {
            
            // Data is stored with Monday = 0
            let searchDate = Calendar.current.date(byAdding: .day, value: dayIndex, to: mondaysDate)!
            
            for event in getEventsForDate(searchDate: searchDate) {
                
                let eventArr = event.components(separatedBy: ",")
                
                //Define all data from CSV file and cast to correct data type.
                let uid = CLong(eventArr[0])!
                let dayNumber = Int(eventArr[1])! - 1 //Minus 1 as Monday should be 0
                let startTime = Int(eventArr[2])! - 8
                let duration = Int(eventArr[3])
                let types = ViewController.getClassType(classString: eventArr[5])
                let paperCode = eventArr[6]
                let paperName = eventArr[7]
                let latitude = Double(eventArr[8])
                let longitude = Double(eventArr[9])
                let roomCode = eventArr[10]
                let roomName = eventArr[11]
                let eventDateString = eventArr[13]
                
                let eventDate = formatter.date(from: eventDateString)
                
                let lesson = Lesson(uid: uid, classID: paperCode, start: startTime, duration: duration!, code: paperCode, type: types, roomShort: roomCode, roomFull: roomName, paperName: paperName, day: dayNumber, eventDate: (eventDate)!, latitude: latitude!, longitude: longitude!)
                
                setNotification(event: lesson)
                
                let hour = lesson.startTime!
                
                self.lessonData.append(lesson)

                // Create array spots for each hour a class runs for (i.e. 2 hour tutorial gets two cells)
                for hoursIntoClass in 0..<lesson.duration! {
                    if (self.hourData[dayIndex][hour + hoursIntoClass]?.lesson == nil) {
                        hourData[dayIndex][hour + hoursIntoClass] = (lesson: lesson.uid, nil)
                    } else {
                        hourData[dayIndex][hour]?.lesson2 = lesson.uid
                    }
                }
                
            }
            dayIndex += 1
        }
        
        self.collectionView.reloadData()
        
    }
    
    /** Retrieves the events for a given date from the C++ library. */
    func getEventsForDate(searchDate: Date) -> [String]{
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        format.timeZone = TimeZone.init(abbreviation: "NZST")
        var date = format.string(from: searchDate)
        
        // ------------------------------------------------------------------
        // Temporary change to get based on weekday
        // FEATURE remove this when more than one week of data is loaded.
        let searchWeekday: Int = Calendar.current.component(.weekday, from: searchDate) - 2 // - 2 to make monday 0
        // Gives date of most recent Monday
        let mondaysDate = Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))
        
        // Add the day to monday
        var interval = DateComponents()
        interval.day = searchWeekday
        date = format.string(from: Calendar.current.date(byAdding: interval, to: mondaysDate!)!)
        
        // End temp change -------------------------------------------------
        
        
        var arr = [String]()
        
        let num = queryDate(date.cString(using: String.Encoding.utf8))
        var index: Int32 = 0
        
        while (index < num) {
            let cstr = queryResult(index)
            let str = String(cString: cstr!)
            free(UnsafeMutablePointer(mutating: cstr)) // We must free the memory that C++ created for the pointer.
            arr.append(str)
            index += 1
        }
        return arr
    }
    
    func scrollToCurrentDay(){
        
        // First scroll day
        let indexPath = IndexPath(item: self.getDayOfWeek()! - 1, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        self.navigationItem.title = Constants.Formats.dayArray[self.getDayOfWeek()! - 1]

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
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        loadWeekData()
        
        // Autoscroll to current day on startup
        scrollToCurrentDay()
        
        // Puts the current date label in
        createDateLabel()
        
    }
    
    
    
    static func getClassType(classString: String) -> classType {
        switch classString {
        case "Lecture":
            return .lecture
        case "Practical":
            return .practical
        case "Computer Lab":
            return .lab
        case "Tutorial":
            return .tutorial
        default:
            print("Error, unknown class type. Return default color: lecture")
            return .lecture
        }
    }
    
    func getDayOfWeek() -> Int? {
        let todayDate = Date()
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        // Weekday 1 is sunday, we want to return sunday as 7
        if weekDay == 1 {
            return 7
        }else{
            return weekDay - 1
        }
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
            //Get the current cell object for the current page
            //let currCell : DayCollectionViewCell = collectionView.cellForItem(at: IndexPath(row: getCurrentXPage(), section: 0)) as! DayCollectionViewCell
            
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

