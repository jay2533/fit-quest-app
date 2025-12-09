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
        statsView.backButton.addGestureRecognizer(logoTap)
        
        
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
    
    
    @objc func onLogoTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Data
    
    private func loadStats() {
        guard let uid = Auth.auth().currentUser?.uid else {
            statsView.radarView.values = [0, 0, 0, 0, 0]
            statsView.updateCategoryPercentLabels([0, 0, 0, 0, 0])
            statsView.updateStatsTable(xpValues: [0, 0, 0, 0, 0],
                                       percents: [0, 0, 0, 0, 0])
            return
        }
        
        Task {
            do {
                let xp = try await statsService.fetchCategoryXPForRadar(userId: uid)
                
                let xpArray: [Int] = [
                    xp.physical,
                    xp.mental,
                    xp.social,
                    xp.creativity,
                    xp.miscellaneous
                ]
                
                let normalized = normalizeXP(xp)
                let percentArray = computePercentages(from: xpArray)
                
                await MainActor.run {
                    self.statsView.radarView.values = normalized
                    self.statsView.updateCategoryPercentLabels(percentArray)
                    self.statsView.updateStatsTable(xpValues: xpArray,
                                                    percents: percentArray)
                }
            } catch {
                print("Failed to load category XP for radar: \(error)")
                await MainActor.run {
                    self.statsView.radarView.values = [0, 0, 0, 0, 0]
                    self.statsView.updateCategoryPercentLabels([0, 0, 0, 0, 0])
                    self.statsView.updateStatsTable(xpValues: [0, 0, 0, 0, 0],
                                                    percents: [0, 0, 0, 0, 0])
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
    
    /// Compute % of total for each category, as 0–100.
    private func computePercentages(from xpValues: [Int]) -> [CGFloat] {
        let total = xpValues.reduce(0, +)
        guard total > 0 else {
            return Array(repeating: 0, count: xpValues.count)
        }
        return xpValues.map { CGFloat($0) / CGFloat(total) * 100.0 }
    }
}
