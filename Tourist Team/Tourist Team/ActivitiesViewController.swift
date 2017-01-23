//
//  FirstViewController.swift
//  Tourist Team
//
//  Created by Christian De Frène on 22.01.2017.
//  Copyright © 2017 eurecom. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    // Outlets and actions
    
    @IBOutlet weak var mapListControl: UISegmentedControl!
    
    @IBOutlet weak var label: UILabel!
    
    @IBAction func indexChanged(_ sender: AnyObject) {
        
        switch mapListControl.selectedSegmentIndex {
        case 0:
            label.text = "List selected"
        case 1:
            label.text = "Map selected"
        default:
            break
        }
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        label.text = "List selected"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

