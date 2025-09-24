//
//  Custom+Tab+Nav.swift
//  Lullaby
//
//  Created by Akbar Khusanbaev on 04/12/23.
//

import SwiftUI

enum TabOptions: Hashable, CaseIterable {
    case stories
    case noises
    case melodies
    case settings

    var icon: String {
        switch self {
        case .melodies: "TabIconMelodies"
        case .stories: "TabIconStories"
        case .noises: "TabIconNoises"
        case .settings: "TabIconSettings"
        }
    }
    
    var iconInactive: String {
        self.icon + "Inactive"
    }
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .melodies:
            MelodiesView()
                .tag(self)
        case .stories:
            StoriesView()
                .tag(self)
        case .noises:
            NoisesView()
                .tag(self)
        case .settings:
            SettingsView()
                .tag(self)
        }
    }
}

struct CustomTabView: View {
    @State private var selection: TabOptions = .stories
    @StateObject private var navigationVM: NavigationViewModel = NavigationViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selection, content: {
                ForEach(TabOptions.allCases, id: \.self) { option in
                    NavigationStack(path: $navigationVM.navigationPath) {
                        Group {
                            option.view
                                .environmentObject(navigationVM)
                        }
                        .navigationDestination(for: NavigationOption.self) { value in
                            switch value {
                            case .player(let id, let type):
                                PlayerView(id: id, type: type)
                                    .environmentObject(navigationVM)
                            case .chooseLanguage:
                                LanguagesView()
                                    .environmentObject(navigationVM)
                            case .privacy:
                                PrivacyView()
                                    .environmentObject(navigationVM)
                            case .termsOfUse:
                                TermsOfUseView()
                                    .environmentObject(navigationVM)
                            }
                        }
                    }
                }
            })
            ZStack {
                if navigationVM.tabBarHidden == true {
                    EmptyView()
                } else {
                    HStack {
                        ForEach(TabOptions.allCases, id: \.self) { option in
                            VStack {
                                Image(selection == option ? option.icon : option.iconInactive)
                                    .resizable()
                                    .renderingMode(.template)
                                    .scaledToFit()
                                    .foregroundStyle(selection == option ? .primary : .secondary)
                                    .frame(width: 25, height: 25)
                            }
                            .frame(maxWidth: .infinity)
                            .onTapGesture {
                                selection = option
                            }
                        }
                    }
                    .padding()
                    .background(
                        Color.themeBackgroundDarker.ignoresSafeArea()
                    )
                }
            }
        }
    }
}

#Preview {
    CustomTabView()
        .preferredColorScheme(.dark)
}
