//
//  ContentView.swift
//  Lullaby
//
//  Created by Akbar Khusanbaev on 04/12/23.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    @Environment(\.requestReview) private var requestReview
    @AppStorage("ratingShown") private var ratingShown: Bool = false
    
    var body: some View {
        CustomTabView()
            .onAppear(perform: {
                if !ratingShown {
                    requestReview()
                    ratingShown = true
                }
            })
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
