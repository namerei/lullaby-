//
//  CustomNavigationTitle.swift
//  Lullaby
//
//  Created by Akbar Khusanbaev on 04/12/23.
//

import SwiftUI

struct CustomNavigationTitle: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack {
            Text(title)
            Image(icon)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .customFont(.lg, size: 25)
        .fontWeight(.bold)
        .padding(.top, 42)
    }
}
