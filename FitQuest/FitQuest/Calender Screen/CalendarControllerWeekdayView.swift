//
//  CalendarControllerCalenderView.swift
//  FitQuest
//
//  Created by Student on 11/18/25.
//

import UIKit

// MARK: - UICalendarSelectionSingleDateDelegate

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
        
        // Get day name (S, M, T, W, etc.)
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEE"
        let dayName = String(dayFormatter.string(from: date).prefix(1))
        
        // Get date number
        let dateNumber = calendar.component(.day, from: date)
        
        // Check if selected
        let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
        
        // Check if today
        let isToday = calendar.isDateInToday(date)
        
        cell.configure(day: dayName, date: "\(dateNumber)", isSelected: isSelected, isToday: isToday)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing: CGFloat = 6 * 8  // 6 gaps between 7 items
        let availableWidth = collectionView.frame.width - totalSpacing
        let width = availableWidth / 7
        return CGSize(width: width, height: 80)  
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDate = currentWeekDates[indexPath.item]
        collectionView.reloadData()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        // TODO: Filter tasks based on selected date
    }
}
