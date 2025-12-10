//
//  LeaderboardView.swift
//  FitQuest
//
//  Created by Rushad Daruwalla on 12/9/25.
//

import UIKit

class LeaderboardView: UIView {
    
    
    
    // MARK: - Header
    var logoImageView: UIImageView!
    var appNameLabel: UILabel!
    var backButton: UIButton!
    
    // MARK: - Title
    var titleLabel: UILabel!
    
    // MARK: - Podium
    var podiumContainer: UIView!
    var firstPodiumView: UIView!
    var secondPodiumView: UIView!
    var thirdPodiumView: UIView!
    var firstAvatarView: UIImageView!
    var secondAvatarView: UIImageView!
    var thirdAvatarView: UIImageView!
    var firstNameLabel: UILabel!
    var secondNameLabel: UILabel!
    var thirdNameLabel: UILabel!

    
    // MARK: - Table
    var tableContainer: UIView!
    var leaderboardTableView: UITableView!
    
    // MARK: - Current User Rank
    var currentUserContainer: UIView!
    var currentUserAvatarView: UIImageView!
    var currentUserNameLabel: UILabel!
    var currentUserRankLabel: UILabel!
    var currentUserXPLabel: UILabel!
    
    static let goldColor   = UIColor(red: 1.00, green: 0.84, blue: 0.00, alpha: 1.0)
    static let silverColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
    static let bronzeColor = UIColor(red: 0.80, green: 0.50, blue: 0.20, alpha: 1.0)

    let firstRankLabel: UILabel = {
        let label = UILabel()
        label.text = "#1"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = goldColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let secondRankLabel: UILabel = {
        let label = UILabel()
        label.text = "#2"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = silverColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let thirdRankLabel: UILabel = {
        let label = UILabel()
        label.text = "#3"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = bronzeColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var loadingOverlay: UIView!
    private var loadingIndicator: UIActivityIndicatorView!
    private var loadingLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 0.08, green: 0.15, blue: 0.25, alpha: 1.0)
        
        setupHeader()
        setupTitle()
        setupPodium()
        setupTable()
        setupCurrentUserCard()
        setupLoadingOverlay()   // ⬅️ add this
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup loading overlay
    private func setupLoadingOverlay() {
        loadingOverlay = UIView()
        loadingOverlay.translatesAutoresizingMaskIntoConstraints = false
        loadingOverlay.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        addSubview(loadingOverlay)
        
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = false
        loadingOverlay.addSubview(loadingIndicator)
        
        loadingLabel = UILabel()
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingLabel.text = "Loading leaderboard..."
        loadingLabel.font = .systemFont(ofSize: 16, weight: .medium)
        loadingLabel.textColor = .white
        loadingOverlay.addSubview(loadingLabel)
        
        NSLayoutConstraint.activate([
            loadingOverlay.topAnchor.constraint(equalTo: topAnchor),
            loadingOverlay.bottomAnchor.constraint(equalTo: bottomAnchor),
            loadingOverlay.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadingOverlay.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: loadingOverlay.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: loadingOverlay.centerYAnchor, constant: -10),
            
            loadingLabel.topAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: 8),
            loadingLabel.centerXAnchor.constraint(equalTo: loadingOverlay.centerXAnchor)
        ])
        
        // start hidden by default
        loadingOverlay.isHidden = true
    }

    func setLoading(_ isLoading: Bool) {
        loadingOverlay.isHidden = !isLoading
        if isLoading {
            loadingIndicator.startAnimating()
            isUserInteractionEnabled = false
        } else {
            loadingIndicator.stopAnimating()
            isUserInteractionEnabled = true
        }
    }
    
    // MARK: - Setup Header
    
    private func setupHeader() {
        logoImageView = UIImageView()
        logoImageView.contentMode = .scaleAspectFit
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
        logoImageView.image = UIImage(systemName: "arrow.up.heart.fill", withConfiguration: config)
        logoImageView.tintColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(logoImageView)
        
        appNameLabel = UILabel()
        appNameLabel.text = "FITQUEST"
        appNameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        appNameLabel.textColor = .white
        appNameLabel.textAlignment = .center
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(appNameLabel)
        
        backButton = UIButton(type: .system)
        let backConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        backButton.setImage(UIImage(systemName: "chevron.left", withConfiguration: backConfig), for: .normal)
        backButton.tintColor = UIColor(red: 0.62, green: 0.79, blue: 0.97, alpha: 1.0)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backButton)
    }
    
    private func setupTitle() {
        titleLabel = UILabel()
        titleLabel.text = "Leaderboards"
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
    }
    
    
    // MARK: - Podium
    
    private func setupPodium() {
        podiumContainer = UIView()
        podiumContainer.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        podiumContainer.layer.cornerRadius = 18
        podiumContainer.layer.borderWidth = 1
        podiumContainer.layer.borderColor = UIColor(
            red: 0.16,
            green: 0.34,
            blue: 0.57,
            alpha: 0.7
        ).cgColor
        podiumContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(podiumContainer)
        
        // Podium blocks (the actual stand)
        func makePodiumBlock() -> UIView {
            let v = UIView()
            v.backgroundColor = UIColor.white.withAlphaComponent(0.08)
            v.layer.cornerRadius = 10
            v.layer.borderWidth = 1
            v.layer.borderColor = UIColor(
                red: 0.33,
                green: 0.67,
                blue: 0.93,
                alpha: 0.5
            ).cgColor
            v.translatesAutoresizingMaskIntoConstraints = false
            return v
        }
        
        firstPodiumView = makePodiumBlock()
        secondPodiumView = makePodiumBlock()
        thirdPodiumView = makePodiumBlock()
        
        firstPodiumView.addSubview(firstRankLabel)
        secondPodiumView.addSubview(secondRankLabel)
        thirdPodiumView.addSubview(thirdRankLabel)
        
        podiumContainer.addSubview(firstPodiumView)
        podiumContainer.addSubview(secondPodiumView)
        podiumContainer.addSubview(thirdPodiumView)
        
        func makeAvatarView(size: CGFloat) -> UIImageView {
            let imageView = UIImageView()
            imageView.layer.cornerRadius = size / 2
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }
        
        func makeNameLabel() -> UILabel {
            let label = UILabel()
            label.font = .systemFont(ofSize: 14, weight: .semibold)
            label.textColor = .white
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }
        
        firstAvatarView = makeAvatarView(size: 64)
        secondAvatarView = makeAvatarView(size: 56)
        thirdAvatarView = makeAvatarView(size: 56)
        
        firstNameLabel = makeNameLabel()
        secondNameLabel = makeNameLabel()
        thirdNameLabel = makeNameLabel()
        
        podiumContainer.addSubview(firstAvatarView)
        podiumContainer.addSubview(secondAvatarView)
        podiumContainer.addSubview(thirdAvatarView)
        podiumContainer.addSubview(firstNameLabel)
        podiumContainer.addSubview(secondNameLabel)
        podiumContainer.addSubview(thirdNameLabel)
    }

    
    // MARK: - Table
    
    private func setupTable() {
        tableContainer = UIView()
        tableContainer.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        tableContainer.layer.cornerRadius = 16
        tableContainer.layer.borderWidth = 1
        tableContainer.layer.borderColor = UIColor(red: 0.16, green: 0.34, blue: 0.57, alpha: 0.7).cgColor
        tableContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableContainer)
        
        leaderboardTableView = UITableView()
        leaderboardTableView.backgroundColor = .clear
        leaderboardTableView.separatorStyle = .none
        leaderboardTableView.translatesAutoresizingMaskIntoConstraints = false
        leaderboardTableView.isScrollEnabled = true
        tableContainer.addSubview(leaderboardTableView)
    }
    
    // MARK: - Current User Card
    
    private func setupCurrentUserCard() {
        currentUserContainer = UIView()
        currentUserContainer.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        currentUserContainer.layer.cornerRadius = 16
        currentUserContainer.layer.borderWidth = 1
        currentUserContainer.layer.borderColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 0.8).cgColor
        currentUserContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(currentUserContainer)
        
        currentUserAvatarView = UIImageView()
        currentUserAvatarView.layer.cornerRadius = 22
        currentUserAvatarView.clipsToBounds = true
        currentUserAvatarView.contentMode = .scaleAspectFill
        currentUserAvatarView.translatesAutoresizingMaskIntoConstraints = false
        currentUserContainer.addSubview(currentUserAvatarView)
        
        currentUserNameLabel = UILabel()
        currentUserNameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        currentUserNameLabel.textColor = .white
        currentUserNameLabel.translatesAutoresizingMaskIntoConstraints = false
        currentUserContainer.addSubview(currentUserNameLabel)
        
        currentUserRankLabel = UILabel()
        currentUserRankLabel.font = .systemFont(ofSize: 16, weight: .bold)
        currentUserRankLabel.textColor = UIColor(red: 0.93, green: 0.81, blue: 0.31, alpha: 1.0)
        currentUserRankLabel.textAlignment = .right
        currentUserRankLabel.translatesAutoresizingMaskIntoConstraints = false
        currentUserContainer.addSubview(currentUserRankLabel)
        
        currentUserXPLabel = UILabel()
        currentUserXPLabel.font = .systemFont(ofSize: 14, weight: .medium)
        currentUserXPLabel.textColor = UIColor(red: 0.62, green: 0.79, blue: 0.97, alpha: 1.0)
        currentUserXPLabel.textAlignment = .right
        currentUserXPLabel.translatesAutoresizingMaskIntoConstraints = false
        currentUserContainer.addSubview(currentUserXPLabel)
    }
    
    // MARK: - Constraints
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            // Header
            logoImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 40),
            logoImageView.heightAnchor.constraint(equalToConstant: 40),
            
            backButton.centerYAnchor.constraint(equalTo: logoImageView.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 32),
            backButton.heightAnchor.constraint(equalToConstant: 32),
            
            appNameLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 4),
            appNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            appNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            
            // Podium container
            podiumContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            podiumContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            podiumContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            podiumContainer.heightAnchor.constraint(equalToConstant: 170),
            
            // Table container fills the space above the current user card
            tableContainer.topAnchor.constraint(equalTo: podiumContainer.bottomAnchor, constant: 20),
            tableContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            tableContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            tableContainer.bottomAnchor.constraint(equalTo: currentUserContainer.topAnchor, constant: -16),
            
            leaderboardTableView.topAnchor.constraint(equalTo: tableContainer.topAnchor, constant: 8),
            leaderboardTableView.bottomAnchor.constraint(equalTo: tableContainer.bottomAnchor, constant: -8),
            leaderboardTableView.leadingAnchor.constraint(equalTo: tableContainer.leadingAnchor, constant: 8),
            leaderboardTableView.trailingAnchor.constraint(equalTo: tableContainer.trailingAnchor, constant: -8),
            
            // Current user card pinned to bottom
            currentUserContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            currentUserContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            currentUserContainer.heightAnchor.constraint(equalToConstant: 72),
            currentUserContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
        // Podium layout: traditional stand (2 - 1 - 3)
        NSLayoutConstraint.activate([
            // #1 Tallest block
            firstPodiumView.centerXAnchor.constraint(equalTo: podiumContainer.centerXAnchor),
            firstPodiumView.bottomAnchor.constraint(equalTo: podiumContainer.bottomAnchor, constant: -20),
            firstPodiumView.widthAnchor.constraint(equalToConstant: 70),
            firstPodiumView.heightAnchor.constraint(equalToConstant: 70),

            // #2 Medium height (left)
            secondPodiumView.trailingAnchor.constraint(equalTo: firstPodiumView.leadingAnchor, constant: -28),
            secondPodiumView.bottomAnchor.constraint(equalTo: podiumContainer.bottomAnchor, constant: -20),
            secondPodiumView.widthAnchor.constraint(equalToConstant: 60),
            secondPodiumView.heightAnchor.constraint(equalToConstant: 55),

            // #3 Shortest height (right)
            thirdPodiumView.leadingAnchor.constraint(equalTo: firstPodiumView.trailingAnchor, constant: 28),
            thirdPodiumView.bottomAnchor.constraint(equalTo: podiumContainer.bottomAnchor, constant: -20),
            thirdPodiumView.widthAnchor.constraint(equalToConstant: 60),
            thirdPodiumView.heightAnchor.constraint(equalToConstant: 40),
            
            // Avatars sitting on top of each block
            firstAvatarView.centerXAnchor.constraint(equalTo: firstPodiumView.centerXAnchor),
            firstAvatarView.bottomAnchor.constraint(equalTo: firstPodiumView.topAnchor, constant: -8),
            firstAvatarView.widthAnchor.constraint(equalToConstant: 64),
            firstAvatarView.heightAnchor.constraint(equalToConstant: 64),

            secondAvatarView.centerXAnchor.constraint(equalTo: secondPodiumView.centerXAnchor),
            secondAvatarView.bottomAnchor.constraint(equalTo: secondPodiumView.topAnchor, constant: -8),
            secondAvatarView.widthAnchor.constraint(equalToConstant: 56),
            secondAvatarView.heightAnchor.constraint(equalToConstant: 56),

            thirdAvatarView.centerXAnchor.constraint(equalTo: thirdPodiumView.centerXAnchor),
            thirdAvatarView.bottomAnchor.constraint(equalTo: thirdPodiumView.topAnchor, constant: -8),
            thirdAvatarView.widthAnchor.constraint(equalToConstant: 56),
            thirdAvatarView.heightAnchor.constraint(equalToConstant: 56),
            
            // Names just below avatars
            firstNameLabel.topAnchor.constraint(equalTo: firstPodiumView.bottomAnchor, constant: 2),
            firstNameLabel.centerXAnchor.constraint(equalTo: firstPodiumView.centerXAnchor),

            // Second place name (left)
            secondNameLabel.topAnchor.constraint(equalTo: secondPodiumView.bottomAnchor, constant: 2),
            secondNameLabel.centerXAnchor.constraint(equalTo: secondPodiumView.centerXAnchor),

            // Third place name (right)
            thirdNameLabel.topAnchor.constraint(equalTo: thirdPodiumView.bottomAnchor, constant: 2),
            thirdNameLabel.centerXAnchor.constraint(equalTo: thirdPodiumView.centerXAnchor),
            
            firstRankLabel.centerXAnchor.constraint(equalTo: firstPodiumView.centerXAnchor),
            firstRankLabel.centerYAnchor.constraint(equalTo: firstPodiumView.centerYAnchor),

            secondRankLabel.centerXAnchor.constraint(equalTo: secondPodiumView.centerXAnchor),
            secondRankLabel.centerYAnchor.constraint(equalTo: secondPodiumView.centerYAnchor),

            thirdRankLabel.centerXAnchor.constraint(equalTo: thirdPodiumView.centerXAnchor),
            thirdRankLabel.centerYAnchor.constraint(equalTo: thirdPodiumView.centerYAnchor)
        ])

        
        // Current user card layout
        NSLayoutConstraint.activate([
            currentUserAvatarView.leadingAnchor.constraint(equalTo: currentUserContainer.leadingAnchor, constant: 12),
            currentUserAvatarView.centerYAnchor.constraint(equalTo: currentUserContainer.centerYAnchor),
            currentUserAvatarView.widthAnchor.constraint(equalToConstant: 44),
            currentUserAvatarView.heightAnchor.constraint(equalToConstant: 44),
            
            currentUserNameLabel.leadingAnchor.constraint(equalTo: currentUserAvatarView.trailingAnchor, constant: 12),
            currentUserNameLabel.topAnchor.constraint(equalTo: currentUserAvatarView.topAnchor),
            
            currentUserRankLabel.trailingAnchor.constraint(equalTo: currentUserContainer.trailingAnchor, constant: -12),
            currentUserRankLabel.topAnchor.constraint(equalTo: currentUserAvatarView.topAnchor),
            
            currentUserXPLabel.trailingAnchor.constraint(equalTo: currentUserRankLabel.trailingAnchor),
            currentUserXPLabel.topAnchor.constraint(equalTo: currentUserRankLabel.bottomAnchor, constant: 4)
        ])
    }
    
    // MARK: - Update Methods
    
    func updatePodium(with entries: [LeaderboardEntry], avatars: [String: UIImage]) {
        // entries[0] = #1, [1] = #2, [2] = #3 (if they exist)
        
        if entries.indices.contains(0) {
            let e = entries[0]
            firstNameLabel.text = e.name
            firstAvatarView.image = avatars[e.userId]
        } else {
            firstNameLabel.text = "-"
            firstAvatarView.image = nil
        }
        
        if entries.indices.contains(1) {
            let e = entries[1]
            secondNameLabel.text = e.name
            secondAvatarView.image = avatars[e.userId]
        } else {
            secondNameLabel.text = "-"
            secondAvatarView.image = nil
        }
        
        if entries.indices.contains(2) {
            let e = entries[2]
            thirdNameLabel.text = e.name
            thirdAvatarView.image = avatars[e.userId]
        } else {
            thirdNameLabel.text = "-"
            thirdAvatarView.image = nil
        }
    }
    
    func updateCurrentUser(entry: LeaderboardEntry, avatar: UIImage?) {
        currentUserNameLabel.text = entry.name
        currentUserRankLabel.text = "#\(entry.rank)"
        currentUserXPLabel.text = "\(entry.totalXP) XP"
        currentUserAvatarView.image = avatar
    }
}
