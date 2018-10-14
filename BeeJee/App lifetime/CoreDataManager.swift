//
//  CoreDataManager.swift
//  BeeJee
//
//  Created by Daenim on 10/14/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import CoreData
import PluggableApplicationDelegate

class CoreDataManager: NSObject, ApplicationService {
    
    static let shared = CoreDataManager()
    
    fileprivate override init() {
        super.init()
    }
    
    //App Delegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        //read data
        {
            guard let path = Bundle.main.path(forResource: "initial data", ofType: "json")
                else { return }
            guard let data = try? Data(contentsOf: URL(fileURLWithPath: path))
                else { return }
            
            let decoder = JSONDecoder()
            decoder.userInfo = [.coreDataContext : context]
            
            guard let contacts = try? decoder.decode([Contact].self, from: data)
                else { return }
            
            contacts.forEach {
                context.insert($0)
            }
            
            try? FileManager.default.removeItem(atPath: path)
            
            try? context.save()
        }()

        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        saveContext()
    }
    
    // MARK: - Core Data stack
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "BeeJee")
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
        container.viewContext.mergePolicy = NSMergePolicy(merge: NSMergePolicyType.mergeByPropertyStoreTrumpMergePolicyType)
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
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
    }
}
