//
//  NoisesViewModel.swift
//  Lullaby
//
//  Created by Akbar Khusanbaev on 05/12/23.
//

import Foundation

final class NoisesViewModel: ObservableObject {
    @Published var noises: [AudioModel] = []
    
    init() {
        getNoises()
    }
    
    func getNoises() {
        DispatchQueue.main.async { [weak self] in
            self?.noises = LocalData.shared.allAudios.filter { $0.type == .noise }
        }
    }
}
