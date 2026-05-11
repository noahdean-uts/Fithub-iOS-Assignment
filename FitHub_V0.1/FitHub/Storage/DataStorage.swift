//
//  DataStorage.swift
//  FitHub
//
//  Created by Safiullah Noori on 23/4/2026.
//

import Foundation

//save and load user data to UserDefaults
class DataStorage {
    private static let userProfileKey = "user_profile"
    private static let membershipKey = "membership_info"

    //save the user profile
    static func saveUserProfile(_ profile: UserProfile) {
        do {
            let data = try JSONEncoder().encode(profile)
            UserDefaults.standard.set(data, forKey: userProfileKey)
        } catch {
            print("Failed to save user profile: \(error)")
        }
    }

    //load the user profile
    static func loadUserProfile() -> UserProfile? {
        guard let data = UserDefaults.standard.data(forKey: userProfileKey) else {
            return nil
        }

        do {
            return try JSONDecoder().decode(UserProfile.self, from: data)
        } catch {
            print("Failed to load user profile: \(error)")
            return nil
        }
    }

    //save the membership
    static func saveMembership(_ membership: Membership) {
        do {
            let data = try JSONEncoder().encode(membership)
            UserDefaults.standard.set(data, forKey: membershipKey)
        } catch {
            print("Failed to save membership: \(error)")
        }
    }

    //load the membership
    static func loadMembership() -> Membership? {
        guard let data = UserDefaults.standard.data(forKey: membershipKey) else {
            return nil
        }

        do {
            return try JSONDecoder().decode(Membership.self, from: data)
        } catch {
            print("Failed to load membership: \(error)")
            return nil
        }
    }
}
