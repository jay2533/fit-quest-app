import UIKit
import FirebaseAuth

class StatsScreenViewController: UIViewController {
    
    let statsView = StatsScreenView()
    let statsService = StatsService.shared
    
    override func loadView() {
        view = statsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let logoTap = UITapGestureRecognizer(target: self, action: #selector(onLogoTapped))
        statsView.logoImageView.addGestureRecognizer(logoTap)
        
        statsView.profileButton.addTarget(
            self,
            action: #selector(onProfileTapped),
            for: .touchUpInside
        )
        
        loadStats()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        loadStats()  // refresh every time they come back
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func onProfileTapped() {
        let accountVC = ProfileViewController()
        navigationController?.pushViewController(accountVC, animated: true)
    }
    
    @objc func onLogoTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Data
    
    private func loadStats() {
        guard let uid = Auth.auth().currentUser?.uid else {
            statsView.radarView.values = [0, 0, 0, 0, 0]
            return
        }
        
        Task {
            do {
                let xp = try await statsService.fetchCategoryXPForRadar(userId: uid)
                let normalized = normalizeXP(xp)
                
                await MainActor.run {
                    self.statsView.radarView.values = normalized
                }
            } catch {
                print("Failed to load category XP for radar: \(error)")
                await MainActor.run {
                    self.statsView.radarView.values = [0, 0, 0, 0, 0]
                }
            }
        }
    }
    
    /// Converts raw XP to [0–1] in the order:
    /// Physical, Mental, Social, Creativity, Miscellaneous.
    private func normalizeXP(_ xp: CategoryXP) -> [CGFloat] {
        let raw: [CGFloat] = [
            CGFloat(xp.physical),
            CGFloat(xp.mental),
            CGFloat(xp.social),
            CGFloat(xp.creativity),
            CGFloat(xp.miscellaneous)
        ]
        
        guard let maxVal = raw.max(), maxVal > 0 else {
            return [0, 0, 0, 0, 0]
        }
        
        return raw.map { $0 / maxVal }
    }
}
