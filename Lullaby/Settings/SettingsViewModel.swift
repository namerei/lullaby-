//
//  SettingsViewModel.swift
//  Lullaby
//
//  Created by Akbar Khusanbaev on 09/12/23.
//

import Foundation

final class SettingsViewModel: ObservableObject {
    @Published var isDeleting: Bool = false
    
    @MainActor
    func deleteCache() async throws {
        isDeleting = true
        try await Task.sleep(nanoseconds: 500_000)
        LocalFileManager.shared.deleteFolder()
        try await Task.sleep(nanoseconds: 500_000)
        isDeleting = false
    }
}
