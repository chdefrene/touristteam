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
        
        
        // Define some dummy relationships
        
        // 0    Marineland              A-team              David
        // 1    Plage de la Gravette    Equipe Francais     Emma
        // 2    Musée Picasso           Team Johaug         Jone
        // 3    Absinthe Bar            Team mobserv        Chris
        // 4    Dave's Trivia Night     Test team
        // 5    The Hop Store

        
        // David, Emma in the A-team
        //addPersonRelationships(fromIndex: 0, toIndex: 0) // David
        //addPersonRelationships(fromIndex: 1, toIndex: 0) // Emma
        
        
        
        
        
        
        // Add a relationship from second activity to second teamActivity
        // => Marineland is in
        //addActivityRelationships(fromIndex: 1, toIndex: 1)
        
        // Add a relationship from second team to second teamActivity,
        // and to second person
        /*addTeamRelationships(fromIndex: 1,
                             toTeamActivityIndex: 1,
                             toPersonIndex: 1)*/
        
        // Add a relationship from second person to second team
        //addPersonRelationships(fromIndex: 1, toIndex: 1)
        
        
        
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
    
    func addActivityRelationships( fromIndex:Int,
                                   toIndex:Int ) {
        
        let context = self.getContext()
        let activityFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Activity")
        let teamActivityFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TeamActivity")
        
        do {
            let activity = try context.fetch(activityFetchRequest) as! [Activity]
            let teamActivity = try context.fetch(teamActivityFetchRequest) as! [TeamActivity]
            
            activity[fromIndex].setValue(NSSet(object: teamActivity[toIndex]), forKey: "fromActivity")
        
        } catch {
            print(error)
        }
        
        do {
            try context.save()
        } catch {
            print(error)
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
    
    
    // Check if 
    func addTeamRelationships( fromIndex:Int,
                               toTeamActivityIndex:Int,
                               toPersonIndex:Int ) {
        
        let context = self.getContext()
        let teamFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Team")
        let teamActivityFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TeamActivity")
        let personFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        
        do {
            let team = try context.fetch(teamFetchRequest) as! [Team]
            
            
            let person = try context.fetch(personFetchRequest) as! [Person]
            
            let teamActivity = try context.fetch(teamActivityFetchRequest) as! [TeamActivity]
            
            
            team[fromIndex].setValue(NSSet(object: teamActivity[toTeamActivityIndex]), forKey: "fromTeam")
            team[fromIndex].setValue(NSSet(object: person[toPersonIndex]), forKey: "person")
            
        } catch {
            print(error)
        }
        
        do {
            try context.save()
        } catch {
            print(error)
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
    
    
    func addPersonRelationships( fromIndex:Int,
                                 toIndex:Int ) {
        
        let context = self.getContext()
        
        var person: NSManagedObject? = nil
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        do {
            let persons = try context.execute(fetchRequest)
        } catch {
            print(error)
        }
        
        /*if let person = person {
            if person.valueForKey("name") == nil {
                person.setValue("Shopping List", forKey: "name")
            }
            
            if list.valueForKey("createdAt") == nil {
                list.setValue(NSDate(), forKey: "createdAt")
            }
            
            //let persons = person.mutableSetValue(forKey: "team")
            
            // Create Item Record
            
            //let entityDescription = NSEntityDescription.entity(forEntityName: "Person", in: context)
            
            if let person = NSManagedObject.entity() {
                // Set Attributes
                //item.setValue("Item \(items.count + 1)", forKey: "name")
                //item.setValue(NSDate(), forKey: "createdAt")
                
                // Set Relationship
                person.setValue(person, forKey: "team")
                
                // Add Item to Items
                persons.addObject(person)
            }
            
            
            //print("number of items: \(items.count)")
            //print("---")
            
            for itemRecord in persons {
                print(person.value(forKey: "name"))
            }
        }*/
        
        
        
        /*let context = self.getContext()
        let personFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        let teamFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Team")
        
        do {
            let person = try context.fetch(personFetchRequest) as! [Person]
            let team = try context.fetch(teamFetchRequest) as! [Team]
            
            
            if let addPerson = createdRecord
            
            
            //let addTeam = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context) as! Person

            
            let items = person[fromIndex].mutableSetValue(forKey: "team")
            
            for itemRecord in items {
                
            }
            
            items.add(team[toIndex])
            

            //person[fromIndex].team = NSMutableSet(object: team[toIndex])
            
            //person.setValue(NSSet(object: team[toIndex]), forKey: "team")
        
            
        } catch {
            print(error)
        }
        
        do {
            try context.save()
        } catch {
            print(error)
        }*/
    }
    
    
    // ============================================================
    // ====================  TEAM ACTIVITY  =======================
    // ============================================================
    
    
    func getTeamActivity() -> [TeamActivity] {
        
        // Create a fetch request
        let fetchRequest: NSFetchRequest<TeamActivity> = TeamActivity.fetchRequest()
        
        do {
            // Get the results
            let teamActivity = try getContext().fetch(fetchRequest)
            
            return teamActivity
            
        } catch {
            fatalError("Error with request: \(error)")
        }
    }
    
    
    func storeTeamActivity ( date: Date,
                             startTime: Double,
                             endTime: Double ) {
        
        let context = getContext()
        
        let teamActivity = NSEntityDescription.insertNewObject(forEntityName: "TeamActivity", into: context) as! TeamActivity
        
        // Set the values
        teamActivity.setValue(date, forKey: "date")
        teamActivity.setValue(startTime, forKey: "start_time")
        teamActivity.setValue(endTime, forKey: "end_time")
        
        // Save object
        do {
            try context.save()
            //print(activity.name!)
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func removeTeamActivitiesData() {
        // Remove the existing items
        let context = self.getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TeamActivity")
        
        do {
            let teamActivities = try context.fetch(fetchRequest) as! [TeamActivity]
            
            for teamActivity in teamActivities {
                context.delete(teamActivity)
            }
        } catch let e as NSError? {
            print("Failed to retrieve record: \(e!.localizedDescription)")
        }
    }
    
     
    // Core data makes this automatically based on the other relationships !
    
    //func addTeamActivityRelationships( index:Int ) {}
    
    
    
    
    
    
    
    // MARK: - Auxiliary functions
    
    
    // Preload activities and users from local data files
    // These are static, so they are not on the server
    func preloadDataFromFile() {
        
        // Clear data already in listview
        removeActivitiesData()
        //removeTeamData()
        removePersonData()
        
        // Set filepath for data file
        let activityCsvPath = Bundle.main.path(forResource: "activityData", ofType: "csv")
        //let teamCsvPath = Bundle.main.path(forResource: "teamData", ofType: "csv")
        let personCsvPath = Bundle.main.path(forResource: "personData", ofType: "csv")
        
        // No data file was found; exit method
        if activityCsvPath == nil {
            fatalError("No activity data file found!")
        }
        /*if teamCsvPath == nil {
            fatalError("No team data file found!")

        }*/

        if personCsvPath == nil {
            fatalError("No person data file found!")
        }
        
        // Instantiate data varaible to hold row data
        var activityCsvData:String? = nil
        //var teamCsvData:String? = nil
        var personCsvData:String? = nil

        
        // Scan through data file, storing each row in the Core Data model
        do {
            activityCsvData = try String(contentsOfFile: activityCsvPath!,
                                 encoding: String.Encoding.utf8)

            //teamCsvData = try String(contentsOfFile: teamCsvPath!, encoding: String.Encoding.utf8)
            personCsvData = try String(contentsOfFile: personCsvPath!,
                                encoding: String.Encoding.utf8)
            
            // Call the csvRows method from the csvparser.swift helper file
            let activityCsvRows = activityCsvData?.csvRows()
            //let teamCsvRows = teamCsvData?.csvRows()
            let personCsvRows = personCsvData?.csvRows()
            
            for row in activityCsvRows! {
                
                // Store scanned data in data model
                self.storeActivity( name: row[0], latitude: Double(row[1])!, longitude: Double(row[2])!,information: row[3], link: row[4], image: row[5] )
            }
    
            for row in personCsvRows! {
    
                // Store scanned data in data model
                self.storePerson(age: Int16(row[0])!, gender: row[1], image: row[2], languages: row[3], name: row[4], password: row[5], username: row[6])
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
    
    
    
/*
    func addLanguageToTeam(teamName: String) {}
    
    
    // NOTE: Don't use this one
    //       Better to use the GAE server
    // Add a new line to one of the data files
    func writeDataToEndOfTeamdataFile(fileName: String, data: Data) {
        
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
    }
*/
/*
    // Update one of the attributes in a data file
    func increaseNumberOfUsersInTeam(fileName: String,
                                     selectedTeam: String) {
        
        
        // Translate attribute name into position in data file
        let numOfCommas = 1
        
        switch attribute {
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
        
        }
        
        
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
                }
            } catch {
                    print(error)
            }
            
            print("First position: \(firstPos)")
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
            }
        }
    }

*/
}

