//
//  Setting.swift
//  discreetBook
//
//  Created by Jena Grafton on 2/24/16.
//  Copyright © 2016 Bella Voce Productions. All rights reserved.
//

import Foundation

enum SearchIndexingPreference: Int {
    case Disabled, ViewedRecords, AllRecords
}

struct Setting {
    static var searchIndexingPreference: SearchIndexingPreference {
        let preferenceRawValue = NSUserDefaults.standardUserDefaults().integerForKey("SearchIndexingPreference")
        if let preference = SearchIndexingPreference(rawValue: preferenceRawValue) {
            return preference
        } else {
            return .Disabled
        }
    }
}