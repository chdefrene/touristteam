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
let activityAppDelegate = UIApplication.shared.delegate as! AppDelegate

fileprivate var activities:[Activity] = activityAppDelegate.getActivity()
fileprivate var teams:[Team] = activityAppDelegate.getTeam()



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
        cell.activityTitleOutlet.text = activities[indexPath.row].name
        cell.activityInfoOutlet.text = activities[indexPath.row].information
        cell.activityImageOutlet?.image = UIImage(named: activities[indexPath.row].image!)
        
        
        return cell
        
    }
    
    // Pass the indexPath variable to the detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let IndexPath = self.tableView.indexPathForSelectedRow {
            let controller = segue.destination as! DetailViewController
            controller.selectedIndex = IndexPath.row
        }
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



class DetailViewController: UIViewController {
    
    var selectedIndex = 0
    
    @IBOutlet weak var detailImageOutlet: UIImageView!
    @IBOutlet weak var detailNameOutlet: UILabel!
    @IBOutlet weak var detailInformationOutlet: UILabel!
    @IBOutlet weak var detailLinkOutlet: UIButton!
    @IBOutlet weak var detailLinklabelOutlet: UILabel!
    @IBOutlet weak var teamupButtonOutlet: UIButton!
    
    
    
    @IBAction func linkTapped(_ sender: Any) {
        let targetURL = NSURL(string: activities[selectedIndex].link!)
        UIApplication.shared.open(targetURL as! URL)
        
    }
    
    @IBAction func teamUp(_ sender: Any) {
    }
    
    
    
    
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        // Get selected activity
        let object = activities[selectedIndex]
        
        // Display activity image
        if object.image != nil {
            detailImageOutlet.image = UIImage(named: object.image!)
        }
        
        // Display activity name and info
        detailNameOutlet.text = object.name
        detailInformationOutlet.text = object.information
        
        // Display link if provided. If not, hide the fields
        if Int(object.link!) == 0 {
            detailLinkOutlet.setTitle("No webpage available", for: .normal)
            detailLinkOutlet.isEnabled = false
        } else {
            detailLinklabelOutlet.isHidden = false
            detailLinkOutlet.setTitle(object.link, for: .normal)
        }
        
        // Modify the "team up" with rounded edges
        teamupButtonOutlet.layer.cornerRadius = 10.0
        
    }
    
    
    // Pass the indexPath variable to the team chooser view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! TeamChooserController
        controller.selectedIndex = selectedIndex
    }
    
}


class TeamTableViewCell: UITableViewCell {
    
    @IBOutlet var teamTitleOutlet: UILabel!
    @IBOutlet var teamFreeSpacesOutlet: UILabel!
    @IBOutlet var teamAgeGroupOutlet: UILabel!
    @IBOutlet var teamLanguagesOutlet: UILabel!
    @IBOutlet var teamMixedGendersOutlet: UILabel!
}


class TeamChooserController: UITableViewController{
    
    var selectedIndex = 0
    
    /*let simpleLangaugeShortener = ["English": "EN",
                                   "French": "FR",
                                   "Norgwegian": "NO"]*/
    
    
    @IBOutlet weak var teamTableOutlet: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return teams.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath) as! TeamTableViewCell
        
        
        // Configure the cell...
        cell.teamTitleOutlet.text = teams[indexPath.row].name
        cell.teamAgeGroupOutlet.text = "Ages: " + teams[indexPath.row].age_group!
        
        if teams[indexPath.row].mixed_genders == true {
            cell.teamMixedGendersOutlet.text = "Mixed"
        } else {
            cell.teamMixedGendersOutlet.text = "Non-mixed"
        }
        
        cell.teamFreeSpacesOutlet.text = "Free: \(teams[indexPath.row].max_users - teams[indexPath.row].current_users)"
        
        
        cell.teamLanguagesOutlet.text = teams[indexPath.row].common_languages

        
        
        return cell
        
    }
    
    // Pass the indexPath variable to the team chooser view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! JoinTeamController
        if let IndexPath = self.tableView.indexPathForSelectedRow {
            controller.selectedIndex = IndexPath.row
        }
    }
    
}


class JoinTeamController: UIViewController {
    
    @IBOutlet weak var TeamNameOutlet: UILabel!
    @IBOutlet weak var AgeGroupOutlet: UILabel!
    @IBOutlet weak var MixedGendersOutlet: UILabel!
    @IBOutlet weak var FreeSpacesOutlet: UILabel!
    @IBOutlet weak var CommonLanguagesOutlet: UILabel!
    
    @IBOutlet weak var JoinTeamButtonOutlet: UIButton!
    
    
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get selected activity
        let object = teams[selectedIndex]
        
        TeamNameOutlet.text = object.name
        AgeGroupOutlet.text = "Ages " + object.age_group!
        
        if object.mixed_genders {
            MixedGendersOutlet.text = "Mixed genders"
        } else {
            MixedGendersOutlet.text = "Non-mixed genders"
        }
        
        let freeSpaces = object.max_users - object.current_users
        if freeSpaces == 0 {
            FreeSpacesOutlet.text = "Team is full"
        } else {
            FreeSpacesOutlet.text = "\(freeSpaces) spaces left"
        }
        
        CommonLanguagesOutlet.text = "Common languages: " + object.common_languages!
        
        // Modify the "team up" with rounded edges
        JoinTeamButtonOutlet.layer.cornerRadius = 10.0
    }
    
    
    
    
    
}



