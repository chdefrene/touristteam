//
//  FirstViewController.swift
//  Tourist Team
//
//  Created by Christian De Frène on 22.01.2017.
//  Copyright © 2017 eurecom. All rights reserved.
//

import UIKit
import MapKit
import CoreData


// MARK: - Global variables and constants
let appDelegate = UIApplication.shared.delegate as! AppDelegate


fileprivate var activities:[Activity] = appDelegate.getActivity()


//var fetchResultController:NSFetchedResultsController<NSFetchRequestResult>!



// MARK: - MapView

class MapViewController: UIViewController, MKMapViewDelegate {
    
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


// MARK: - Tableview cell

class ActivityTableViewCell: UITableViewCell {
    
    @IBOutlet var activityTitleOutlet: UILabel!
    @IBOutlet var activityInfoOutlet: UILabel!
    @IBOutlet var activityImageOutlet: UIImageView!
}

// MARK: - Tableview

class TableViewController: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make the cell self size
        tableView.estimatedRowHeight = 66.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return activities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityTableViewCell
        
        
        // Configure the cell...
        //cell.nameLabel.text = menuItems[indexPath.row].name
        //cell.activityTitleOutlet.text = activities[indexPath.row].name
        cell.activityTitleOutlet.text = activities[indexPath.row].name

        
        
        
        //cell.detailLabel.text = menuItems[indexPath.row].detail
        //cell.activityInfoOutlet.text = activities[indexPath.row].information
        cell.activityInfoOutlet.text = activities[indexPath.row].information

        //cell.priceLabel.text = "$\(menuItems[indexPath.row].price as! Double)"
        //cell.activityImageOutlet.image = UIImage()
        cell.activityImageOutlet?.image = UIImage(named: activities[indexPath.row].image!)
        
        
        return cell
        
    }
    
    
    
    
}




// MARK: - General setup

class FirstViewController: UIViewController, UITableViewDelegate, MKMapViewDelegate {

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
        
    }

}

