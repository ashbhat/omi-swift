//
//  Defaults.swift
//  scribehardware
//
//  Created by Ash Bhat on 9/28/24.
//

import Foundation

class Defaults {
    static let singleton = Defaults()
    let userDefaults = UserDefaults.standard
    
    
    func setDetailsForScribe(details: String) {
        userDefaults.setValue(details, forKey: "details")
        userDefaults.synchronize()
        
    }
    
    func detailsForScribe() -> String? {
        return userDefaults.string(forKey: "details")
    }
}
