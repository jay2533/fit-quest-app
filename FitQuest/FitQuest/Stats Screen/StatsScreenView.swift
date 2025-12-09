import UIKit

class StatsScreenView: UIView {
    
    // MARK: - Header
    var appNameLabel: UILabel!
    var backButton: UIButton!


    // MARK: - Title
    var statsTitleLabel: UILabel!
    
    // MARK: - Radar Chart
    var radarView: StatsRadarView!
    
    // Category labels
    var physicalLabel: UILabel!
    var mentalLabel: UILabel!
    var socialLabel: UILabel!
    var creativityLabel: UILabel!
    var miscellaneousLabel: UILabel!
    
    // Percentage labels near each category
    var physicalPercentLabel: UILabel!
    var mentalPercentLabel: UILabel!
    var socialPercentLabel: UILabel!
    var creativityPercentLabel: UILabel!
    var miscellaneousPercentLabel: UILabel!
    
    // MARK: - Stats Table
    private var statsTableContainer: UIView!
    private var statsTableStack: UIStackView!
    private var xpValueLabels: [UILabel] = []
    private var percentValueLabels: [UILabel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.08, green: 0.15, blue: 0.25, alpha: 1.0)
        
        setupHeader()
        setupTitle()
        setupRadarChart()
        setupCategoryLabels()
        setupStatsTable()
        
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setupHeader() {
        backButton = UIButton(type: .system)
        let backConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        backButton.setImage(UIImage(systemName: "chevron.left", withConfiguration: backConfig), for: .normal)
        backButton.tintColor = UIColor(red: 0.62, green: 0.79, blue: 0.97, alpha: 1.0)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backButton)

        appNameLabel = UILabel()
        appNameLabel.text = "FITQUEST"
        appNameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        appNameLabel.textColor = .white
        appNameLabel.textAlignment = .center
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(appNameLabel)
        
    }
    
    func setupTitle() {
        statsTitleLabel = UILabel()
        statsTitleLabel.text = "Stats"
        statsTitleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        statsTitleLabel.textColor = UIColor(red: 0.33, green: 0.67, blue: 0.93, alpha: 1.0)
        statsTitleLabel.textAlignment = .center
        statsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(statsTitleLabel)
    }
    
    func setupRadarChart() {
        radarView = StatsRadarView()
        radarView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(radarView)
    }
    
    func makeCategoryLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func makePercentLabel() -> UILabel {
        let label = UILabel()
        label.text = "0%"
        label.font = .systemFont(ofSize: 11, weight: .medium)
        label.textColor = UIColor(red: 0.72, green: 0.85, blue: 1.0, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func setupCategoryLabels() {
        physicalLabel = makeCategoryLabel(text: "Physical")
        mentalLabel = makeCategoryLabel(text: "Mental")
        socialLabel = makeCategoryLabel(text: "Social")
        creativityLabel = makeCategoryLabel(text: "Creativity")
        miscellaneousLabel = makeCategoryLabel(text: "Miscellaneous")
        
        addSubview(physicalLabel)
        addSubview(mentalLabel)
        addSubview(socialLabel)
        addSubview(creativityLabel)
        addSubview(miscellaneousLabel)
        
        physicalPercentLabel = makePercentLabel()
        mentalPercentLabel = makePercentLabel()
        socialPercentLabel = makePercentLabel()
        creativityPercentLabel = makePercentLabel()
        miscellaneousPercentLabel = makePercentLabel()
        
        addSubview(physicalPercentLabel)
        addSubview(mentalPercentLabel)
        addSubview(socialPercentLabel)
        addSubview(creativityPercentLabel)
        addSubview(miscellaneousPercentLabel)
    }
    
    private func setupStatsTable() {
        statsTableContainer = UIView()
        statsTableContainer.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        statsTableContainer.layer.cornerRadius = 16
        statsTableContainer.layer.borderWidth = 1
        statsTableContainer.layer.borderColor = UIColor(
            red: 0.16,
            green: 0.34,
            blue: 0.57,
            alpha: 0.7
        ).cgColor
        statsTableContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(statsTableContainer)
        
        statsTableStack = UIStackView()
        statsTableStack.axis = .vertical
        statsTableStack.alignment = .fill
        statsTableStack.distribution = .fillEqually
        statsTableStack.spacing = 10      // 🔹 more space between rows
        statsTableStack.translatesAutoresizingMaskIntoConstraints = false
        statsTableContainer.addSubview(statsTableStack)
        
        // Header row
        let headerRow = makeTableRow(
            categoryText: "Category",
            xpText: "XP",
            percentText: "% of total",
            isHeader: true
        )
        statsTableStack.addArrangedSubview(headerRow)
        
        // Data rows in same order as CategoryXP + radar
        let names = ["Physical", "Mental", "Social", "Creativity", "Miscellaneous"]
        for name in names {
            let row = makeTableRow(
                categoryText: name,
                xpText: "0",
                percentText: "0%",
                isHeader: false
            )
            statsTableStack.addArrangedSubview(row)
        }
    }

    private func makeTableRow(categoryText: String,
                              xpText: String,
                              percentText: String,
                              isHeader: Bool) -> UIStackView {
        let row = UIStackView()
        row.axis = .horizontal
        row.alignment = .center
        row.distribution = .fillEqually
        
        // 🔹 Bigger fonts
        let baseFontSize: CGFloat = isHeader ? 18 : 16
        
        let categoryLabel = UILabel()
        categoryLabel.text = categoryText
        categoryLabel.textAlignment = .left
        categoryLabel.font = .systemFont(ofSize: baseFontSize,
                                         weight: isHeader ? .semibold : .regular)
        categoryLabel.textColor = .white
        
        let xpLabel = UILabel()
        xpLabel.text = xpText
        xpLabel.textAlignment = .center
        xpLabel.font = .systemFont(ofSize: baseFontSize,
                                   weight: isHeader ? .semibold : .regular)
        xpLabel.textColor = .white
        
        let percentLabel = UILabel()
        percentLabel.text = percentText
        percentLabel.textAlignment = .right
        percentLabel.font = .systemFont(ofSize: baseFontSize,
                                        weight: isHeader ? .semibold : .regular)
        percentLabel.textColor = .white
        
        row.addArrangedSubview(categoryLabel)
        row.addArrangedSubview(xpLabel)
        row.addArrangedSubview(percentLabel)
        
        if !isHeader {
            xpValueLabels.append(xpLabel)
            percentValueLabels.append(percentLabel)
        }
        
        return row
    }

    
    // MARK: - Constraints
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            // Header
            backButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 35),
            backButton.heightAnchor.constraint(equalToConstant: 35),
            
            appNameLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            appNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            
            // Title
            statsTitleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 24),
            statsTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            statsTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            
            // Radar view
            radarView.topAnchor.constraint(equalTo: statsTitleLabel.bottomAnchor, constant: 32),
            radarView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            radarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7),
            radarView.heightAnchor.constraint(equalTo: radarView.widthAnchor)
        ])
        
        // Category labels & percent labels around the radar
        NSLayoutConstraint.activate([
            // Top (Physical)
            physicalLabel.bottomAnchor.constraint(equalTo: radarView.topAnchor, constant: -6),
            physicalLabel.centerXAnchor.constraint(equalTo: radarView.centerXAnchor),
            
            physicalPercentLabel.topAnchor.constraint(equalTo: physicalLabel.bottomAnchor, constant: 2),
            physicalPercentLabel.centerXAnchor.constraint(equalTo: physicalLabel.centerXAnchor),
            
            // Left middle (Miscellaneous)
            miscellaneousLabel.centerYAnchor.constraint(equalTo: radarView.centerYAnchor, constant: -70),
            miscellaneousLabel.trailingAnchor.constraint(equalTo: radarView.leadingAnchor, constant: 35),
            miscellaneousLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 5),
            
            miscellaneousPercentLabel.topAnchor.constraint(equalTo: miscellaneousLabel.bottomAnchor, constant: 2),
            miscellaneousPercentLabel.centerXAnchor.constraint(equalTo: miscellaneousLabel.centerXAnchor),
            
            // Right middle (Mental)
            mentalLabel.centerYAnchor.constraint(equalTo: radarView.centerYAnchor, constant: -70),
            mentalLabel.leadingAnchor.constraint(equalTo: radarView.trailingAnchor, constant: 4),
            mentalLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -8),
            
            mentalPercentLabel.topAnchor.constraint(equalTo: mentalLabel.bottomAnchor, constant: 2),
            mentalPercentLabel.centerXAnchor.constraint(equalTo: mentalLabel.centerXAnchor),
            
            // Bottom-left (Creativity)
            creativityLabel.topAnchor.constraint(equalTo: radarView.bottomAnchor, constant: -10),
            creativityLabel.centerXAnchor.constraint(equalTo: radarView.centerXAnchor, constant: -80),
            creativityLabel.widthAnchor.constraint(equalTo: radarView.widthAnchor, multiplier: 0.4),
            
            creativityPercentLabel.topAnchor.constraint(equalTo: creativityLabel.bottomAnchor, constant: 2),
            creativityPercentLabel.centerXAnchor.constraint(equalTo: creativityLabel.centerXAnchor),
            
            // Bottom-right (Social)
            socialLabel.topAnchor.constraint(equalTo: radarView.bottomAnchor, constant: -10),
            socialLabel.centerXAnchor.constraint(equalTo: radarView.centerXAnchor, constant: 80),
            socialLabel.widthAnchor.constraint(equalTo: radarView.widthAnchor, multiplier: 0.4),
            
            socialPercentLabel.topAnchor.constraint(equalTo: socialLabel.bottomAnchor, constant: 2),
            socialPercentLabel.centerXAnchor.constraint(equalTo: socialLabel.centerXAnchor)
        ])
        
        // Stats table container
        NSLayoutConstraint.activate([
            statsTableContainer.topAnchor.constraint(equalTo: radarView.bottomAnchor, constant: 96),
            statsTableContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            statsTableContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            statsTableContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 240),
            
            statsTableStack.topAnchor.constraint(equalTo: statsTableContainer.topAnchor, constant: 16),
            statsTableStack.bottomAnchor.constraint(equalTo: statsTableContainer.bottomAnchor, constant: -16),
            statsTableStack.leadingAnchor.constraint(equalTo: statsTableContainer.leadingAnchor, constant: 16),
            statsTableStack.trailingAnchor.constraint(equalTo: statsTableContainer.trailingAnchor, constant: -16)
        ])

    }
    
    // MARK: - Update methods
    
    /// Update the small % labels around the radar.
    func updateCategoryPercentLabels(_ percents: [CGFloat]) {
        guard percents.count == 5 else { return }
        let p0 = Int(round(percents[0]))
        let p1 = Int(round(percents[1]))
        let p2 = Int(round(percents[2]))
        let p3 = Int(round(percents[3]))
        let p4 = Int(round(percents[4]))
        
        physicalPercentLabel.text = "\(p0)%"
        mentalPercentLabel.text = "\(p1)%"
        socialPercentLabel.text = "\(p2)%"
        creativityPercentLabel.text = "\(p3)%"
        miscellaneousPercentLabel.text = "\(p4)%"
    }
    
    /// Update the table below the radar with raw XP and %.
    func updateStatsTable(xpValues: [Int], percents: [CGFloat]) {
        guard xpValues.count == 5,
              percents.count == 5,
              xpValueLabels.count == 5,
              percentValueLabels.count == 5 else {
            return
        }
        
        for i in 0..<5 {
            xpValueLabels[i].text = "\(xpValues[i])"
            percentValueLabels[i].text = "\(Int(round(percents[i])))%"
        }
    }
}
