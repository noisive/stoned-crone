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
    public var currentXOffset: Int = 0
    
    //Create an array of arrays that have nothing in them
    var dataByHour = [(lesson: CLong?, lesson2: CLong?)?](repeatElement(nil, count: 14))
    
    var tableViewData = [Lesson]()
    
    override func awakeFromNib() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK: Functions
    //===================================================================================
    
    private func isFirstOccurance(of currentLesson: CLong, indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return true
        }
        guard let previousLesson: (lesson: CLong?, lesson2: CLong?) = self.dataByHour[indexPath.row - 1] else {
            return true
        }
        if (currentLesson != previousLesson.lesson && currentLesson != previousLesson.lesson2) {
            return true
        }
        return false
    }
    
    //Find the lesson object that matches event uid
    func findLessonData(uid: CLong) -> Lesson? {
        if let data = tableViewData.filter({$0.uid == uid}).first {
            return data
        }
        return nil
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
    
    @objc private func handleTap(sender: UIGestureRecognizer) {
        guard let view: UIView = sender.view else { return }
        if let lesson: Lesson = self.findLessonData(uid: view.tag) {
            self.passDelegate?.performSegue(with: lesson)
        } else {
            print("View with tag \(view.tag) does not exist.")
        }
        
    }
    
    //MARK: Delegate functions
    //===================================================================================
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataByHour.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: LessonCell = self.tableView.dequeueReusableCell(withIdentifier: AppCells.LESSON_CELL, for: indexPath) as! LessonCell
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        
        cell.timeLabel.text = TimeUtil.get24HourTimeFromIndexPath(row: indexPath.row)
        cell.resetCell()
        
        //Empty cell
        guard let lessonData: (lesson: CLong?, lesson2: CLong?) = self.dataByHour[indexPath.row] else {
            cell.hideLessons()
            return cell
        }
        
        //Clash cell
        if (lessonData.lesson != nil && lessonData.lesson2 != nil) {
            if let lessonOneUID = lessonData.lesson, let lessonTwoUID = lessonData.lesson2 {
                cell.leftLesson.tag = lessonOneUID
                cell.rightLesson.tag = lessonTwoUID
                cell.leftLesson.addGestureRecognizer(tapGesture)
                cell.rightLesson.addGestureRecognizer(tapGesture)
                if let lessonOneData = self.findLessonData(uid: lessonOneUID), let lessonTwoData = self.findLessonData(uid: lessonTwoUID) {
                    if (self.isFirstOccurance(of: lessonOneUID, indexPath: indexPath)) {
                        cell.leftLessonCode.text = lessonOneData.code
                        cell.leftLessonRoom.text = lessonOneData.roomShort
                        cell.leftLessonRoom.textColor = getBarBackgroundColorFromLesson(type: lessonOneData.type)
                        cell.leftLessonCode.textColor = getBarBackgroundColorFromLesson(type: lessonOneData.type)
                        cell.leftLesson.backgroundColor = getBackgroundColorFromLesson(type: lessonOneData.type)
                        cell.leftLessonBar.backgroundColor = getBarBackgroundColorFromLesson(type: lessonOneData.type)
                        
                    } else {
                        cell.leftLesson.backgroundColor = getBackgroundColorFromLesson(type: lessonOneData.type)
                        cell.leftLessonBar.backgroundColor = getBarBackgroundColorFromLesson(type: lessonOneData.type)
                        cell.hideLeftLessonLabels()
                    }
                    if (self.isFirstOccurance(of: lessonTwoUID, indexPath: indexPath)) {
                        cell.rightLessonCode.text = lessonTwoData.code
                        cell.rightLessonRoom.text = lessonTwoData.roomShort
                        cell.rightLessonRoom.textColor = getBarBackgroundColorFromLesson(type: lessonTwoData.type)
                        cell.rightLessonCode.textColor = getBarBackgroundColorFromLesson(type: lessonTwoData.type)
                        cell.rightLesson.backgroundColor = getBackgroundColorFromLesson(type: lessonTwoData.type)
                        cell.rightLessonBar.backgroundColor = getBarBackgroundColorFromLesson(type: lessonTwoData.type)
                        
                    } else {
                        cell.rightLesson.backgroundColor = getBackgroundColorFromLesson(type: lessonTwoData.type)
                        cell.rightLessonBar.backgroundColor = getBarBackgroundColorFromLesson(type: lessonTwoData.type)
                        cell.hideRightLessonLabels()
                    }
                } else {
                    print("Could not find lesson for UID")
                }
            } else {
                print("UIDs are missing for one of the lessons")
            }
            
        }
            
        //Normal cell
        else {
            if let lessonOneUID = lessonData.lesson {
                cell.hideRightLesson()
                cell.leftLesson.tag = lessonOneUID
                cell.leftLesson.addGestureRecognizer(tapGesture)
                if let lessonOneData = self.findLessonData(uid: lessonOneUID) {
                    if (self.isFirstOccurance(of: lessonOneUID, indexPath: indexPath)) {
                        cell.leftLessonCode.text = lessonOneData.code
                        cell.leftLessonRoom.text = lessonOneData.roomShort
                        cell.leftLessonRoom.textColor = getBarBackgroundColorFromLesson(type: lessonOneData.type)
                        cell.leftLessonCode.textColor = getBarBackgroundColorFromLesson(type: lessonOneData.type)
                        cell.leftLesson.backgroundColor = getBackgroundColorFromLesson(type: lessonOneData.type)
                        cell.leftLessonBar.backgroundColor = getBarBackgroundColorFromLesson(type: lessonOneData.type)
                        
                    } else {
                        cell.leftLesson.backgroundColor = getBackgroundColorFromLesson(type: lessonOneData.type)
                        cell.leftLessonBar.backgroundColor = getBarBackgroundColorFromLesson(type: lessonOneData.type)
                        cell.hideLeftLessonLabels()
                    }
                } else {
                    print("Could not find lesson for UID")
                }
            } else {
                print("No data in lesson one")
            }
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataByHour[indexPath.row] != nil{
            if let pass = findLessonData(uid: (dataByHour[indexPath.row]?.lesson)!) {
                self.passDelegate?.performSegue(with: pass)
            } else{
                print("cell without data tapped")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.calculateDayLabel()
    }
    
    func calculateDayLabel() -> String {
        
        // Gives date of most recent Monday
        let mondaysDate: Date = Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        
        
        let format = DateFormatter()
        format.timeZone = TimeZone.autoupdatingCurrent
        format.timeZone = TimeZone(identifier: "NZST")
        format.dateFormat = "d MMMM"
        let offset = self.currentXOffset
        
        
        // We are basically just adding 13 to UMT... DK how robust it is, but only thing that seems to work.
        // Test early and late in day.
        let offsetDate = convertUMTtoNZT(current: Calendar.current.date(byAdding: .day, value: offset, to: mondaysDate)!)
        
        return format.string(from: offsetDate)
    }
    
    
    // Programatically set the height of all timetable cells
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
}
