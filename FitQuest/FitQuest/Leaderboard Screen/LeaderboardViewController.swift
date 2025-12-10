//
//  LeaderboardViewController.swift
//  FitQuest
//
//  Created by Rushad Daruwalla on 12/9/25.
//

import UIKit
import FirebaseFirestore

class LeaderboardViewController: UIViewController {
    
    private let leaderboardView = LeaderboardView()
    private let authService = AuthService.shared
    private let leaderboardService = LeaderboardService.shared
    
    private var topEntries: [LeaderboardEntry] = []
    private var avatarCache: [String: UIImage] = [:]  // userId -> avatar
    
    override func loadView() {
        view = leaderboardView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        leaderboardView.leaderboardTableView.delegate = self
        leaderboardView.leaderboardTableView.dataSource = self
        leaderboardView.leaderboardTableView.register(
            LeaderboardTableViewCell.self,
            forCellReuseIdentifier: LeaderboardTableViewCell.identifier
        )
        
        leaderboardView.backButton.addTarget(self, action: #selector(onBackTapped), for: .touchUpInside)
        
        loadLeaderboard()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc private func onBackTapped() {
        navigationController?.popViewController(animated: true)
    }
        
    private func loadLeaderboard() {
        guard let userId = authService.currentUserId else {
            print(" No user logged in for leaderboard")
            return
        }
        
        Task { [weak self] in
            guard let self = self else { return }
            
            // Show loading overlay
            await MainActor.run {
                self.leaderboardView.setLoading(true)
            }
            
            do {
                let (top, currentUserEntry) = try await leaderboardService.fetchLeaderboard(
                    userId: userId,
                    limit: 10
                )
                
                self.topEntries = top
                
                // Pre-load avatars for top + current user
                var allEntries = top
                if !allEntries.contains(where: { $0.userId == currentUserEntry.userId }) {
                    allEntries.append(currentUserEntry)
                }
                
                await self.loadAvatars(for: allEntries)
                
                await MainActor.run {
                    self.leaderboardView.leaderboardTableView.reloadData()
                    
                    // Podium needs top 3
                    let podiumEntries = Array(self.topEntries.prefix(3))
                    self.leaderboardView.updatePodium(
                        with: podiumEntries,
                        avatars: self.avatarCache
                    )
                    
                    let currentAvatar = self.avatarCache[currentUserEntry.userId]
                    self.leaderboardView.updateCurrentUser(
                        entry: currentUserEntry,
                        avatar: currentAvatar
                    )
                    
                    // Hide loading overlay
                    self.leaderboardView.setLoading(false)
                }
            } catch {
                await MainActor.run {
                    self.leaderboardView.setLoading(false)
                }
                print(" Failed to load leaderboard: \(error)")
            }
        }
    }
    
    private func loadAvatars(for entries: [LeaderboardEntry]) async {
        for entry in entries {
            if avatarCache[entry.userId] != nil {
                continue
            }
            
            if let urlString = entry.profileImageURL,
               !urlString.isEmpty,
               let url = URL(string: urlString) {
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    if let image = UIImage(data: data) {
                        avatarCache[entry.userId] = image
                        continue
                    }
                } catch {
                    print("Failed to load profile image for \(entry.userId): \(error.localizedDescription)")
                }
            }
            
            // Fallback to AI avatar
            let avatar = await AvatarGenerator.shared.getAIAvatar(name: entry.name, size: 60)
            avatarCache[entry.userId] = avatar
        }
    }
}

extension LeaderboardViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topEntries.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: LeaderboardTableViewCell.identifier,
            for: indexPath
        ) as? LeaderboardTableViewCell else {
            return UITableViewCell()
        }
        
        let entry = topEntries[indexPath.row]
        let avatar = avatarCache[entry.userId]
        cell.configure(entry: entry, avatar: avatar)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}
