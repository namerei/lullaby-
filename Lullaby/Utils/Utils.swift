//
//  Utils.swift
//  Lullaby
//
//  Created by Akbar Khusanbaev on 04/12/23.
//

import Foundation
import UIKit

final class Utils {
    static let shared = Utils()
    private init() { }
    
    func timeString(time: TimeInterval) -> String {
        guard !(time.isNaN || time.isInfinite) else {
            return "00:00"
        }
        let minute = Int(time) / 60 % 60
        let second = Int(time) % 60
        return String(format: "%02i:%02i", minute, second)
    }
}

extension UIColor {
    var systemBackground: UIColor {
        UIColor(resource: .themeBackgroundDarker)
    }
}
