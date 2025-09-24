//
//  SupportedLanguages.swift
//  Lullaby
//
//  Created by Akbar Khusanbaev on 16/01/24.
//

import Foundation

struct SupportedLanguage: Identifiable {
    let id: UUID = UUID()
    let shortName: String
    let displayName: String
    init(shortName: String, displayName: String) {
        self.shortName = shortName
        self.displayName = displayName
    }
}

let supportedLanguages: [SupportedLanguage] = [
    .init(shortName: "en", displayName: "English"),
    .init(shortName: "de", displayName: "German"),
    .init(shortName: "ru", displayName: "Russian"),
    .init(shortName: "fr", displayName: "French"),
    .init(shortName: "it", displayName: "Italian"),
    .init(shortName: "es", displayName: "Spanish"),
    .init(shortName: "pt-PT", displayName: "Portugees")
]
