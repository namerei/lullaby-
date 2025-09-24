//
//  NoisesView.swift
//  Lullaby
//
//  Created by Akbar Khusanbaev on 04/12/23.
//

import SwiftUI

struct NoisesView: View {
    @EnvironmentObject private var navigationVM: NavigationViewModel
    @StateObject private var noisesVM: NoisesViewModel = NoisesViewModel()
    
    var body: some View {
        List(noisesVM.noises) { noise in
            HStack {
                Image(noise.bgImage)
                    .resizable()
                    .scaledToFit()
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.themeBackgroundDarker)
            .onTapGesture {
                navigationVM.navigationPath.append(.player(noise.id, noise.type))
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(.themeBackgroundDarker)
        .toolbarBackground(Color.themeBackgroundDarker, for: .navigationBar)
        .navigationTitle("White Noise 🔊".localized)
    }
}

#Preview {
    NavigationStack {
        NoisesView()
            .preferredColorScheme(.dark)
    }
}
