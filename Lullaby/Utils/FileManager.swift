//
//  FileManager.swift
//  Lullaby
//
//  Created by Akbar Khusanbaev on 05/12/23.
//

import Foundation

final class LocalFileManager {
    
    static let shared = LocalFileManager()
    let folderName = "Lullaby_Audios"
    
    private init() {
        createFolderIfNeeded()
    }
    
    func createFolderIfNeeded() {
        guard
            let path = FileManager
                .default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent(folderName)
                .path else {
            return
        }
        
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                print("Success creating folder.")
            } catch let error {
                print("Error creating folder. \(error)")
            }
        }
    }
    
    func deleteFolder() {
        guard
            let path = FileManager
                .default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent(folderName)
                .path else {
            return
        }
        do {
            try FileManager.default.removeItem(atPath: path)
            print("Success deleting folder.")
        } catch let error {
            print("Error deleting folder. \(error)")
        }
    }
    
    func saveAudio(data: Data, name: String) -> String {
        guard let path = getPathForAudio(name: name) else {
            return "Error getting data."
        }
        
        do {
            try data.write(to: path)
            return "Success saving!"
        } catch let error {
            return "Error saving. \(error)"
        }
    }
    
    func getAudio(name: String) -> Data? {
        guard
            let path = getPathForAudio(name: name),
            FileManager.default.fileExists(atPath: path.path) else {
            print("Error getting path.")
            return nil
        }
        
        do {
            return try Data(contentsOf: path)
        } catch {
            print(error)
            return nil
        }
    }
    
    func deleteAudio(name: String) -> String {
        guard
            let path = getPathForAudio(name: name)?.path,
            FileManager.default.fileExists(atPath: path) else {
            return "Error getting path."
        }
        
        do {
            try FileManager.default.removeItem(atPath: path)
            return "Sucessfully deleted."
        } catch let error {
            return "Error deleting image. \(error)"
        }
        
    }
    
    
    func getPathForAudio(name: String) -> URL? {
        guard
            let path = FileManager
                .default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent(folderName)
                .appendingPathComponent("\(name).mp3") else {
            print("Error getting path.")
            return nil
        }
        
        return path
    }
    
}
