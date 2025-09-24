//
//  MelodiesView.swift
//  Lullaby
//
//  Created by Akbar Khusanbaev on 04/12/23.
//

import SwiftUI

struct MelodiesView: View {
    @EnvironmentObject private var navigationVM: NavigationViewModel
    @StateObject private var melodiesVM: MelodiesViewModel = MelodiesViewModel()
    
    var body: some View {
        List(melodiesVM.melodies) { melody in
            HStack {
                Image(melody.bgImage)
                    .resizable()
                    .scaledToFit()
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.themeBackgroundDarker)
            .onTapGesture {
                navigationVM.navigationPath.append(.player(melody.id, melody.type))
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(.themeBackgroundDarker)
        .navigationTitle("Bedtime Melodies 💤".localized)
        .toolbarBackground(Color.themeBackgroundDarker, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        MelodiesView()
            .preferredColorScheme(.dark)
    }
}
