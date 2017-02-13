//
//  SecondViewController.swift
//  Tourist Team
//
//  Created by Christian De Frène on 22.01.2017.
//  Copyright © 2017 eurecom. All rights reserved.
//

import UIKit
import CoreData


// MARK: - Global variables and constants

let teamAppDelegate = UIApplication.shared.delegate as! AppDelegate

fileprivate var teams:[Team] = teamAppDelegate.getTeam()



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

