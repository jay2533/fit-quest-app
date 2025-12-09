//
//  AvatarGenerator.swift
//  FitQuest
//
//  Created by Sunny Yadav on 12/8/25.
//

import UIKit

class AvatarGenerator {
    
    static let shared = AvatarGenerator()
    
    private init() {}
    
    // MARK: - Generate AI Avatar (Gradient)
    func generateGradientAvatar(name: String, size: CGFloat = 120) -> UIImage? {
        let colors = [
            UIColor(red: 0.55, green: 0.27, blue: 0.87, alpha: 1.0),
            UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        ]
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: size, height: size)
        gradientLayer.cornerRadius = size / 2
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        gradientLayer.render(in: context)
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return gradientImage
    }
    
    // MARK: - Generate AI Avatar (API - DiceBear)
    func generateAPIAvatar(name: String, size: Int = 120) async throws -> UIImage? {
        let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "user"
        let avatarURLString = "https://api.dicebear.com/7.x/avataaars/png?seed=\(encodedName)&size=\(size)"
        
        guard let avatarURL = URL(string: avatarURLString) else {
            return nil
        }
        
        let (imageData, _) = try await URLSession.shared.data(from: avatarURL)
        return UIImage(data: imageData)
    }
    
    // MARK: - Get AI Avatar (Try API first, fallback to gradient)
    func getAIAvatar(name: String, size: CGFloat = 120) async -> UIImage {
        // Try API first
        do {
            if let apiAvatar = try await generateAPIAvatar(name: name, size: Int(size)) {
                return apiAvatar
            }
        } catch {
            print("API avatar failed, using gradient: \(error.localizedDescription)")
        }
        
        // Fallback to gradient
        return generateGradientAvatar(name: name, size: size) ?? UIImage()
    }
}
