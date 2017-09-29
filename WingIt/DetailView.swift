//
//  DetailViewController.swift
//  Project
//
//  Created by Eli Labes on 21/05/17.
//  Copyright © 2017 Eli Labes. All rights reserved.
//

import UIKit
import MapKit

class DetailView: UITableViewController, MKMapViewDelegate {

    
    //Create outlets
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var roomLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
        
    //Create lesson object, data will be placed into this object based on what cell they click.
    var lessonData : Lesson!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = lessonData.code
        
        //Place data into labels
        roomLabel.text = lessonData.roomFull
        nameLabel.text = lessonData.paperName
        typeLabel.text = getLocalisedType(type: lessonData.type)
        
        let startTime = lessonData.startTime + 8 >= 10 ? "\(lessonData.startTime + 8):00" : "0\(lessonData.startTime + 8):00"
        let endTime = lessonData.startTime + lessonData.length + 8 >= 10 ? "\(lessonData.startTime + lessonData.length + 8):00" : "0\(lessonData.startTime + lessonData.length + 8):00"
        
        timeLabel.text = "\(startTime) - \(endTime)"
        
        //Setup map
        mapView.delegate = self
        mapView.mapType = .satellite
        
        //Create region for map to show
        let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        let coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(lessonData.latitude), longitude: CLLocationDegrees(lessonData.longitude))
        let region = MKCoordinateRegion(center: coordinates, span: span)
    
        //Show region
        mapView.setRegion(region, animated: true)
        
        //Create pin with information about class
        let pin = MKPointAnnotation()
        pin.title = lessonData.code
        pin.coordinate = coordinates
        
        //Add pin to map
        mapView.addAnnotation(pin)
    }
    func getLocalisedType(type: classType) -> String {
        switch type {
        case .lab:
            return "Lab"
        case .tutorial:
            return "Tutorial"
        case .lecture:
            return "Lecture"
        }
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        print("called")
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
}
