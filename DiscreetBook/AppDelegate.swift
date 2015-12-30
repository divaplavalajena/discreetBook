//
//  AppDelegate.swift
//  discreetBook
//
//  Created by Jena Grafton on 11/20/15.
//  Copyright © 2015 Bella Voce Productions. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
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
        

        return true
    }
    
    func addTestData(){
        guard let entity = NSEntityDescription.entityForName("Contact", inManagedObjectContext: coreDataStack.managedObjectContext) else {
            fatalError("Could not find entity description!")
        }
        
        let contact1 = Contact(entity: entity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
        contact1.firstName = "Jena"
        contact1.lastName = "Grafton"
        contact1.homePhone = "512-716-3005"
        contact1.workPhone = "512-826-1486"
        contact1.mobilePhone = "512-826-1486"
        contact1.workEmail = "JenaLGrafton@aol.com"
        contact1.homeEmail = "Divaplavalajena@aol.com"
        contact1.address = "3614 Eagles Nest"
        contact1.city = "Round Rock"
        contact1.state = "TX"
        contact1.zip = "78665"
        let contact2 = Contact(entity: entity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
        contact2.firstName = "Cody"
        contact2.lastName = "Bridges"
        
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
    
}

