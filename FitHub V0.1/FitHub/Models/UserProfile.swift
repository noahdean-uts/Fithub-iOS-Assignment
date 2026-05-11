//
//  UserProfile.swift
//  FitHub
//
//  Created by Safiullah Noori on 23/4/2026.
//

import Foundation

//user fitness profile data
struct UserProfile: Codable {
    var heightCm: Double
    var weightKg: Double
    var runDistanceKm: Double
    var workoutMinutes: Int
}
