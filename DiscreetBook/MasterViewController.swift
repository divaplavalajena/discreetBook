//
//  MasterViewController.swift
//  discreetBook
//
//  Created by Jena Grafton on 11/20/15.
//  Copyright © 2015 Bella Voce Productions. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {

    var detailViewController: DetailViewController?
    var coreDataStack: CoreDataStack!
    
    var fetchedResultsController: NSFetchedResultsController!
    
    var searchController: UISearchController!
    var searchPredicate: NSPredicate?
    
    var filteredObjects : [Contact]? = nil
    
    /*
    let collation = UILocalizedIndexedCollation.currentCollation()
    var sections: [[AnyObject]] = []
    var objects: [AnyObject] = [] {
        didSet {
            let selector: Selector = "lastInitial"
            sections = Array(count: collation.sectionTitles.count, repeatedValue: [])
            
            let sortedObjects = collation.sortedArrayFromArray(objects, collationStringSelector: selector)
            for object in sortedObjects {
                let sectionNumber = collation.sectionForObject(object, collationStringSelector: selector)
                sections[sectionNumber].append(object)
            }
            
            self.tableView.reloadData()
        }
    }
    */


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "discreetBook"
        if let font = UIFont(name: "Baskerville-BoldItalic", size: 20) {
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font]
            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.purpleColor()]
            UINavigationBar.appearance().tintColor = UIColor.purpleColor()
            UINavigationBar.appearance().barTintColor = UIColor.grayColor()
        }
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        //let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        //self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        //fetchedResultsController
        
        let fetchRequest = NSFetchRequest(entityName: "Contact")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastName", ascending: true), NSSortDescriptor(key: "firstName", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.managedObjectContext, sectionNameKeyPath: "lastInitial", cacheName: nil)
        
        // UISearchController setup
        searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController?.searchBar
        self.tableView.delegate = self
        self.definesPresentationContext = true
        
    }
    
    // MARK: - UISearchResultsUpdating Delegate Method
    // Called when the search bar's text or scope has changed or when the search bar becomes first responder.
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = self.searchController?.searchBar.text
        print(searchController.searchBar.text)
        if let searchText = searchText {
            searchPredicate = NSPredicate(format: "firstName contains[c] %@ OR lastName contains[c] %@ OR workPhone contains[c] %@ OR homePhone contains[c] %@ OR mobilePhone contains[c] %@", searchText, searchText, searchText, searchText, searchText)
            filteredObjects = self.fetchedResultsController.fetchedObjects?.filter() {
                return self.searchPredicate!.evaluateWithObject($0)
                } as! [Contact]?
            self.tableView.reloadData()
            print(searchPredicate)
        }
    }
    
    func didDismissSearchController(searchController: UISearchController) {
        searchPredicate = nil
        filteredObjects = nil
        reloadData()
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        
        reloadData()
        
    }
    
    func reloadData(predicate: NSPredicate? = nil) {
        //let fetchRequest = NSFetchRequest(entityName: "Contact")
        if searchPredicate == nil {
            fetchedResultsController.fetchRequest.predicate = predicate
            
            do {
                try fetchedResultsController.performFetch()
            } catch {
                fatalError("There was an error fetching the list of contacts!")
            }
        } else {
            filteredObjects = self.fetchedResultsController.fetchedObjects?.filter() {
                return self.searchPredicate!.evaluateWithObject($0)
            } as! [Contact]?
            //contact = filteredObjects![indexPath.row] as! Contact
        }
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if searchPredicate == nil {
                if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = self.fetchedResultsController.objectAtIndexPath(indexPath)
                    let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                    controller.detailItem = object as? Contact
                    controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                    controller.navigationItem.leftItemsSupplementBackButton = true
                    controller.coreDataStack = coreDataStack
                }
            }else {
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    let object = filteredObjects?[indexPath.row]
                    let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                    controller.detailItem = object
                    controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                    controller.navigationItem.leftItemsSupplementBackButton = true
                    controller.coreDataStack = coreDataStack
                }
            }
        }
        if segue.identifier == "addContact" {
            let controller = segue.destinationViewController as! AddContactViewController
            controller.coreDataStack = coreDataStack
            
        }

    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if searchPredicate == nil {
            return self.fetchedResultsController.sections?.count ?? 0
        } else {
            return 1
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchPredicate == nil {
            let sectionInfo = self.fetchedResultsController.sections![section]
            return sectionInfo.numberOfObjects
        } else {
            return filteredObjects?.count ?? 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsController.sections?[section].name
        //collation.sectionTitles[section]
                    //fetchedResultsController.sections?[section].name
    }
    
    /*
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String] {
        return fetchedResultsController.sectionIndexTitles
    }
    
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return fetchedResultsController.sectionForSectionIndexTitle("lastInitial", atIndex: index)
    }
    */

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        if searchPredicate == nil {
            self.configureCell(cell, atIndexPath: indexPath)
            return cell
        } else {
            // configure the cell based on filteredObjects data
            let contact = filteredObjects?[indexPath.row]
            if let lastName = contact?.lastName, firstName = contact?.firstName {
                cell.textLabel!.text = "\(firstName) \(lastName)"
            }
            
            return cell
        }
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            var contact: Contact
            if searchPredicate == nil {
                contact = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Contact
            } else {
                let filteredObjects = self.fetchedResultsController.fetchedObjects?.filter() {
                    return self.searchPredicate!.evaluateWithObject($0)
                }
                contact = filteredObjects![indexPath.row] as! Contact
            }
            let context = self.fetchedResultsController.managedObjectContext
            context.deleteObject(contact)
            
            coreDataStack.saveMainContext()
            
            reloadData()
            
        }
        

    }

    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Contact
        if let lastName = object.lastName, firstName = object.firstName {
            cell.textLabel!.text = "\(firstName) \(lastName)"
        }
        
    }

    // MARK: - Fetched results controller

//    var fetchedResultsController: NSFetchedResultsController! {
//        if _fetchedResultsController != nil {
//            return _fetchedResultsController!
//        }
//        
//        let fetchRequest = NSFetchRequest(entityName: "Contact")
//        // Edit the entity name as appropriate.
//        let entity = NSEntityDescription.entityForName("Contact", inManagedObjectContext: coreDataStack.managedObjectContext)
//        fetchRequest.entity = entity
//        
//        // Set the batch size to a suitable number.
//        fetchRequest.fetchBatchSize = 20
//        
//        // Edit the sort key as appropriate.
//            //let sortDescriptor = NSSortDescriptor(key: "lastName", ascending: false)
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastName", ascending: true), NSSortDescriptor(key: "firstName", ascending: true)]
//            //fetchRequest.sortDescriptors = [sortDescriptor]
//        
//        // Edit the section name key path and cache name if appropriate.
//        // nil for section name key path means "no sections".
//        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
//        aFetchedResultsController.delegate = self
//        _fetchedResultsController = aFetchedResultsController
//        
//        do {
//            try _fetchedResultsController!.performFetch()
//        } catch {
//             // Replace this implementation with code to handle the error appropriately.
//             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
//             //print("Unresolved error \(error), \(error.userInfo)")
//             abort()
//        }
//        
//        return _fetchedResultsController!
//    }
//    
//    var _fetchedResultsController: NSFetchedResultsController? = nil

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }

    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        /*
        var tableView = UITableView()
        if searchPredicate == nil {
            tableView = self.tableView
        } else {
            tableView = (searchController.searchResultsUpdater as! MasterViewController).tableView
        }
        */
        
        switch type {
            case .Insert:
                self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            case .Delete:
                self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            default:
                return
        }
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        var tableView = UITableView()
        
        if self.searchPredicate == nil {
            tableView = self.tableView
        } else {
            tableView = (self.searchController.searchResultsUpdater as! MasterViewController).tableView
        }
        
        switch type {
            case .Insert:
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            case .Delete:
                print("*** NSFetchedResultsChangeDelete (object)")
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            case .Update:
                print("*** NSFetchedResultsChangeUpdate (object)")
                self.configureCell(tableView.cellForRowAtIndexPath(indexPath!)!, atIndexPath: indexPath!) // original code
            case .Move:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        if self.searchPredicate == nil {
            self.tableView.endUpdates()
        } else {
            print("controllerDidChangeContent")
            (self.searchController.searchResultsUpdater as! MasterViewController).tableView.endUpdates()
        }
    }

    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
         // In the simplest, most efficient, case, reload the table view.
         self.tableView.reloadData()
     }
     */

}

