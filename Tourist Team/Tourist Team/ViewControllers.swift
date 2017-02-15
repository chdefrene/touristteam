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


let viewAppDelegate = UIApplication.shared.delegate as! AppDelegate

fileprivate var activities:[Activity] = viewAppDelegate.getActivity()
fileprivate var teams:[Team] = viewAppDelegate.getTeam()
fileprivate var persons:[Person] = viewAppDelegate.getPerson()


fileprivate var teamActivities:[TeamActivity] = viewAppDelegate.getTeamActivity()


struct LoginSession {
    static var loggedinUser:String = ""
}



// MARK: Login view


class LoginViewController: UIViewController {
    
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Loginbtn: UIButton!
    
    var foundUser:String = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func loginAction(_ sender: Any) {
        if ((Username.text == "") || (Password.text == "")) {
            //print("Username or password is empty")
            emptyCredentials()
        }
        if ((Username.text != nil) && (Password.text != nil)) {
            //print ("you can login !")
            let username = Username.text
            let password = Password.text
            
            
            var i=0
            for _ in persons{
                i += 1
            }
            
            var count = 0
            while count < i {
                if ((persons[count].username == username) && (persons[count].password == password)){
                    print("access granted!")
                    count += 1
                    foundUser = username!
                    LoginSession.loggedinUser = username!
                    break
                    
                    
                }else{
                    print ("not the right user")
                    count += 1
                }
            }
            if foundUser == ""{
                wrongCredentials()
            }
            
        }
    }
    
    func emptyCredentials() -> Void {
        let alertmessage = UIAlertController(title: "Login error", message: "Username or password field is empty, please try again.", preferredStyle: .alert)
        alertmessage.addAction(UIAlertAction(title: "Okay", style: .default))
        //present(alertmessage, animated: true, completion: nil)
        if self.presentedViewController == nil {
            self.present(alertmessage, animated: true, completion: nil)
        }
    }
    
    func wrongCredentials() -> Void {
        let alertmessage = UIAlertController(title: "Wrong credentials", message: "Your username and password do not match. Please try again.", preferredStyle: .alert)
        alertmessage.addAction(UIAlertAction(title: "Okay", style: .default))
        //present(alertmessage, animated: true, completion: nil)
        if self.presentedViewController == nil {
            self.present(alertmessage, animated: true, completion: nil)
        }
    }
    
    func wrongUsername() -> Void {
        let alertmessage = UIAlertController(title: "Wrong Username", message: "Your username is typed wrong.", preferredStyle: .alert)
        alertmessage.addAction(UIAlertAction(title: "Okay", style: .default))
        //present(alertmessage, animated: true, completion: nil)
        if self.presentedViewController == nil {
            self.present(alertmessage, animated: true, completion: nil)
        }
    }
    
    // Pass the loggedinUser variable to the team chooser view
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        let controller = segue.destination as! FirstViewController
    //        controller.loggedinUser = LoginSession.loggedinUser
    //    }
    
    //let personController = storyboard?.instantiateViewControllerWithIdentifier("PersonController") as! //ThirdViewController
    //personController.selectedPerson = foundUser
    
    
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //  let controller = segue.destination as! TableViewController
    //controller.selectedPerson = foundUser
    //}
    
    
    
}



// MARK: - Activities view

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


class ActivityTableViewCell: UITableViewCell {
    
    @IBOutlet var activityTitleOutlet: UILabel!
    @IBOutlet var activityInfoOutlet: UILabel!
    @IBOutlet var activityImageOutlet: UIImageView!
}


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
            controller.selectedActivitiesIndex = IndexPath.row
        }
    }
}


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
    
    var selectedActivitiesIndex = 0
    
    @IBOutlet weak var detailImageOutlet: UIImageView!
    @IBOutlet weak var detailNameOutlet: UILabel!
    @IBOutlet weak var detailInformationOutlet: UILabel!
    @IBOutlet weak var detailLinkOutlet: UIButton!
    @IBOutlet weak var detailLinklabelOutlet: UILabel!
    @IBOutlet weak var teamupButtonOutlet: UIButton!
    
    
    
    @IBAction func linkTapped(_ sender: Any) {
        let targetURL = NSURL(string: activities[selectedActivitiesIndex].link!)
        UIApplication.shared.open(targetURL as! URL)
        
    }
    
    @IBAction func teamUp(_ sender: Any) {
    }
    
    
    
    
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        // Get selected activity
        let object = activities[selectedActivitiesIndex]
        
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
        controller.selectedActivitiesIndex = selectedActivitiesIndex
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
    
    var selectedTeamsIndex = 0
    var selectedActivitiesIndex = 0
    
    
    /*let simpleLangaugeShortener = ["English": "EN",
                                   "French": "FR",
                                   "Norgwegian": "NO"]*/
    
    
    @IBOutlet weak var teamTableOutlet: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //activityAppDelegate.preloadDataFromServer()
        //tableView.reloadData()
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell",
                                                 for: indexPath) as! TeamTableViewCell
        
        // Configure the cell...
        
        // Hide cells that have no free spaces  -   ISSUE: tableView can't 'skip' listing cells that have no free spaces.
        let team = teams[indexPath.row]
        
        //if team.max_users - team.current_users > 1 {
    
            cell.teamTitleOutlet.text = team.name
            cell.teamAgeGroupOutlet.text = "Ages: " + team.age_group!
            
            if team.mixed_genders == true {
                cell.teamMixedGendersOutlet.text = "Mixed"
            } else {
                cell.teamMixedGendersOutlet.text = "Non-mixed"
            }
            
            cell.teamFreeSpacesOutlet.text = "Free: \(team.max_users - team.current_users)"
            
            cell.teamLanguagesOutlet.text = team.common_languages
        //}

        
        
        return cell
        
    }
    
    /*func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        let team = teams[indexPath.row]
        
        if team.max_users - team.current_users == 0 {
            return 0
        }
        return 44
    }*/
    
    // Pass the indexPath variable to the team chooser view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! JoinTeamController
        if let IndexPath = self.tableView.indexPathForSelectedRow {
            controller.selectedTeamsIndex = IndexPath.row
            controller.selectedActivitiesIndex = selectedActivitiesIndex
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
    
    
    @IBAction func JoinTeamButton(_ sender: Any) {
        
        // Need logic to avoid joining same team. Maybe hide from list instead?
        
        // Increment team counter
        viewAppDelegate.incrementTeamCounter(team: teams[selectedTeamsIndex])
        
        // Add relationships between user and team
        //viewAppDelegate.addPersonRelationships(fromIndex: selectedIndex, toIndex: selectedIndex)
                                                                            // WRONG INDEX: This must be 
                                                                            // fetched from model instead
        let loggedinUser = LoginSession.loggedinUser
        
        
        print("Logged in user: \(loggedinUser)")
        
        print("You have joined team \(teams[selectedTeamsIndex].name!) for activity \(activities[selectedActivitiesIndex].name!)")
        
        
        // Display alert to user
        joinedTeam(team: teams[selectedTeamsIndex])
    }
    
    
    
    var selectedTeamsIndex = 0
    var selectedActivitiesIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get selected activity
        let object = teams[selectedTeamsIndex]
        
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
            JoinTeamButtonOutlet.isEnabled = false
            JoinTeamButtonOutlet.backgroundColor = UIColor.gray
        } else {
            FreeSpacesOutlet.text = "\(freeSpaces) spaces left"
            JoinTeamButtonOutlet.isEnabled = true
        }
        
        CommonLanguagesOutlet.text = "Common languages: " + object.common_languages!
        
        // Modify the "team up" with rounded edges
        JoinTeamButtonOutlet.layer.cornerRadius = 10.0
        
    }
    
    func joinedTeam(team:Team) -> Void {
        let alertmessage = UIAlertController(title: "\(team.name!)", message: "Team joined successfully!", preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: "Home", style: .default) { (_) -> Void in
            let nv = self.storyboard!.instantiateViewController(withIdentifier: "tabBar")
            self.present(nv, animated:false, completion:nil)
        }
        
        present(alertmessage, animated: true, completion: nil)
        //alertmessage.addAction(UIAlertAction(title: "Home", style: .default))
        //present(alertmessage, animated: true, completion: nil)
        /*if self.presentedViewController == nil {
            self.present(alertmessage, animated: true, completion: nil)
        }*/
        alertmessage.addAction(acceptAction)
    }
    
}



// MARK: Teams view

class MyTeamsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var teamNameOutlet: UILabel!
    @IBOutlet weak var teamAgeGroupOutlet: UILabel!
    @IBOutlet weak var teamMixedGendersOutlet: UILabel!
    @IBOutlet weak var teamFreeSpacesOutlet: UILabel!
    @IBOutlet weak var teamCommonLanguagesOutlet: UILabel!
    
}


class MyTeamsController: UITableViewController{
    
    @IBOutlet weak var teamTableOutlet: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //activityAppDelegate.preloadDataFromServer()
        //tableView.reloadData()
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTeamsCell",
                                                 for: indexPath) as! MyTeamsTableViewCell
        
        // Get users teams
        let object = teams[indexPath.row]
            
            cell.teamNameOutlet.text = object.name
            cell.teamAgeGroupOutlet.text = "Ages " + object.age_group!
            
            if object.mixed_genders {
                cell.teamMixedGendersOutlet.text = "Mixed genders"
            } else {
                cell.teamMixedGendersOutlet.text = "Non-mixed genders"
            }
            
            let freeSpaces = object.max_users - object.current_users
            if freeSpaces == 0 {
                cell.teamFreeSpacesOutlet.text = "Team is full"
                //JoinTeamButtonOutlet.isEnabled = false
                //JoinTeamButtonOutlet.backgroundColor = UIColor.gray
            } else {
                cell.teamFreeSpacesOutlet.text = "\(freeSpaces) spaces left"
                //JoinTeamButtonOutlet.isEnabled = true
            }
            
            cell.teamCommonLanguagesOutlet.text = object.common_languages!
        
        
        
        return cell
        
    }
    
    
    // Pass the indexPath variable to the team chooser view
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     let controller = segue.destination as! JoinTeamController
     if let IndexPath = self.tableView.indexPathForSelectedRow {
     controller.selectedIndex = IndexPath.row
     }
     }*/
    
}



class SecondViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}




// MARK: Person view


class ThirdViewController: UIViewController {
    
    
    @IBOutlet weak var personTitleOutlet: UILabel!
    @IBOutlet weak var personAgeOutlet: UILabel!
    @IBOutlet weak var personGenderOutlet: UILabel!
    @IBOutlet weak var personLanguagesOutlet: UILabel!
    @IBOutlet weak var personImageOutlet: UIImageView!
    
    var selectedPerson = LoginSession.loggedinUser
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        var object = Person()
        
        //var object = persons[0]
        
        
        for person in persons {
            if person.username == selectedPerson{
                object = person
            }else{
                //print("Person not found")
            }
        }
        
        
        
        
        personTitleOutlet.text = object.name
        personAgeOutlet.text = String(describing: object.age)
        personGenderOutlet.text = object.gender
        personLanguagesOutlet.text = object.languages
        personImageOutlet.image = UIImage(named: object.image!)
        
        personImageOutlet.layer.cornerRadius = personImageOutlet.frame.size.width / 2;
        personImageOutlet.layer.borderWidth = 2.0;
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

