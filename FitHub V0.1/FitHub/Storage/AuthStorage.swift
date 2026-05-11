//
//  AuthStorage.swift
//  FitHub
//
//  Created by Safiullah Noori on 23/4/2026.
//

import Foundation

//save and load user accounts to UserDefaults
class AuthStorage {
    private static let usersKey = "fithub_users"
    private static let loggedInUserKey = "fithub_logged_in_user"

    //load all saved users
    static func loadUsers() -> [UserAccount] {
        guard let data = UserDefaults.standard.data(forKey: usersKey) else {
            return []
        }

        do {
            return try JSONDecoder().decode([UserAccount].self, from: data)
        } catch {
            print("Failed to load users: \(error)")
            return []
        }
    }

    //save all users
    static func saveUsers(_ users: [UserAccount]) {
        do {
            let data = try JSONEncoder().encode(users)
            UserDefaults.standard.set(data, forKey: usersKey)
        } catch {
            print("Failed to save users: \(error)")
        }
    }

    //register a new user, returns false if email already exists
    static func registerUser(
        fullName: String,
        email: String,
        password: String,
        profile: UserProfile
    ) -> Bool {
        var users = loadUsers()

        if users.contains(where: { $0.email.lowercased() == email.lowercased() }) {
            return false
        }

        let newUser = UserAccount(
            fullName: fullName,
            email: email,
            password: password,
            profile: profile
        )

        users.append(newUser)
        saveUsers(users)
        return true
    }

    //validate credentials and log in
    static func loginUser(email: String, password: String) -> UserAccount? {
        let users = loadUsers()

        if let user = users.first(where: {
            $0.email.lowercased() == email.lowercased() && $0.password == password
        }) {
            saveLoggedInUser(user)
            return user
        }

        return nil
    }

    //save the active session
    static func saveLoggedInUser(_ user: UserAccount) {
        do {
            let data = try JSONEncoder().encode(user)
            UserDefaults.standard.set(data, forKey: loggedInUserKey)
        } catch {
            print("Failed to save logged in user: \(error)")
        }
    }

    //load the active session
    static func loadLoggedInUser() -> UserAccount? {
        guard let data = UserDefaults.standard.data(forKey: loggedInUserKey) else {
            return nil
        }

        do {
            return try JSONDecoder().decode(UserAccount.self, from: data)
        } catch {
            print("Failed to load logged in user: \(error)")
            return nil
        }
    }

    //clear the session on logout
    static func logoutUser() {
        UserDefaults.standard.removeObject(forKey: loggedInUserKey)
    }
}
