//
//  AppDelegate.swift
//  discreetBook
//
//  Created by Jena Grafton on 11/20/15.
//  Copyright © 2015 Bella Voce Productions. All rights reserved.
//

import UIKit
import CoreData
import CoreSpotlight

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack()
    var fetchedResultsController: NSFetchedResultsController!


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        /*
        switch Setting.searchIndexingPreference {
        case .Disabled:
            EmployeeService().destroyEmployeeIndexing()
        case .AllRecords:
            EmployeeService().indexAllEmployees()
        default: break
        }
        */
        
        let fetchRequest = NSFetchRequest(entityName: "Contact")
        
        do {
            let results = try coreDataStack.managedObjectContext.executeFetchRequest(fetchRequest) as! [Contact]
            if results.count == 0 {
                addTestData()
            }
        } catch {
            print("There was a fetch error!")
        }

        if let tab = window?.rootViewController as? UISplitViewController {
            for child in tab.viewControllers ?? [] {
                if let child = child as? UINavigationController, top = child.topViewController {
                    if top.respondsToSelector("setCoreDataStack:") {
                        top.performSelector("setCoreDataStack:", withObject: coreDataStack)
                    }
                }
            }
        }
        
        
        
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
        splitViewController.delegate = self

        let masterNavigationController = splitViewController.viewControllers[0] as! UINavigationController
        let controller = masterNavigationController.topViewController as! MasterViewController
        controller.coreDataStack.managedObjectContext = coreDataStack.managedObjectContext
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            splitViewController.preferredDisplayMode = .AllVisible
            if let detailVC = navigationController.topViewController as? DetailViewController {
                if detailVC.detailItem == nil {
                    do {
                        let results = try coreDataStack.managedObjectContext.executeFetchRequest(fetchRequest) as! [Contact]
                        if results.count != 0 {
                            detailVC.detailItem = results[0]
                        }
                    } catch {
                        print("There was a fetch error!")
                    }
                }
            }
        }
        
        
        

        return true
    }
    
    func addTestData(){
        guard let entity = NSEntityDescription.entityForName("Contact", inManagedObjectContext: coreDataStack.managedObjectContext) else {
            fatalError("Could not find entity description!")
        }
        
        let contact1 = Contact(entity: entity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
        contact1.firstName = "Leia"
        contact1.lastName = "Organa-Solo"
        contact1.lastInitial = "O"
        let contact2 = Contact(entity: entity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
        contact2.firstName = "Han"
        contact2.lastName = "Solo"
        contact2.lastInitial = "S"
        let contact3 = Contact(entity: entity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
        contact3.firstName = "Luke"
        contact3.lastName = "Skywalker"
        contact3.lastInitial = "S"
        contact3.workPhone = "(555)123-1977"
        contact3.homePhone = "(555)123-1977"
        contact3.mobilePhone = "(555)849-1138"
        contact3.workEmail = "luke_skywalker1@rebellion.org"
        contact3.homeEmail = "whinyjedi@theforce.com"
        contact3.address = "1 Moisture Farm Rd"
        contact3.city = "Mos Eisley Outskirts"
        contact3.state = "Tatooine"
        contact3.zip = "89179"
        let contact4 = Contact(entity: entity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
        contact4.firstName = "Obi-Wan"
        contact4.lastName = "Kenobi"
        contact4.lastInitial = "K"
        let contact5 = Contact(entity: entity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
        contact5.firstName = "Mace"
        contact5.lastName = "Windu"
        contact5.lastInitial = "W"
        let contact6 = Contact(entity: entity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
        contact6.firstName = "Darth"
        contact6.lastName = "Vader"
        contact6.lastInitial = "V"
        let contact7 = Contact(entity: entity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
        contact7.firstName = "Anakin"
        contact7.lastName = "Skywalker"
        contact7.lastInitial = "S"
        let contact8 = Contact(entity: entity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
        contact8.firstName = "Poe"
        contact8.lastName = "Dameron"
        contact8.lastInitial = "D"
        let contact9 = Contact(entity: entity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
        contact9.firstName = "Lando"
        contact9.lastName = "Calrissian"
        contact9.lastInitial = "C"
        let contact10 = Contact(entity: entity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
        contact10.firstName = "Boba"
        contact10.lastName = "Fett"
        contact10.lastInitial = "F"
        let contact11 = Contact(entity: entity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
        contact11.firstName = "Mara"
        contact11.lastName = "Jade"
        contact11.lastInitial = "J"
        let contact12 = Contact(entity: entity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
        contact12.firstName = "Jabba the"
        contact12.lastName = "Hutt"
        contact12.lastInitial = "H"
        
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        coreDataStack.saveMainContext()
        
    }

    // MARK: - Split view

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
        if topAsDetailController.detailItem == nil {
            
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }
    
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        
        let splitController = window?.rootViewController as? UISplitViewController
        let navigationController = splitController?.viewControllers.first as? MasterViewController
        navigationController?.restoreUserActivityState(userActivity)
        
        return true
        
        /*
        let firstName: String
        if userActivity.activityType == "com.bellavoceproductions.discreet-Book.contactsearch",
            let activityObjectId = userActivity.userInfo?["firstName"] as? String {
                // Handle result from NSUserActivity indexing
                firstName = activityObjectId
        } else if userActivity.activityType == CSSearchableItemActionType,
            let activityObjectId = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String  {
                // Handle result from CoreSpotlight indexing
                firstName = activityObjectId
        } else {
            return false
        }
        
        //TODO: try pushViewController() method in the future
        if let splitController = window?.rootViewController as? UISplitViewController,
            navigationController = splitController.viewControllers.first as? MasterViewController,
            contact = contactWithFirstName(firstName) {
                navigationController.restoreUserActivityState(userActivity)
                //popToRootViewControllerAnimated(false)
                //navigationController.topViewController?.restoreUserActivityState(userActivity)
                
                
                let contactViewController = navigationController
                    .storyboard?
                    .instantiateViewControllerWithIdentifier("ContactView") as! DetailViewController
                
                contactViewController.detailItem = contact
                splitController.showDetailViewController(contactViewController, sender: self)
                //(contactViewController, animated: false)
                
                return true
        }
        
        return false
        */
        
        /*
        let splitController = self.window?.rootViewController as! UISplitViewController
        let navigationController = splitController.viewControllers.first as! UINavigationController
        navigationController.topViewController?.restoreUserActivityState(userActivity)
        return true
        */
    }
    
    func contactWithFirstName(firstName: String) -> Contact? {
        let fetchRequest = NSFetchRequest(entityName: "Contact")
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        let contacts = fetchedResultsController.fetchedObjects as! [Contact]
        let filteredContacts = contacts.filter { $0.firstName == firstName }
        
        return filteredContacts.first
    }

    
}

