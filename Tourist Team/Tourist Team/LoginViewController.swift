//
//  LoginViewController.swift
//  Tourist Team
//
//  Created by mbkatja on 2/2/17.
//  Copyright © 2017 eurecom. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Loginbtn: UIButton!
    
    var useraccounts = ["Username": "Password", "User": "pass", "Test": "test"]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    @IBAction func loginAction(_ sender: Any) {
        if ((Username.text == "") || (Password.text == "")) {
            print("Username or password is empty")
            emptyCredentials()
        }
        if ((Username.text != nil) && (Password.text != nil)) {
            print ("you can login !")
            let username = Username.text
            let password = Password.text
            
            if (useraccounts[username!] != nil) {
                print("Username was found in useraccounts")
                if (useraccounts[username!] == password ){
                    print ("access granted !")
                }else{
                    print("something wrong with password")
                    wrongCredentials()
                }
            }else{
                print("username wasn't found")
                wrongUsername()
            }
        }
    }
    
    func emptyCredentials() -> Void {
        let alertmessage = UIAlertController(title: "Login error", message: "Username or password field is empty, please try again.", preferredStyle: .alert)
        alertmessage.addAction(UIAlertAction(title: "Okay", style: .default))
        present(alertmessage, animated: true, completion: nil)
    }
    
    func wrongCredentials() -> Void {
        let alertmessage = UIAlertController(title: "Wrong credentials", message: "Your username and password do not match. Please try again.", preferredStyle: .alert)
        alertmessage.addAction(UIAlertAction(title: "Okay", style: .default))
        present(alertmessage, animated: true, completion: nil)
    }
    func wrongUsername() -> Void {
        let alertmessage = UIAlertController(title: "Wrong Username", message: "Your username is typed wrong.", preferredStyle: .alert)
        alertmessage.addAction(UIAlertAction(title: "Okay", style: .default))
        present(alertmessage, animated: true, completion: nil)
    }
    

}
