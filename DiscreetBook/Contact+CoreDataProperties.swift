//
//  Contact+CoreDataProperties.swift
//  discreetBook
//
//  Created by Jena Grafton on 11/20/15.
//  Copyright © 2015 Bella Voce Productions. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Contact {

    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var lastInitial: String?
    
    @NSManaged var workPhone: String?
    @NSManaged var homePhone: String?
    @NSManaged var mobilePhone: String?
    @NSManaged var workEmail: String?
    @NSManaged var homeEmail: String?
    @NSManaged var address: String?
    @NSManaged var city: String?
    @NSManaged var state: String?
    @NSManaged var zip: String?

}
