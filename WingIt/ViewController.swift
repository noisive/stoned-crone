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
    
//    //Create an array of arrays that have nothing in them
//    var data = [[(lesson: String?, lesson2: String?)?]](repeating: [(lesson: String?, lesson2: String?)?](repeating: (lesson: String?, lesson2: String?)?, count: 14), count: 7)
//    
//    //var hourData [[(lesson: String?, lesson2: String?)?]](repeatElement((lesson: String?, lesson2: String?)?, count: 14)
//    //var hourData = [[(lesson: String?, lesson2: String?)?]])
    
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
        
        makeMakeData()
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
    
    func getClassType(classString: String) -> classType {
        switch classString {
        case "Lecture":
            return .lecture
        case "Practical":
            return .lab
        case "Computer Lab":
            return .lab
        case "Tutorial":
            return .tutorial
        default:
            print("Error, unknown class type. Return default: lecture")
            return .lecture
        }
    }
    
    func makeMakeData() {
        

        //guard let path = Bundle.main.path(forResource: "data", ofType: ".csv") else {return}
        let path = NSHomeDirectory()+"/Library/Caches/data.csv"
        
        let importer = CSVImporter<[String]>(path: path)
        importer.startImportingRecords { $0 }.onFinish { importedRecords in
            for record in importedRecords {
                
                //Define all data from CSV file and cast to correct data type.
                let dayNumber = Int(record[1])! - 1 //Minus 1 as Monday should be 0
                let startTime = Int(record[2])! - 8
                let duration = Int(record[3])
                _ = record[4]
                let types = self.getClassType(classString: record[5])
                let paperCode = record[6]
                let paperName = record[7]
                let latitude = Double(record[8])
                let longitude = Double(record[9])
                let roomCode = record[10]
                let roomName = record[11]
                _ = record[12]
                _ = record[13]
                
                //Create a new lesson
                
    
                let newLesson = Lesson(classID: paperCode, start: startTime, length: duration!, code: paperCode, type: types, roomShort: roomCode, roomFull: roomName, paperName: paperName, day: dayNumber, latitude: latitude!, longitude: longitude!)
                
                //Insert new lesson into the correct day array
                self.lessonData.append(newLesson)
            }
            
            for lesson in self.lessonData {
                let lessonID = lesson.classID
                let startIndex = lesson.startTime
                let iterations = lesson.length!
                let dayOfWeek = lesson.day
                
                for i in 0..<iterations {
                    if self.hourData[dayOfWeek!][startIndex! + i] == nil {
                        self.hourData[dayOfWeek!][startIndex! + i] = (lesson: lessonID, nil)
                    } else {
                        self.hourData[dayOfWeek!][startIndex! + i]?.lesson2 = lessonID
                    }
                }
            }
            
            
            self.collectionView.reloadData()
            print(self.getDayOfWeek()!)
            let indexPath = IndexPath(item: self.getDayOfWeek()!, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
            
            self.navigationItem.title = Constants.Formats.dayArray[self.getDayOfWeek()!]
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let dayArray = Constants.Formats.dayArray
        let dayIndex = getCurrentXPage()
        if dayIndex < 7 {
            self.navigationItem.title = dayArray[dayIndex]
        }
    
        calculateDayLabel()
    }
    
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

