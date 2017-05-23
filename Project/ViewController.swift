//
//  ViewController.swift
//  Project
//
//  Created by Eli Labes on 11/05/17.
//  Copyright © 2017 Eli Labes. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIToolbarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var ToggleSectionOutlet: UISegmentedControl!
    
    @IBOutlet var TopToolbar: UIToolbar!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var menuButton: UIBarButtonItem!
    
    var lessonData = [Lesson]()
    
    struct Constants {
        struct Colors {
            //Navy Blue
            static let Theme = UIColor(red:0.06, green:0.16, blue:0.31, alpha:1.0)
        }
        struct Formats {
            static let dayArray = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        }
    }
    
    
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
    
    func makeMakeData() {
        
        let lesson1 = Lesson(start: "09:00", length: 1, code: "BIOC351", type: .lab, roomShort: "BIG05", roomFull: "Biochemistry G05", paperName: "Advanced Protein Biochemistry", clashes: false)
        lessonData.append(lesson1)
        
        
        let lesson2 = Lesson(start: "10:00", length: 1, code: "BIOC351", type: .lecture, roomShort: "BISEM", roomFull: "Biochemistry Seminar Room", paperName: "Advanced Protein Biochemistry", clashes: false)
        lessonData.append(lesson2)
        
        
        let lesson3 = Lesson(start: "11:00", length: 5, code: "BIOC351", type: .lab, roomShort: "BIG05", roomFull: "Biochemistry G05", paperName: "Advanced Protein Biochemistry",clashes: false)
        lessonData.append(lesson3)
        
        let lesson3A = Lesson(start: "16:00", length: 1, code: "BIOC351", type: .lab, roomShort: "BIG05", roomFull: "Biochemistry G05", paperName: "Advanced Protein Biochemistry",clashes: true)
        lessonData.append(lesson3A)
        
        let lesson4 = Lesson(start: "16:00", length: 1, code: "COSC345", type: .tutorial, roomShort: "SDAV2", roomFull: "Saint David's Seminar Room 2", paperName: "Software Engineering", clashes: true)
        lessonData.append(lesson4)
        
        let lesson3B = Lesson(start: "17:00", length: 1, code: "BIOC351", type: .lab, roomShort: "BIG05", roomFull: "Biochemistry G05", paperName: "Advanced Protein Biochemistry",clashes: false)
        lessonData.append(lesson3B)
        
        
        self.collectionView.reloadData()
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
        cell.tableViewData = self.lessonData
        cell.tableView.reloadData()
        
        return cell
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let deviceOrientation = UIDevice.current.orientation
        var cellSize = CGSize()
        if deviceOrientation.isPortrait {
            cellSize = CGSize(width: self.view.frame.size.width, height: self.collectionView.frame.size.height)
            
        } else {
            cellSize = CGSize(width: self.view.frame.size.width / 7, height: self.collectionView.frame.size.height)
        }
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("caleldleldeldledlldele")
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
    
    @IBAction func toggleView(_ sender: Any) {
    
        
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

