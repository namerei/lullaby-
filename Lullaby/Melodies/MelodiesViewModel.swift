//
//  MelodiesViewModel.swift
//  Lullaby
//
//  Created by Akbar Khusanbaev on 05/12/23.
//

import Foundation

final class MelodiesViewModel: ObservableObject {
    @Published var melodies: [AudioModel] = []
    
    init() {
        getMelodies()
    }
    
    func getMelodies() {
        DispatchQueue.main.async { [weak self] in
            self?.melodies = LocalData.shared.allAudios.filter { $0.type == .melody }
        }
    }
}
