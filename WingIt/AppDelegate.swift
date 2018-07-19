//
//  AppDelegate.swift
//  WingIt
//
//  Created by Eli Labes on 11/05/17.
//  Copyright © 2017 Eli Labes. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        #if DEBUG
            // If we are running unit tests, don't wait till app has finished launching.
            // Load dummy instead.
            if ProcessInfo.processInfo.environment["XCInjectBundleInto"] != nil {
                let viewController = UIViewController()
                let label = UILabel()
                label.text = "Running tests..."
                label.frame = viewController.view.frame
                label.textAlignment = .center
                label.textColor = .white
                viewController.view.addSubview(label)
                self.window!.rootViewController = viewController
                return true
            }
        #endif
        // Override point for customization after application launch.
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        
        let fileManager = FileManager.default
        let cacheURL = try! fileManager
            .url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let dataPath = cacheURL.appendingPathComponent("data.csv").path
        print(dataPath)
        
        // Resets app if given argument resetdata, so that tests start from a consistent clean state
        if CommandLine.arguments.contains("resetdata") {
            clearCache()
        }
        if ProcessInfo.processInfo.arguments.contains("UITests") {
            UIApplication.shared.keyWindow?.layer.speed = 100
        }
        
        // Bring up different initial view for this test - used for debugging login
        if CommandLine.arguments.contains("debugLogin") {
            clearCache()
            // Open debug window
            self.window = UIWindow(frame: UIScreen.main.bounds)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginDebugVC")
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }else{
            
            // If new version, force update.
            if let versionNum = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as? String {
                let versionFileURL = cacheURL.appendingPathComponent(".version")
                if !fileManager.fileExists(atPath: versionFileURL.path) {
                    do {
                        clearCache()
                        try versionNum.write(to: versionFileURL, atomically: false, encoding: .utf8)
                    }
                    catch {
                    }
                }else{
                    do {
                        let oldVer = try String(contentsOf: versionFileURL, encoding: .utf8)
                        if oldVer != versionNum {
                            clearCache()
                            try versionNum.write(to: versionFileURL, atomically: false, encoding: .utf8)
                        }
                    }
                    catch {
                    }
                }
            }
            
            // If we don't have data already, prompt for login.
            if !fileManager.fileExists(atPath: dataPath) {
                
                promptForLogin()
                
            }else{
                // Get data from CSV
                initTimetable()
                if checkAndRemoveBadDateData(){
                    promptForLogin()
                }
            }
        }
        
        
        
        // Register settings bundle.
        UserDefaults.standard.register(defaults: [String : Any]())
        
        // Register intent to use notifications
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        
        return true
    }
    
    func promptForLogin(){
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        self.window?.rootViewController = NavigationService.displayLoginView()
        self.window?.makeKeyAndVisible()
    }
    
    // Delete all files in app cache dir, including our data csvs.
    func clearCache(){
        let fileManager = FileManager.default
        let cacheURL = try! fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        do {
            let cachePath = cacheURL.path
            let fileNames = try fileManager.contentsOfDirectory(atPath: "\(cachePath)")
            
            for fileName in fileNames {
                
                //                    if (fileName == "cache.db-wal")
                //                    {
                let filePathName = "\(cachePath)/\(fileName)"
                
                try fileManager.removeItem(atPath: filePathName)
                //                    }
            }
            
            //            let files = try fileManager.contentsOfDirectory(atPath: "\(cachePath)")
            
            
        } catch {
            print("Could not clear: \(error)")
        }
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
        // If we are running unit tests, don't wait till app has finished launching.
        if ProcessInfo.processInfo.environment["XCInjectBundleInto"] != nil {
            return
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    
    // MARK: - Core Data stack
    
    @objc @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "coreDataTestForPreOS")
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
    
    // iOS 9 and below
    @objc lazy var applicationDocumentsDirectory: URL = {
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    @objc lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "coreDataTestForPreOS", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    
    @objc lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
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
    }()
    
    @objc lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    @objc func saveContext () {
        
        if #available(iOS 10.0, *) {
            
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
                
            } else {
                // iOS 9.0 and below - however you were previously handling it
                if managedObjectContext.hasChanges {
                    do {
                        try managedObjectContext.save()
                    } catch {
                        // Replace this implementation with code to handle the error appropriately.
                        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        let nserror = error as NSError
                        NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                        abort()
                    }
                }
                
            }
        }
    }
    
}
