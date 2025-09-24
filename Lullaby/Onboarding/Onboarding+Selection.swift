//
//  Onboarding+Selection.swift
//  Lullaby
//
//  Created by Akbar Khusanbaev on 05/12/23.
//

import Foundation

enum OnboardingSelectionItem: Hashable, CaseIterable {
    case first
    case second
    case third
    
    var next: OnboardingSelectionItem {
        switch self {
        case .first: .second
        case .second: .third
        case .third: .first
        }
    }
    
    var image: String {
        switch self {
        case .first: "Onboarding_1"
        case .second: "Onboarding_2"
        case .third: "Onboarding_3"
        }
    }
    
    var video: String {
        switch self {
        case .first: "Onboarding_1"
        case .second: "Onboarding_2"
        case .third: "Onboarding_3"
        }
    }
    
    var text: String {
        switch self {
        case .first: "Welcome to the magical world of fairy tales and soothing baby sounds".localized
        case .second: "A unique collection of children's lullabies and fascinating fairy tales".localized
        case .third: "White noise will help your baby fall asleep without being distracted by extraneous sounds".localized
        }
    }
}
