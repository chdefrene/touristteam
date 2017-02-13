//
//  ThirdViewController.swift
//  Tourist Team
//
//  Created by Christian De Frène on 22.01.2017.
//  Copyright © 2017 eurecom. All rights reserved.
//

import UIKit
import CoreData

let personAppDelegate = UIApplication.shared.delegate as! AppDelegate
fileprivate var persons:[Person] = personAppDelegate.getPerson()

class ThirdViewController: UIViewController {
    

    @IBOutlet weak var personTitleOutlet: UILabel!
    @IBOutlet weak var personAgeOutlet: UILabel!
    @IBOutlet weak var personGenderOutlet: UILabel!
    @IBOutlet weak var personLanguagesOutlet: UILabel!
    @IBOutlet weak var personImageOutlet: UIImageView!
    
    var selectedPerson = "Emma"
    
    
    
    
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
