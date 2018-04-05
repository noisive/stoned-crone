//
//  DetailViewController.swift
//  Project
//
//  Created by Eli Labes on 21/05/17.
//  Copyright © 2017 Eli Labes. All rights reserved.
//

import UIKit
import MapKit

class DetailView: UITableViewController, MKMapViewDelegate, PDetailedClassView {
    
    //MARK: Variables and outlets
    //=============================================================================
    
    //Outlets
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var roomLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
        
    //Variables
    public var lessonData : Lesson!
    
    //Constants
    private let CORNER_RADIUS: CGFloat = 13
    private let ZOOM_LEVEL: CLLocationDegrees = 0.002

    //MARK: View loading
    //=============================================================================
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mapView.layer.masksToBounds = true
        self.mapView.layer.cornerRadius = self.CORNER_RADIUS
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupData()
    }

    //MARK: Actions
    //=============================================================================
    
    @IBAction func recenterMap(_ sender: Any) {
        self.centerMap()
    }
    
    //MARK: Functions
    //=============================================================================
    
    private func centerMap() {
        //Create region for map to show
        let span = MKCoordinateSpan(latitudeDelta: self.ZOOM_LEVEL, longitudeDelta: self.ZOOM_LEVEL)
        let coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(lessonData.latitude),
                                                 longitude: CLLocationDegrees(lessonData.longitude))
        let region = MKCoordinateRegion(center: coordinates, span: span)
        
        //Show region
        mapView.setRegion(region, animated: true)
    }
    
    private func setupMap() {
        self.mapView.delegate = self
        self.mapView.mapType = .hybrid
        
        self.centerMap()
        
        let pin = MKPointAnnotation()
        pin.title = lessonData.code
        pin.coordinate = self.mapView.centerCoordinate
        self.mapView.addAnnotation(pin)
    }
    
    private func setupData() {
        self.navigationItem.title = lessonData.paperName
        
        self.roomLabel.text = lessonData.roomFull
        self.typeLabel.text = lessonData.type
        
        let startTime = TimeUtil.get24HourTimeFromIndexPath(row: lessonData.startTime)
        let endTime = TimeUtil.get24HourTimeFromIndexPath(row: lessonData.startTime + lessonData.duration)
        timeLabel.text = "\(startTime) - \(endTime)"
        
        self.setupMap()
    }
    
    //MARK: Delegates
    //=============================================================================
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
}
