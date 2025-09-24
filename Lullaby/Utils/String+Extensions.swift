//
//  String+Extensions.swift
//  Lullaby
//
//  Created by Akbar Khusanbaev on 16/01/24.
//

import Foundation
import SwiftUI

extension String {
    
    var localized: String {
        var bundle = Bundle.main
        if let currentLanguage = UserDefaults.standard.string(forKey: "lang") {
            if let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") {
                bundle = Bundle(path: path) ?? Bundle.main
            } else if let path = Bundle.main.path(forResource: "en", ofType: "lproj") {
                bundle = Bundle(path: path) ?? Bundle.main
            }
            return NSLocalizedString(self, bundle: bundle, comment: "")
        } else {
            return NSLocalizedString(self, comment: "")
        }
    }
    
}
