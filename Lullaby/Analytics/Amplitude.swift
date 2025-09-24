//
//  Amplitude.swift
//  Lullaby
//
//  Created by Akbar Khusanbaev on 06/12/23.
//

import Foundation
import AmplitudeSwift

final class AmplitudeManager {
    static let shared = AmplitudeManager()
    private init() { 
        self.amplitude = Amplitude(configuration: Configuration(apiKey: "fbfb0c196ff470d366d39e7b74d3de3e"))
    }
    
    let amplitude: Amplitude
    
}

// AmplitudeManager.shared.amplitude
