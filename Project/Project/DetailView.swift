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
        
        self.navigationController?.navigationItem.title = lessonData.code
        
        //Place data into labels
        roomLabel.text = lessonData.roomFull
        nameLabel.text = lessonData.paperName
        typeLabel.text = String(describing: lessonData.type)
        timeLabel.text = "\(lessonData.startTime) - \(lessonData.startTime + lessonData.length)"
        
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
        pin.title = "COSC345"
        pin.coordinate = coordinates
        
        //Add pin to map
        mapView.addAnnotation(pin)
    }
    
    @IBAction func toogleNotifications(_ sender: Any) {
        
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        print("called")
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
}
