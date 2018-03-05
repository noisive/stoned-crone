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
    var hourData = [(lesson: CLong?, lesson2: CLong?)?](repeatElement(nil, count: 14))
    
    var tableViewData = [Lesson]()
    
    override func awakeFromNib() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 8, right: 0)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func scrollToCurrentTime(){
        
        let currentHour = Calendar.current.component(.hour, from: Date())
        
        var currentHourCell: IndexPath
        // Check if time to scroll to is out of bounds, scroll to min/max if so.
        if currentHour < 8 {
            currentHourCell = IndexPath(row: 0, section: 0)
        }else if currentHour > 21{
            currentHourCell = IndexPath(row: 21 - 8, section: 0)
        } else {
            currentHourCell = IndexPath(row: currentHour - 8, section: 0)
        }
        
        self.tableView.scrollToRow(at: currentHourCell, at: .top, animated: true)
        
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
            
            if let lessonData = findData(uid: (dataPath?.lesson)!) {
                singleCell.lessonCode.text = lessonData.code
                singleCell.lessonRoom.text = lessonData.roomShort
                
                //Setup time table, color and style.
                setupCell(Appearance: singleCell, indexPath: indexPath, type: lessonData.type, colour: lessonData.colour)
            }
            singleCell.timeLabel.text = indexPath.row + 8 >= 10 ? "\(8 + indexPath.row):00" : "0\(8 + indexPath.row):00"
            
            cell = singleCell
        } else if dataPath?.lesson != nil && dataPath?.lesson2 != nil {
            let clashCell : ClashCell = tableView.dequeueReusableCell(withIdentifier:
                "ClashCell", for: indexPath) as! ClashCell
           
            
            if let lessonData1 = findData(uid: (dataPath?.lesson)!), let lessonData2 = findData(uid: (dataPath?.lesson2)!) {
                clashCell.leftLessonLabel.text = lessonData1.code
                clashCell.rightLessonLabel.text = lessonData2.code
                clashCell.leftLesson.backgroundColor = UIColor(hexString: lessonData1.colour)
                clashCell.rightLesson.backgroundColor = UIColor(hexString: lessonData2.colour)
            }
            
            
            clashCell.timeLabel.text = indexPath.row + 8 >= 10 ? "\(8 + indexPath.row):00" : "0\(8 + indexPath.row):00"
            
            cell = clashCell
        }
        cell.selectionStyle = .none
        
        return cell
    }
    
    //Find the lesson object that matches event uid
    func findData(uid: CLong) -> Lesson? {
        if let data = tableViewData.filter({$0.uid == uid}).first {
            return data
        }
        return nil
    }
    
    func setupCell(Appearance cell: TimetableCell, indexPath: IndexPath, type: String, colour: String) {
        
        cell.colorView.backgroundColor = UIColor(hexString: colour)
        
        let lessonData = hourData[indexPath.row]
        
        if indexPath.row > 0 {
            switch true {
                
            // If the cell above is equal, connect the two and remove excess data
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
    
    @objc func roundEdges(view: UIView, corners: UIRectCorner) {
        let cellMask = CAShapeLayer()
        cellMask.path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: 2, height: 2)).cgPath
        view.layer.mask = cellMask
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if hourData[indexPath.row] != nil{
            if let pass = findData(uid: (hourData[indexPath.row]?.lesson)!) {
                self.passDelegate?.performSegue(with: pass)
            }else{
                print("cell without data tapped")
            }
        }
    }
    
    
    // Programatically set the height of all timetable cells
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 75
    }
    
}
