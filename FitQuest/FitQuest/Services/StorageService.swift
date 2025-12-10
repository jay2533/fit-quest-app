//
//  StorageService.swift
//  FitQuest
//
//  Created by Sunny Yadav on 12/2/25.
//

import Foundation
import UIKit
import FirebaseStorage

class StorageService {
    
    static let shared = StorageService()
    private let storage = Storage.storage()
    
    private init() {}
    
    func uploadProfileImage(_ image: UIImage) async throws -> URL {
        guard let jpegData = image.jpegData(compressionQuality: 0.5) else {
            throw NSError(domain: "StorageService", code: -1,
                         userInfo: [NSLocalizedDescriptionKey: "Failed to compress image"])
        }
        
        let storageRef = storage.reference()
        let imageRef = storageRef.child("profileImages/\(UUID().uuidString).jpg")
        
        _ = try await imageRef.putDataAsync(jpegData)
        let downloadURL = try await imageRef.downloadURL()
        
        return downloadURL
    }
    
    func deleteProfileImage(url: String) async throws {
        let storageRef = storage.reference(forURL: url)
        try await storageRef.delete()
    }
}
