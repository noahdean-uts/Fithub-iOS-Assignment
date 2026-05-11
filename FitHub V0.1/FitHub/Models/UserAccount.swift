//
//  UserAccount.swift
//  FitHub
//
//  Created by Safiullah Noori on 23/4/2026.
//

import Foundation

//create a user account
struct UserAccount: Identifiable, Codable {
    var id: UUID
    var fullName: String
    var email: String
    var password: String
    var profile: UserProfile
    
    //shortcut for display name
    var name: String {
        fullName
    }

    //profile shortcuts
    var height: Double {
        profile.heightCm
    }
    
    var weight: Double {
        profile.weightKg
    }
    
    var runDistance: Double {
        profile.runDistanceKm
    }
    
    var workoutDuration: Double {
        Double(profile.workoutMinutes)
    }

    init(
        id: UUID = UUID(),
        fullName: String,
        email: String,
        password: String,
        profile: UserProfile
    ) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.password = password
        self.profile = profile
    }
    
    init(
        id: UUID = UUID(),
        name: String,
        email: String,
        password: String,
        height: Double,
        weight: Double,
        runDistance: Double,
        workoutDuration: Double
    ) {
        self.id = id
        self.fullName = name
        self.email = email
        self.password = password
        self.profile = UserProfile(
            heightCm: height,
            weightKg: weight,
            runDistanceKm: runDistance,
            workoutMinutes: Int(workoutDuration)
        )
    }
}
