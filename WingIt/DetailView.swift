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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var roomLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet var buttonEffectViews: [UIVisualEffectView]!
    @IBOutlet weak var changeMapType: UIButton!

    //Variables
    public var lessonData : Lesson!

    //Constants
    private let MAP_CORNER_RADIUS: CGFloat = 13
    private let BUTTONS_CORNER_RADIUS: CGFloat = 5
    private let ZOOM_LEVEL: CLLocationDegrees = 0.005

    //MARK: View loading
    //=============================================================================
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mapView.layer.masksToBounds = true
        self.mapView.layer.cornerRadius = self.MAP_CORNER_RADIUS
        self.mapView.clipsToBounds = true
        self.buttonEffectViews.forEach { (view) in
            view.layer.cornerRadius = self.BUTTONS_CORNER_RADIUS
            view.layer.masksToBounds = true
        }
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
    
    @IBAction func getDirections(_ sender: Any) {
        let coordinate = CLLocationCoordinate2DMake(self.lessonData.latitude, self.lessonData.longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = "\(self.lessonData.code ?? "class")."
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking])
    }
    
    @IBAction func changeMapType(_ sender: Any) {
        //self.mapView.mapType =
        if self.mapView.mapType == .standard {
            self.mapView.mapType = .hybrid
            self.changeMapType.setTitle("Standard", for: .normal)
        } else {
            self.mapView.mapType = .standard
            self.changeMapType.setTitle("Hybrid", for: .normal)
        }
    
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
        self.mapView.mapType = .standard
        
        self.centerMap()
        
        let pin = MKPointAnnotation()
        pin.title = lessonData.code
        pin.coordinate = self.mapView.centerCoordinate
        self.mapView.addAnnotation(pin)
    }
    
    private func setupData() {
        self.tableView.separatorColor = AppColors.CELL_SEPERATOR_COLOR
        
        self.navigationItem.title = lessonData.code
        
        self.nameLabel.text = lessonData.paperName
        self.codeLabel.text = lessonData.code
        self.roomLabel.text = lessonData.roomFull
        self.typeLabel.text = lessonData.type
        
        let startTime = lessonData.startTime!
        let endTime = startTime + lessonData.duration
        timeLabel.text = "\(startTime):00 - \(endTime - 1):50"
        
        self.setupMap()
    }
    
    //MARK: Delegates
    //=============================================================================
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
}
