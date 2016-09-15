//
//  Setting.swift
//  discreetBook
//
//  Created by Jena Grafton on 2/24/16.
//  Copyright © 2016 Bella Voce Productions. All rights reserved.
//

import Foundation

enum SearchIndexingPreference: Int {
    case disabled, viewedRecords, allRecords
}

struct Setting {
    static var searchIndexingPreference: SearchIndexingPreference {
        let preferenceRawValue = UserDefaults.standard.integer(forKey: "SearchIndexingPreference")
        if let preference = SearchIndexingPreference(rawValue: preferenceRawValue) {
            return preference
        } else {
            return .disabled
        }
    }
}
