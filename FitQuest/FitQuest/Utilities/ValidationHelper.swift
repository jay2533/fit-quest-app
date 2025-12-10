//
//  ValidationHelper.swift
//  FitQuest
//
//  Created by Sunny Yadav on 12/2/25.
//

import Foundation

struct ValidationHelper {
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
    
    static func isValidPassword(_ password: String) -> (isValid: Bool, message: String?) {
        guard password.count >= 6 else {
            return (false, "Password must be at least 6 characters long.")
        }
        return (true, nil)
    }
    
    static func isValidAge(birthDate: Date, minimumAge: Int = 13) -> Bool {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: now)
        
        guard let age = ageComponents.year else {
            return false
        }
        
        return age >= minimumAge
    }
    
    static func isValidName(_ name: String) -> Bool {
        return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
