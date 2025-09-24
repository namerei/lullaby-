//
//  StoriesViewModel.swift
//  Lullaby
//
//  Created by Akbar Khusanbaev on 05/12/23.
//

import Foundation

final class StoriesViewModel: ObservableObject {
    @Published var stories: [AudioModel] = []
    
    init() {
        getStories()
    }
    
    func getStories() {
        DispatchQueue.main.async { [weak self] in
            self?.stories = LocalData.shared.allAudios.filter { $0.type == .story }
        }
    }
}
