//
//  FirebaseErrorHandler.swift
//  FitQuest
//
//  Created by Sunny Yadav on 12/2/25.
//

import Foundation
import FirebaseAuth

struct FirebaseErrorHandler {
    
    static func getErrorMessage(from error: Error) -> String {
        let nsError = error as NSError
        
        // Check if it's a Firebase Auth error
        guard nsError.domain == AuthErrorDomain else {
            return error.localizedDescription
        }
        
        switch nsError.code {
            // Login Errors
            case AuthErrorCode.invalidEmail.rawValue:
                return "The email address is invalid."
            case AuthErrorCode.wrongPassword.rawValue:
                return "The password is incorrect."
            case AuthErrorCode.userNotFound.rawValue:
                return "No account found with this email address."
            case AuthErrorCode.userDisabled.rawValue:
                return "This account has been disabled."
            case AuthErrorCode.invalidCredential.rawValue:
                return "Invalid email or password. Please check your credentials."
            case AuthErrorCode.userTokenExpired.rawValue, AuthErrorCode.invalidUserToken.rawValue:
                return "Your session has expired. Please sign in again."
                
            // Registration Errors
            case AuthErrorCode.emailAlreadyInUse.rawValue:
                return "This email is already registered. Please sign in instead."
            case AuthErrorCode.weakPassword.rawValue:
                return "The password is too weak. Please use at least 6 characters."
            case AuthErrorCode.operationNotAllowed.rawValue:
                return "Email/password accounts are not enabled. Please contact support."
                
            // Network & System Errors
            case AuthErrorCode.networkError.rawValue:
                return "Network error. Please check your connection."
            case AuthErrorCode.tooManyRequests.rawValue:
                return "Too many unsuccessful attempts. Please try again later."
            case AuthErrorCode.internalError.rawValue:
                return "An internal error occurred. Please try again later."
                
            // Validation Errors
            case AuthErrorCode.missingEmail.rawValue:
                return "Please provide an email address."
                
            // Token/Credential Errors
            case AuthErrorCode.invalidCustomToken.rawValue, AuthErrorCode.customTokenMismatch.rawValue:
                return "Authentication token error. Please sign in again."
            case AuthErrorCode.credentialAlreadyInUse.rawValue:
                return "This credential is already associated with a different user account."
            case AuthErrorCode.accountExistsWithDifferentCredential.rawValue:
                return "An account already exists with the same email but different sign-in credentials."
                
            // Session Errors
            case AuthErrorCode.requiresRecentLogin.rawValue:
                return "This operation requires recent authentication. Please log in again."
            case AuthErrorCode.sessionExpired.rawValue:
                return "Your session has expired. Please sign in again."
                
            // Verification Errors
            case AuthErrorCode.invalidVerificationCode.rawValue:
                return "The verification code is invalid."
            case AuthErrorCode.invalidVerificationID.rawValue:
                return "The verification ID is invalid."
            case AuthErrorCode.missingVerificationCode.rawValue:
                return "Please provide a verification code."
                
            // Action Code Errors
            case AuthErrorCode.expiredActionCode.rawValue:
                return "This link has expired."
            case AuthErrorCode.invalidActionCode.rawValue:
                return "This link is invalid or has already been used."
                
            // Default fallback
            default:
                print("Full error: \(error)")
                return "Authentication failed. Please check your credentials and try again."
        }
    }
}
