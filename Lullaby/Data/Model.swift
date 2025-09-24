//
//  Model.swift
//  Lullaby
//
//  Created by Akbar Khusanbaev on 04/12/23.
//

import Foundation


struct AudioModel: Identifiable {
    let id: UUID = UUID()
    var title: String
    var description: String
    var downloadUrl: String
    var image: String
    var bgImage: String
    var type: AudioType = .melody
    var duration: Int?
    
    enum AudioType {
        case melody
        case story
        case noise
    }
}
