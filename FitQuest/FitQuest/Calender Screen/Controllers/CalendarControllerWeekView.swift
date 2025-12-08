//
//  CalendarControllerWeekView.swift
//  FitQuest
//
//  Created by Student on 12/5/25.
//

import UIKit

extension CalendarScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentWeekDates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekDayCell.identifier, for: indexPath) as? WeekDayCell else {
            return UICollectionViewCell()
        }
        
        let date = currentWeekDates[indexPath.item]
        let calendar = Calendar.current
        
        // Get day name
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEE"
        let dayName = String(dayFormatter.string(from: date).prefix(1))
        
        // Get date number
        let dateNumber = calendar.component(.day, from: date)
        
        // Check if selected
        let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
        
        // Check if today
        let isToday = calendar.isDateInToday(date)
        
        // Check if past
        let isPast = date < calendar.startOfDay(for: Date())
        
        cell.configure(
            day: dayName,
            date: "\(dateNumber)",
            isSelected: isSelected,
            isToday: isToday,
            isPast: isPast
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing: CGFloat = 6 * 8
        let availableWidth = collectionView.frame.width - totalSpacing
        let width = availableWidth / 7
        return CGSize(width: width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previousDate = selectedDate
        selectedDate = currentWeekDates[indexPath.item]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "MMM dd, yyyy"
        print("📅 Date tapped: \(dateFormatter.string(from: selectedDate))")
        
        let calendar = Calendar.current
        if !calendar.isDate(previousDate, inSameDayAs: selectedDate) {
            fetchTasks(for: selectedDate)
            updateMonthYearLabel()
        }
        
        // Update week view to show new selection
        collectionView.reloadData()
    }
}
