//
//  ViewController.swift
//  Project
//
//  Created by Eli Labes on 11/05/17.
//  Copyright © 2017 Eli Labes. All rights reserved.
//

import UIKit
import CSVImporter

protocol PassData {
    func performSegue(with data: Lesson)
}

class ViewController: UIViewController, UIToolbarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PassData {
    
    @IBOutlet var ToggleSectionOutlet: UISegmentedControl!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var menuButton: UIBarButtonItem!
    
    var lessonData = [Lesson]()
    
    var dateLabel : String = String()
    
    var hourData = [[(lesson: String?, lesson2: String?)?]](repeating: [(lesson: String?, lesson2: String?)?](repeating: nil, count: 14), count: 7)
 
    /** Adds the events retrieved from the C++ lib into the correct timeslots. */
    func loadWeekData() {
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd" // ISO date format.
        
        let weekday = Calendar.current.component(.weekday, from: date)
        
        var dayIndex = 0;
        
        while (dayIndex < 7) {
            
            let lookupDay = Calendar.current.date(byAdding: .day, value: -(weekday - 2) + dayIndex, to: date)!
            let day = Calendar.current.component(.day, from: lookupDay) - (weekday)
            
            for event in getEventsForDay(date: formatter.string(from: lookupDay)) {
                
                let eventArr = event.components(separatedBy: ",")
            
                //Define all data from CSV file and cast to correct data type.
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
                
                let lesson = Lesson(classID: paperCode, start: startTime, length: duration!, code: paperCode, type: types, roomShort: roomCode, roomFull: roomName, paperName: paperName, day: dayNumber, latitude: latitude!, longitude: longitude!)
                
                let hour = lesson.startTime!
                
                self.lessonData.append(lesson)
                let iterations = lesson.length!
                
                for i in 0..<iterations {
                    if (self.hourData[day][hour + i]?.lesson == nil) {
                        hourData[day][hour + i] = (lesson: lesson.classID, nil)
                    } else {
                        hourData[day][hour]?.lesson2 = lesson.classID
                    }
                }
            }
            dayIndex += 1
        }
        
        self.collectionView.reloadData()
        let indexPath = IndexPath(item: self.getDayOfWeek()!, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        
        self.navigationItem.title = Constants.Formats.dayArray[self.getDayOfWeek()!]
    }
    
    /** Retrieves the events for a given date from the C++ library. */
    func getEventsForDay(date: String) -> [String] {
        var arr = [String]()
        
        let num = numEvents(date.cString(using: String.Encoding.utf8))
        var index: Int32 = 0
        
        while (index < num) {
            let cstr = getEventsByDate(date.cString(using: String.Encoding.utf8), index)
            let str = String(cString: cstr!)
            free(UnsafeMutablePointer(mutating: cstr)) // We must free the memory that C++ created for the pointer.
            arr.append(str)
            index += 1
        }
        return arr
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        calculateDayLabel()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

        // Do any additional setup after loading the view, typically from a nib.
        
        loadWeekData()
    }
    
    func createDateLabel(date: String) {
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
        return weekDay - 2
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        //1 week of data
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
        //7 days
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : DayCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as! DayCollectionViewCell
        
        cell.tableView.separatorColor = .clear
        cell.hourData = self.hourData[indexPath.row]
        cell.tableViewData = self.lessonData
        cell.tableView.reloadData()
        cell.passDelegate = self
        

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
        if dayIndex < 7 { //ALERT, MAGIC NUM
            self.navigationItem.title = dayArray[dayIndex]
        }
    
        calculateDayLabel()
    }
    
    // BUG This should change, there is a bug here. Date starts at current day, should start at Monday.
    // FEATURE Will also have to change if we are extending the number of days.
    func calculateDayLabel() {
        
        let today = Date()
        let format = DateFormatter()
        format.dateFormat = "dd/MM"
        let offset = getDayOfWeek()! > getCurrentXPage() ? -getCurrentXPage() : getCurrentXPage()
     
        let offsetDate = Calendar.current.date(byAdding: .day, value: offset, to: today)
        
        createDateLabel(date: format.string(from: offsetDate!))
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

