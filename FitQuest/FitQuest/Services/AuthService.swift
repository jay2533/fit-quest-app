//
//  AuthService.swift
//  FitQuest
//
//  Created by Sunny Yadav on 12/2/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class AuthService {
    
    static let shared = AuthService()
    private let auth = Auth.auth()
    private let database = Firestore.firestore()
    private let storage = Storage.storage()
    
    private init() {}
    
    func signIn(email: String, password: String) async throws {
        try await auth.signIn(withEmail: email, password: password)
    }
    
    func createUser(email: String, password: String) async throws -> String {
        let result = try await auth.createUser(withEmail: email, password: password)
        return result.user.uid
    }
    
    func updateAuthProfile(userId: String, name: String, photoURL: URL?) async throws {
        guard let user = auth.currentUser else {
            throw NSError(domain: "AuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No authenticated user"])
        }
        
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        changeRequest.photoURL = photoURL
        try await changeRequest.commitChanges()
    }
    
    func sendPasswordReset(email: String) async throws {
        try await auth.sendPasswordReset(withEmail: email)
    }
    
    func signOut() throws {
        try auth.signOut()
    }
    
    var currentUserId: String? {
        return auth.currentUser?.uid
    }
    
    var isUserLoggedIn: Bool {
        return auth.currentUser != nil
    }
}
