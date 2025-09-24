//
//  Views+Extensions.swift
//  Lullaby
//
//  Created by Akbar Khusanbaev on 05/12/23.
//

import Foundation
import SwiftUI

extension View {
    
    @ViewBuilder
    func customFont(_ fontType: CustomFontType, size: CGFloat = 12) -> some View {
        font(.custom(fontType.rawValue, size: size))
    }
    
}

extension Color {
    
    
    
}

enum CustomFontType: String {
    case xl = "New York Extra Large"
    case lg = "New York Large"
    case md = "New York Medium"
    case sm = "New York Small"
}
