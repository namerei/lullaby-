//
//  Navigation.swift
//  Lullaby
//
//  Created by Akbar Khusanbaev on 04/12/23.
//

import Foundation

final class NavigationViewModel: ObservableObject {
    @Published var navigationPath: [NavigationOption] = [] {
        didSet {
            if navigationPath.isEmpty {
                DispatchQueue.main.async { [weak self] in
                    self?.tabBarHidden = false
                }
            }
        }
    }
    @Published var tabBarHidden: Bool = false
}

enum NavigationOption: Hashable {
    case player(UUID, AudioModel.AudioType)
    case chooseLanguage
    case privacy
    case termsOfUse
}
