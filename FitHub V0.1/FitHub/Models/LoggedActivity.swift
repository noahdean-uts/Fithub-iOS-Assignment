//
//  LoggedActivity.swift
//  FitHub
//
//  Created by Safiullah Noori on 23/4/2026.
//

import Foundation

//activity types
enum ActivityType: String, Codable, CaseIterable {
    case run
    case workout
}

//a single completed activity
struct LoggedActivity: Identifiable, Codable {
    var id: UUID = UUID()
    var type: ActivityType
    var workoutCategory: String
    var distanceKm: Double
    var durationMinutes: Int
    var date: Date

    static let workoutCategories = [
        "Chest", "Back", "Legs", "Arms",
        "Abs / Core", "Cardio", "Shoulders",
        "Full Body", "Yoga / Stretch"
    ]

    init(
        type: ActivityType,
        workoutCategory: String = "",
        distanceKm: Double = 0,
        durationMinutes: Int,
        date: Date = Date()
    ) {
        self.type = type
        self.workoutCategory = workoutCategory
        self.distanceKm = distanceKm
        self.durationMinutes = durationMinutes
        self.date = date
    }
}
