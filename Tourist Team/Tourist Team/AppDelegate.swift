//
//  AppDelegate.swift
//  Tourist Team
//
//  Created by Christian De Frène on 22.01.2017.
//  Copyright © 2017 eurecom. All rights reserved.
//

import UIKit
import CoreData
import Foundation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        preloadDataFromFile()
        preloadDataFromServer()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "TouristTeam")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
    // MARK: - Core Data custom methods
    // As described here: https://learnappdevelopment.com/uncategorized/how-to-use-core-data-in-ios-10-swift-3/
    
    
    
    
    // ============================================================
    // =====================  ACTIVITY  ===========================
    // ============================================================
    
    
    func getActivity() -> [Activity] {
        
        // Create a fetch request
        let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
        
        do {
            // Get the results
            let activity = try getContext().fetch(fetchRequest)
            
            return activity
            
        } catch {
            fatalError("Error with request: \(error)")
        }
    }
    
    
    func storeActivity ( name: String,
                         latitude: Double,
                         longitude: Double,
                         information: String,
                         link: String,
                         image: String ) {
        
        let context = getContext()
        
        let activity = NSEntityDescription.insertNewObject(forEntityName: "Activity", into: context) as! Activity
        
        // Set the values
        activity.setValue(name, forKey: "name")
        activity.setValue(latitude, forKey: "latitude")
        activity.setValue(longitude, forKey: "longitude")
        activity.setValue(information, forKey: "information")
        activity.setValue(link, forKey: "link")
        activity.setValue(image, forKey: "image")
        
        // Save object
        do {
            try context.save()
            //print(activity.name!)
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func removeActivitiesData() {
        // Remove the existing items
        let context = self.getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Activity")
        
        do {
            let activities = try context.fetch(fetchRequest) as! [Activity]
            
            for activity in activities {
                context.delete(activity)
            }
        } catch let e as NSError? {
            print("Failed to retrieve record: \(e!.localizedDescription)")
        }
    }
    
    

    
    
    // ============================================================
    // =======================  TEAM  =============================
    // ============================================================
    
    
    func getTeam() -> [Team] {
        
        // Create a fetch request
        let fetchRequest: NSFetchRequest<Team> = Team.fetchRequest()
        
        do {
            // Get the results
            let team = try getContext().fetch(fetchRequest)
            
            return team
            
        } catch {
            fatalError("Error with request: \(error)")
        }
        
    }
    
    func storeTeam ( name: String,
                     currentUsers: Int16,
                     maxUsers: Int16,
                     ageGroup: String,
                     mixedGenders: Bool,
                     commonLanguages: String ) {
        
        let context = getContext()
        
        let team = NSEntityDescription.insertNewObject(forEntityName: "Team", into: context) as! Team
        
        // Set the values
        team.setValue(name, forKey: "name")
        team.setValue(currentUsers, forKey: "current_users")
        team.setValue(maxUsers, forKey: "max_users")
        team.setValue(ageGroup, forKey: "age_group")
        team.setValue(mixedGenders, forKey: "mixed_genders")
        team.setValue(commonLanguages, forKey: "common_languages")
        
        // Save object
        do {
            try context.save()
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    
    
    func removeTeamData() {
        let context = self.getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Team")
        
        do {
            let teams = try context.fetch(fetchRequest) as! [Team]
            
            for team in teams {
                context.delete(team)
            }
        } catch let e as NSError? {
            print("Failed to retrieve record: \(e!.localizedDescription)")
        }
    }
    
    
    
    
    
    // MARK: - Auxiliary functions
    
    
    // Preload activities and users from local data files
    // These are static, so they are not on the server
    func preloadDataFromFile() {
        
        // Clear data already in listview
        removeActivitiesData()
        //removeTeamData()
        
        // Set filepath for data file
        let activityCsvPath = Bundle.main.path(forResource: "activityData", ofType: "csv")
        //let teamCsvPath = Bundle.main.path(forResource: "teamData", ofType: "csv")
        
        // No data file was found; exit method
        if activityCsvPath == nil {
            fatalError("No activity data file found!")
        }
        /*if teamCsvPath == nil {
            fatalError("No team data file found!")
        }*/
        
        // Instantiate data varaible to hold row data
        var activityCsvData:String? = nil
        //var teamCsvData:String? = nil
       
        
        // Scan through data file, storing each row in the Core Data model
        do {
            activityCsvData = try String(contentsOfFile: activityCsvPath!,
                                 encoding: String.Encoding.utf8)
            //teamCsvData = try String(contentsOfFile: teamCsvPath!, encoding: String.Encoding.utf8)
            
            // Call the csvRows method from the csvparser.swift helper file
            let activityCsvRows = activityCsvData?.csvRows()
            //let teamCsvRows = teamCsvData?.csvRows()
            
            for row in activityCsvRows! {
                
                // Store scanned data in data model
                self.storeActivity( name: row[0], latitude: Double(row[1])!, longitude: Double(row[2])!,information: row[3], link: row[4], image: row[5] )
            }
            
        } catch {
            print(error)
        }
    }
    
    // Preload team data from server
    // When you join a team or create a new one, this function 
    // enables other users to receive the updated information
    func preloadDataFromServer() {
        
        //print("Preload from server called")
        
        // Clear previously fetched data
        removeTeamData()
        
        // Set up URL request
        let teamDataServerString = "http://tourist-team.appspot.com/teamlist?respType=json"
        
        guard let teamUrl = URL(string: teamDataServerString) else {
            print("Error: cannot create URL")
            return
        }
        let teamUrlRequest = URLRequest(url: teamUrl)
        
        // Set up session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // Make request to server
        let task = session.dataTask(with: teamUrlRequest) {
            (data, response, error) in
            
            // Check for errors
            guard error == nil else {
                print(error!)
                return
            }
            
            // Parse result as JSON
            do {
                guard let parsedData = try? JSONSerialization.jsonObject(with: data!, options: []) as? [NSObject] else {
                    print("error trying to convert data to JSON")
                    return
                }
                
                for team in parsedData! {
                    self.storeTeam(name: team.value(forKey: "name")! as! String,
                                   currentUsers: Int16((team.value(forKey: "current_users")! as! NSString).doubleValue),
                                   maxUsers: Int16((team.value(forKey: "max_users")! as! NSString).doubleValue),
                                   ageGroup: team.value(forKey: "age_group")! as! String,
                                   mixedGenders: Bool((team.value(forKey: "mixed_genders")! as! NSString) as String)!,
                                   commonLanguages: team.value(forKey: "common_languages")! as! String)
                }
            }
        }
        
        task.resume()
        
    }
    
    
    // Called when a new member joins an existing team
    func incrementTeamCounter( team: Team ) {
        
        // Make dictionary with ID and the increased counter
        var dataDict = [:] as [String: Any]
        
        dataDict.updateValue(team.name!.replacingOccurrences(of: " ", with: "+"), forKey: "name")
        dataDict.updateValue(String(team.current_users+1), forKey: "current_users")
        dataDict.updateValue(String(team.max_users), forKey: "max_users")
        dataDict.updateValue(team.age_group!, forKey: "age_group")
        dataDict.updateValue(String(team.mixed_genders), forKey: "mixed_genders")
        
        // Replace commas and spaces to sanitize the post request
        var langs = team.common_languages!
        langs = langs.replacingOccurrences(of: " ", with: "+")
        langs = langs.replacingOccurrences(of: ",", with: "%2C")
        
        dataDict.updateValue(langs, forKey: "common_languages")
        
        
        // Create URL to post to
        guard let teamUrl = URL(string: "http://tourist-team.appspot.com/saveteam") else {
            print("Error: cannot create URL")
            return
        }
        
        // Request which is sent
        // Specify POST and that it should fill out a form
        let teamUrlRequest = NSMutableURLRequest(url: teamUrl as URL)
        teamUrlRequest.httpMethod = "POST"
        teamUrlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // Put the data from the dictionary into a nice data string
        // Place this string as the body of the request
        let bodydata = "name=\(dataDict["name"]!)&current_users=\(dataDict["current_users"]!)&max_users=\(dataDict["max_users"]!)&age_group=\(dataDict["age_group"]!)&mixed_genders=\(dataDict["mixed_genders"]!)&common_languages=\(dataDict["common_languages"]!)"
        teamUrlRequest.httpBody = bodydata.data(using: String.Encoding.utf8)
        
        
        // Set up session
        let task = URLSession.shared.dataTask(with: teamUrlRequest as URLRequest) {
            (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
        }
        task.resume()
    }
    
    
    
    func addLanguageToTeam(teamName: String) {}
    
    
    // NOTE: Don't use this one
    //       Better to use the GAE server
    // Add a new line to one of the data files
    /*func writeDataToEndOfTeamdataFile(fileName: String, data: Data) {
        
        // Get the data file path
        let csvFilePath = Bundle.main.path(forResource: fileName, ofType: "csv")

        if csvFilePath != nil {
            
            do {
                // Enable file editing
                let fileHandle: FileHandle? = FileHandle(forUpdatingAtPath: csvFilePath!)
                
                if fileHandle == nil {
                    fatalError("File open failed")
                
                } else {
                    // Go to the end of the file, 
                    // write the data and save it
                    fileHandle?.seekToEndOfFile()
                    fileHandle?.write(data)
                    fileHandle?.closeFile()
                }
            }
        
        } else {
            fatalError("No data file found!")
        }
    }*/
    
    
    // Update one of the attributes in a data file
    /*func increaseNumberOfUsersInTeam(fileName: String,
                                     selectedTeam: String) {
        
        
        // Translate attribute name into position in data file
        let numOfCommas = 1
        
        /*switch attribute {
//        case "name":
//            numOfCommas = 0
        case "current_users":
            numOfCommas = 1
//        case "max_users":
//            numOfCommas = 2
//        case "age-group":
//            numOfCommas = 3
//        case "mixed_genders":
//            numOfCommas = 4
        case "common_languages":
            numOfCommas = 5
        default:
            numOfCommas = -1
        
        }*/
        
        
        // Get the data file path
        let csvFilePath = Bundle.main.path(forResource: fileName, ofType: "csv")
        
        if csvFilePath != nil {
            
            /*var selectedRow:Array<String>? = nil // Our row of data
            var index = 0                        // Index used when looping over row
            var firstPos = 0                     // The first position of our region-of-interest
            var lastPos = 0                      // The last position of our region-of-interest
            var currentCommas = 0                // Current commas found when looping*/
            
            
            /**
             //   Access data file, increase current users and save the new data file
             **/
            
            do {
                let csvData = try String(contentsOfFile: csvFilePath!, encoding: String.Encoding.utf8)
                let csvRows = csvData.csvRows()
                
                // Get desired team entity
                for row in csvRows {
                    if row[0] == selectedTeam {
                        
                        var editableRow = row
                        
                        var currentUsers = Int(editableRow[numOfCommas])!
                        var maxUsers = Int(editableRow[numOfCommas+1])!
                        
                        // Increase current users in team if team is not full
                        //currentUsers < Int(editableRow[2])! ? currentUsers += 1 : fatalError("Team is already full")
                        
                        print(row)
                        
                        print("Current users in \(selectedTeam) is \(currentUsers) out of a maximum of \(maxUsers)")
                        
                        
                        
                        
                    }
                }
                /*
                // Determine region-of-interest
                // with first and last positions
                for char in (selectedRow?[numOfCommas].characters)! {
                    
                    // If character in row is a comma
                    if char == "," {
                        
                        // Check if we are in specified attribute location
                        if currentCommas == numOfCommas {
                            firstPos = index
                            
                            // If past the location, end loop
                        } else if currentCommas > numOfCommas {
                            lastPos = index
                            break
                            
                            // Not reached location yet
                        } else {
                            currentCommas += 1
                        }
                        
                        // Character is not a comma
                    } else {
                        index += 1
                    }
                }*/
            } catch {
                    print(error)
            }
            
            /*print("First position: \(firstPos)")
            print("Last position: \(lastPos)")
            
            print(selectedRow?[numOfCommas])
            selectedRow?[numOfCommas] = "9"
            print(selectedRow?[numOfCommas])
            
            
            /**
             //   STEP 2 - Seek to correct position in
             //            filehandler and write the new data
             **/
            
            do {
                // Enable file editing
                let fileHandle: FileHandle? = FileHandle(forUpdatingAtPath: csvFilePath!)
                
                // Check for errors
                if fileHandle == nil {
                    fatalError("File open failed")
                    
                } else {
                        // Seek to specified entity
                        fileHandle?.seek(toFileOffset: UInt64(20))
                        fileHandle?.write(data)
                        fileHandle?.closeFile()
                
                        
                        // Seek to specified attribute
                        
                        
                        
                        // Update the attribute with the given data
                        
                        
                        
                        
                    
                }
            }*/
        }
    }*/



}

