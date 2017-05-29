//
//  DayCollectionViewCell.swift
//  Project
//
//  Created by Eli Labes on 11/05/17.
//  Copyright © 2017 Eli Labes. All rights reserved.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var passDelegate : PassData?
    
    
    //Create an array of arrays that have nothing in them
    var hourData = [(lesson: String?, lesson2: String?)?](repeatElement(nil, count: 14))
    
    var tableViewData = [Lesson]()
    
    override func awakeFromNib() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 8, right: 0)
   
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hourData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataPath = hourData[indexPath.row]
        
        
        
        var cell : UITableViewCell = UITableViewCell()
        
        if dataPath == nil {
            let blankCell : BlankCellTableViewCell = tableView.dequeueReusableCell(withIdentifier:
                "BlankCell", for: indexPath) as! BlankCellTableViewCell
            
            blankCell.timeLabel.text = indexPath.row + 8 >= 10 ? "\(8 + indexPath.row):00" : "0\(8 + indexPath.row):00"
            cell = blankCell
            
        } else if dataPath?.lesson != nil && dataPath?.lesson2 == nil {
            let singleCell : TimetableCell = tableView.dequeueReusableCell(withIdentifier:
                "TimetableCell", for: indexPath) as! TimetableCell
            
            if let lessonData = findData(classID: (dataPath?.lesson)!) {
                singleCell.lessonCode.text = lessonData.code
                singleCell.lessonRoom.text = lessonData.roomShort
                
                
                print("This is type \(lessonData.type)")
                
                //Setup time table, color and style.
                setupCell(Appearance: singleCell, indexPath: indexPath, type: lessonData.type)
            }
            singleCell.timeLabel.text = indexPath.row + 8 >= 10 ? "\(8 + indexPath.row):00" : "0\(8 + indexPath.row):00"
            
            cell = singleCell
        } else if dataPath?.lesson != nil && dataPath?.lesson2 != nil {
            let clashCell : ClashCell = tableView.dequeueReusableCell(withIdentifier:
                "ClashCell", for: indexPath) as! ClashCell
            clashCell.leftLesson.backgroundColor = Constants.Colors.labColor
            
            if let lessonData1 = findData(classID: (dataPath?.lesson)!), let lessonData2 = findData(classID: (dataPath?.lesson2)!) {
                clashCell.leftLessonLabel.text = lessonData1.code
                clashCell.rightLessonLabel.text = lessonData2.code
            }
            
            clashCell.timeLabel.text = indexPath.row + 8 >= 10 ? "\(8 + indexPath.row):00" : "0\(8 + indexPath.row):00"
            
            cell = clashCell
        }
        cell.selectionStyle = .none
        return cell
    }
    
   
    
    //Find the lesson object that matches the class code
    func findData(classID: String) -> Lesson? {
        if let data = tableViewData.filter({$0.classID == classID}).first {
            return data
        }
        return nil
    }
    
    func setupCell(Appearance cell: TimetableCell, indexPath: IndexPath, type: classType) {
        cell.colorView.backgroundColor = calculateLessonColor(classType: type)
        
        let lessonData = hourData[indexPath.row]
        
        if indexPath.row > 0 {
            switch true {
            // If the cell above is equal, connect the two and remove exces data
            case lessonData?.lesson == hourData[indexPath.row - 1]?.lesson:
                cell.colorView.topAnchor.constraint(equalTo: cell.topAnchor, constant: 0).isActive = true
                cell.seperatorLine.isHidden = true
                cell.lessonCode.isHidden = true
                cell.lessonRoom.isHidden = true
                
                //if the cell does not continue to another, round edges off
                if lessonData?.lesson != hourData[indexPath.row + 1]?.lesson {
                    roundEdges(view: cell.colorView, corners: [.bottomLeft, .bottomRight])
                }

            case hourData[indexPath.row + 1]?.lesson == lessonData?.lesson:
                
                roundEdges(view: cell.colorView, corners: [.topLeft, .topRight])
                
            default:
                cell.lessonRoom.isHidden = false
                cell.lessonCode.isHidden = false
                cell.seperatorLine.isHidden = false
                cell.colorView.layer.cornerRadius = 2
            }
        }
    }
    
    func roundEdges(view: UIView, corners: UIRectCorner) {
        let cellMask = CAShapeLayer()
        cellMask.path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: 2, height: 2)).cgPath
        view.layer.mask = cellMask
    }
    
    //Returns the color based on what kind of lesson it is
    func calculateLessonColor(classType: classType) -> UIColor {
        switch classType {
        case .lab:
            print("Color set to lab")
            return Constants.Colors.labColor
        case .lecture:
            print("Color set to lecture")
            return Constants.Colors.lectureColor
        case .tutorial:
            print("Color set to tutorial")
            return Constants.Colors.tutorialColor
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if let pass = findData(classID: (hourData[indexPath.row]?.lesson)!) {
            self.passDelegate?.performSegue(with: pass)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    
    
}
