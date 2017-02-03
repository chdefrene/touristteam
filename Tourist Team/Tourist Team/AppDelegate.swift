//
//  AppDelegate.swift
//  Tourist Team
//
//  Created by Christian De Frène on 22.01.2017.
//  Copyright © 2017 eurecom. All rights reserved.
//

import UIKit
import CoreData

//class Activity: NSManagedObject {
//    @NSManaged var name:String?
//    @NSManaged var information:String?
//}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        /*let defaults = UserDefaults.standard
        let isPreloaded = defaults.bool(forKey: "isPreloaded")
        if !isPreloaded {
            preloadDataFromFile()
            defaults.set(true, forKey: "isPreloaded")
        }*/
        
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
    
    /*func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }*/
    
    // MARK: - Core Data custom methods
    // As described here: https://learnappdevelopment.com/uncategorized/how-to-use-core-data-in-ios-10-swift-3/
    
    func storeActivity ( name: String,
                         latitude: Double,
                         longitude: Double,
                         information: String,
                         link: String,
                         image: String ) {
        
        let context = getContext()
        
        // Retrieve entity
        //let entity = NSEntityDescription.entity(forEntityName: "Activity", in: context)
        
        //let activity = NSManagedObject(entity: entity!, insertInto: context)
        
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
    
    func getActivity () -> [Activity] {
        
        // Create a fetch request
        let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
        
        do {
            // 1) Get the results
            let activity = try getContext().fetch(fetchRequest)
            
            return activity
            
            // 2) Do something with the results
            //for activity in searchResults {//as [NSManagedObject] {
                
                // Get the key-value pairs
                /*print ("\(activity.value(forKey: "name"))")
                print ("\(activity.value(forKey: "latitude"))")
                print ("\(activity.value(forKey: "longitude"))")
                print ("\(activity.value(forKey: "information"))")
                print ("\(activity.value(forKey: "link"))")*/
            
            //}
        } catch {
            fatalError("Error with request: \(error)")
        }
    }
    
    
    
    
    
    
    
    
    /*lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.appcoda.CoreDataDemo" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()*/
    
    
    
    /*lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("CoreDataDemo.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()*/
    
    /*lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()*/
    
    
    // MARK: - Auxiliary functions
    
    func preloadDataFromFile() {
        
        // Clear data already in listview
        removeData()
        
        // Set filepath for data file
        let csvPath = Bundle.main.path(forResource: "activityData", ofType: "csv")
        
        // No data file was found; exit method
        if csvPath == nil {
            fatalError("No data file found!")
        }
        
        // Instantiate data varaible to hold row data
        var csvData:String? = nil

        
        // Scan through data file, storing each row in the Core Data model
        do {
            csvData = try String(contentsOfFile: csvPath!,
                                 encoding: String.Encoding.utf8)
            
            // Call the csvRows method from the csvparser.swift helper file
            let csvRows = csvData?.csvRows()
            for row in csvRows! {
                
                // Store scanned data in data model
                self.storeActivity( name: row[0], latitude: Double(row[1])!, longitude: Double(row[2])!,information: row[3], link: row[4], image: row[5] )
            }
        } catch {
            print(error)
        }
    }
    
    
    func removeData() {
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
    


}

