# FitQuest (formerly DayTrack)

A gamified personal productivity app that helps users build better habits through task management, XP rewards, and progress tracking.

## Overview

FitQuest transforms daily wellness and productivity tasks into an engaging game-like experience. Users earn XP for completing tasks, level up, and compete on leaderboards while building healthy habits across multiple life categories.

**Target Users:** Students, Young Professionals, Anyone seeking self-improvement

## Features

### Task Management
- Week-by-week task scheduling with calendar view
- Date selection and navigation with month/year picker
- Real-time Firebase sync
- Pull-to-refresh functionality
- Floating "+" button for quick task creation
- Swipe left to delete tasks
- Task states: Completed (green), Overdue (red), Pending

### Five Task Categories
1. **Physical** - Exercise, workouts, gym sessions, running, yoga
2. **Mental** - Meditation, reading, learning activities
3. **Social** - Connect with friends, family activities, coffee meetups
4. **Creative** - Music practice, drawing/painting, creative writing
5. **Miscellaneous** - Meal prep, budget review, organizing

### Task Creation Flow
1. Tap the "+" button on Calendar screen
2. Select category from bottom sheet
3. Choose task type (predefined templates or custom)
4. Fill details: Title, Duration, Difficulty, Due Date/Time, Notes
5. Create Task

### XP & Gamification System
- **Difficulty-based XP rewards** - Harder tasks earn more XP
- **Duration multiplier** - Longer tasks provide bonus XP
- **Level progression** - Accumulate XP to level up
- **Tier system** - Advance through achievement tiers
- **5-minute undo window** - Unmark accidentally completed tasks within 5 minutes

### Task Completion
- Tap checkbox to mark complete
- Green toast notification showing "+XP" earned
- Visual state change (green highlight)
- Stats automatically updated in real-time
- Undo within 5 minutes (XP deducted, stats reversed)

### Statistics Dashboard
- **Radar Chart** - 5-category XP distribution visualization
- **Category Breakdown** - XP earned per category with percentages
- **Progress Tracking** - Overall stats and category-specific totals
- Custom-drawn radar visualization with real-time Firebase data

### Task History
- Date-grouped task list
- Shows completed and missed tasks
- Category filtering
- Infinite scroll pagination
- Task detail view on tap
- Visual indicators: Completed (green), Missed (red)

### Leaderboard
- Real-time data of all users
- Podium display for top 3 performers
- Ranked list of all users by XP
- Current user's position highlighted

### Notifications System
- Task reminders
- Overdue task alerts
- Mark as read/unread
- Swipe to dismiss
- Badge indicator with unread count
- Real-time updates

### Home Dashboard
- Quick access navigation cards (Calendar, Task History, Stats, Leaderboard)
- Today's due tasks list with search functionality
- Notification center access
- Profile access

## Tech Stack

| Component | Technology |
|-----------|------------|
| Platform | iOS |
| Language | Swift |
| UI Framework | UIKit |
| Backend | Firebase |
| Database | Cloud Firestore |
| Authentication | Firebase Auth |
| Storage | Firebase Storage |

## Setup Instructions

### Prerequisites
- Xcode 15.0 or later
- iOS 17.0+ deployment target
- Swift Package Manager
- Firebase account

### Firebase Configuration

1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com)

2. Add an iOS app to your Firebase project:
   - Register with your bundle identifier
   - Download `GoogleService-Info.plist`
   - Add the plist file to your Xcode project root

3. Enable Firebase services:
   - **Authentication**: Enable Email/Password sign-in
   - **Cloud Firestore**: Create database
   - **Storage**: Set up for profile image uploads (AI-generated avatars)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd FitQuest
```

2. Open the project in Xcode:
```bash
open FitQuest.xcodeproj
```

3. Install dependencies via Swift Package Manager:
   - File → Add Package Dependencies
   - Add Firebase iOS SDK: `https://github.com/firebase/firebase-ios-sdk`
   - Select: FirebaseAuth, FirebaseFirestore, FirebaseStorage

4. Add your `GoogleService-Info.plist` to the project

5. Build and run on simulator or device

## Authentication Flow

1. **Landing Page** - App logo with Sign Up / Login options
2. **Sign Up** - Name, Email, Password, Date of Birth, Profile Picture
3. **Login** - Email/Password with "Forgot Password?" option
4. **Home Dashboard** - Main app interface after authentication

## Key Behaviors

### Task Completion Rules
- Completing a task awards XP immediately
- Completed tasks cannot be deleted (preserves XP history and integrity)
- Tasks can only be unmarked within 5 minutes of completion
- Unmarking reverses XP gain and updates stats

### Network Handling
- Real-time connectivity monitoring
- Offline banner displayed when connection is lost
- Network-dependent actions blocked when offline
- Graceful error handling with user feedback

### Data Sync
- Real-time Firebase synchronization
- Pull-to-refresh on calendar and lists
- Automatic stats updates on task completion

## Screenshots

The app features a dark theme with cyan/teal accent colors throughout:
- Calendar view with week navigation
- Task cells showing category icon, title, duration, XP value, and completion checkbox
- Bottom sheet for category selection during task creation
- Radar chart for visualizing category balance
- Podium-style leaderboard display

---

**FitQuest** - Level up your life, one task at a time!
