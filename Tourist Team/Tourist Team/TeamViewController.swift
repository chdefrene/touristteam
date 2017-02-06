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



class TeamViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

