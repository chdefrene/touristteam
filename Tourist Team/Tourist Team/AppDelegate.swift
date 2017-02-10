//
//  AppDelegate.swift
//  Tourist Team
//
//  Created by Christian De Frène on 22.01.2017.
//  Copyright © 2017 eurecom. All rights reserved.
//

import UIKit
import CoreData


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        preloadDataFromFile()
        
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
    
    
    // ============================================================
    // =======================  PERSON  ===========================
    // ============================================================
    
    func getPerson() -> [Person] {
        
        // Create a fetch request
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        
        do {
            // Get the results
            let person = try getContext().fetch(fetchRequest)
            
            return person
            
        } catch {
            fatalError("Error with request: \(error)")
        }
        
    }
    
    func storePerson ( age: Int16,
                     gender: String,
                     image: String,
                     languages: String,
                     name: String,
                     password: String,
                     username: String) {
        
        let context = getContext()
        
        let person = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context) as! Person
        
        // Set the values
        person.setValue(age, forKey: "age")
        person.setValue(gender, forKey: "gender")
        person.setValue(image, forKey: "image")
        person.setValue(languages, forKey: "languages")
        person.setValue(name, forKey: "name")
        person.setValue(password, forKey: "password")
        person.setValue(username, forKey: "username")
        
        // Save object
        do {
            try context.save()
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    
    
    func removePersonData() {
        let context = self.getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        
        do {
            let persons = try context.fetch(fetchRequest) as! [Person]
            
            for person in persons {
                context.delete(person)
            }
        } catch let e as NSError? {
            print("Failed to retrieve record: \(e!.localizedDescription)")
        }
    }
    
    
    
    
    
    
    
    // MARK: - Auxiliary functions
    
    func preloadDataFromFile() {
        
        // Clear data already in listview
        removeActivitiesData()
        removeTeamData()
        
        // Set filepath for data file
        let activityCsvPath = Bundle.main.path(forResource: "activityData", ofType: "csv")
        let teamCsvPath = Bundle.main.path(forResource: "teamData", ofType: "csv")
        
        // No data file was found; exit method
        if activityCsvPath == nil {
            fatalError("No activity data file found!")
        }
        if teamCsvPath == nil {
            fatalError("No team data file found!")
        }
        
        // Instantiate data varaible to hold row data
        var activityCsvData:String? = nil
        var teamCsvData:String? = nil
       
        
        // Scan through data file, storing each row in the Core Data model
        do {
            activityCsvData = try String(contentsOfFile: activityCsvPath!,
                                 encoding: String.Encoding.utf8)
            teamCsvData = try String(contentsOfFile: teamCsvPath!, encoding: String.Encoding.utf8)
            
            // Call the csvRows method from the csvparser.swift helper file
            let activityCsvRows = activityCsvData?.csvRows()
            let teamCsvRows = teamCsvData?.csvRows()
            
            for row in activityCsvRows! {
                
                // Store scanned data in data model
                self.storeActivity( name: row[0], latitude: Double(row[1])!, longitude: Double(row[2])!,information: row[3], link: row[4], image: row[5] )
            }
            
            for row in teamCsvRows! {
                
                self.storeTeam(name: row[0], currentUsers: Int16(row[1])!, maxUsers: Int16(row[2])!, ageGroup: row[3], mixedGenders: Bool(row[4])!, commonLanguages: row[5])
                
            }
            
        } catch {
            print(error)
        }
    }
    
    
    
    // ============================================================
    // =======================  PERSON  ===========================
    // ============================================================
    
    


}

