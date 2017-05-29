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
    
    @IBOutlet var TopToolbar: UIToolbar!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var menuButton: UIBarButtonItem!
    
    var lessonData = [Lesson]()
    
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
        
        let dateLabel : UIBarButtonItem = {
            
            let label = UILabel()
            label.text = "2/5"
            label.textColor = Constants.Colors.Theme
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.frame = CGRect(x: 0, y: 0, width: 30, height: 28)
            return UIBarButtonItem(customView: label)
        }()
        self.navigationItem.rightBarButtonItem = dateLabel
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        TopToolbar.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        
        makeMakeData()
    }
    
    func getClassType(classString: String) -> classType {
        switch classString {
        case "Lecture":
            return .lecture
        case "Practical":
            return .lab
        case "Tutorial":
            return .tutorial
        default:
            print("There was an error, return default lecture")
            return .lecture
        }
    }
    
    func makeMakeData() {
        
        guard let path = Bundle.main.path(forResource: "data", ofType: ".csv") else {return}
        
        let importer = CSVImporter<[String]>(path: path)
        importer.startImportingRecords { $0 }.onFinish { importedRecords in
            for record in importedRecords {
                
                //Define all data from CSV file and cast to correct data type.
                let dayNumber = Int(record[0])! - 1 //Minus 1 as Monday should be 0
                let startTime = Int(record[1])! - 8
                let duration = Int(record[2])
                let hexColor = record[3]
                let types = self.getClassType(classString: record[4])
                let paperCode = record[5]
                let paperName = record[6]
                let latitude = Double(record[7])
                let longitude = Double(record[8])
                let roomCode = record[9]
                let roomName = record[10]
                let buildingName = record[11]
                let date = record[12]
                
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
            

            for data in self.lessonData {
                print("Information passed to table view \(data.type)")
            }
        }
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
        self.navigationItem.title = dayArray[dayIndex]
    }
    
    func getCurrentXPage() -> Int {
        let xOffset = collectionView.contentOffset.x
        let width = collectionView.bounds.size.width
        return Int(ceil(xOffset / width))
    }
    
    @IBAction func yesterday(_ sender: Any) {
        let indexPath = IndexPath(item: getCurrentXPage() - 1, section: 0)
        if indexPath.row >= 0 && indexPath.row < 7 {
            collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        }
    }
    
    @IBAction func tomorrow(_ sender: Any) {
        
        let indexPath = IndexPath(item: getCurrentXPage() + 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let senderObject = sender as! Lesson
        
        let destinationVC = segue.destination as! DetailView
        destinationVC.lessonData = senderObject
        
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

