//
//  FirstViewController.swift
//  Tourist Team
//
//  Created by Christian De Frène on 22.01.2017.
//  Copyright © 2017 eurecom. All rights reserved.
//

import UIKit
import MapKit
//import CoreData

// MARK: - MapView

class MapViewController: UIViewController, MKMapViewDelegate {
    // Variables and constants
    
    // Set location and view angle to Antibes
    let initialLocation = CLLocation(latitude: 43.580022, longitude: 7.124758)
    let regionRadius: CLLocationDistance = 1500.0
    
    // Manages user GPS location
    var locationManager: CLLocationManager!
    
    // Outlets and actions
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up map and features
        centerMapOnLocation(location: initialLocation)
        mapView.userTrackingMode = .follow
    }
    
    // Centers map on given location
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}





class FirstViewController: UIViewController {//, UITableViewController, MKMapViewDelegate {
    
    //*******  TESTING START   ***********
    
    
    
    
    
    
    
    //*******   TESTING END    ***********
    
    
    
    
    // Outlets and actions
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var mapViewContainer: UIView!
    @IBOutlet weak var listAndMapSwitcher: UISegmentedControl!
    
    
    
    
    
    @IBAction func switchBetweenListAndMap(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            UIView.animate(withDuration: 0.3, animations: {
                self.tableViewContainer.alpha = 1
                self.mapViewContainer.alpha = 0
            })
        case 1:
            UIView.animate(withDuration: 0.3, animations: {
                self.mapViewContainer.alpha = 1
                self.tableViewContainer.alpha = 0
            })
        default:
            break
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
    }
    


}

