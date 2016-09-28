//
//  Contact+CoreDataProperties.swift
//  discreetBook
//
//  Created by Jena Grafton on 9/16/16.
//  Copyright © 2016 Bella Voce Productions. All rights reserved.
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact");
    }

    @NSManaged public var address: String?
    @NSManaged public var city: String?
    @NSManaged public var firstName: String?
    @NSManaged public var homeEmail: String?
    @NSManaged public var homePhone: String?
    @NSManaged public var lastInitial: String?
    @NSManaged public var lastName: String?
    @NSManaged public var mobilePhone: String?
    @NSManaged public var state: String?
    @NSManaged public var workEmail: String?
    @NSManaged public var workPhone: String?
    @NSManaged public var zip: String?

}
