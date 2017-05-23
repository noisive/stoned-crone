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
    
    enum classType {
        case lecture
        case lab
        case tutorial
    }
    
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
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let lessonObject = tableViewData[indexPath.row]
        
        if lessonObject.lessonClashes {
            let cell : ClashCell = tableView.dequeueReusableCell(withIdentifier:
                "ClashCell", for: indexPath) as! ClashCell
            
            
            
            return cell
        } else {
        
        let cell : TimetableCell = tableView.dequeueReusableCell(withIdentifier:
        "TimetableCell", for: indexPath) as! TimetableCell
        
        
        
        cell.timeLabel.text =  "\(lessonObject.startTime!)"
        cell.lessonCode.text = lessonObject.code
        cell.lessonRoom.text = lessonObject.roomShort
        
        
        if lessonObject.type == .lab {
            cell.colorView.backgroundColor = Constants.Colors.labColor
        } else if lessonObject.type == .lecture {
            cell.colorView.backgroundColor = Constants.Colors.lectureColor
        } else {
            cell.colorView.backgroundColor = Constants.Colors.tutorialColor
        }
        
        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Called")
        let cell = tableView.cellForRow(at: indexPath) as! TimetableCell
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pushView = storyboard.instantiateViewController(withIdentifier: "DetailView") as! DetailViewController
        
        let vc = storyboard.instantiateViewController(withIdentifier: "Home") as! UINavigationController
        vc.pushViewController(pushView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return CGFloat(tableViewData[indexPath.row].length * 100)
    }
    
}
