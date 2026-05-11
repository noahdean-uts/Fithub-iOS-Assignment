//
//  RegisterView.swift
//  FitHub
//
//  Created by Safiullah Noori on 23/4/2026.
//

import SwiftUI

//build the registration screen
struct RegisterView: View {
    var onRegisterSuccess: (UserAccount) -> Void
    var onShowLogin: () -> Void
    
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var height = ""
    @State private var weight = ""
    @State private var runDistance = ""
    @State private var workoutDuration = ""
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack {
            FitHubTheme.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 22) {
                    
                    VStack(spacing: 10) {
                        Image(systemName: "figure.strengthtraining.traditional")
                            .font(.system(size: 58))
                            .foregroundColor(FitHubTheme.orange)
                            .shadow(color: FitHubTheme.orange.opacity(0.7), radius: 18)
                        
                        Text("Create Account")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Build your fitness profile and start tracking your progress.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.75))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top, 26)
                    
                    GlassCard {
                        VStack(spacing: 16) {
                            
                            inputField("Full Name", placeholder: "Enter your full name", text: $fullName, icon: "person.fill")
                            inputField("Email", placeholder: "Enter your email address", text: $email, icon: "envelope.fill")
                            
                            secureInput("Password", placeholder: "Enter your password", text: $password)
                            secureInput("Confirm Password", placeholder: "Re-enter your password", text: $confirmPassword)
                            
                            HStack(spacing: 12) {
                                inputField("Height", placeholder: "cm", text: $height, icon: "ruler.fill")
                                    .keyboardType(.decimalPad)
                                
                                inputField("Weight", placeholder: "kg", text: $weight, icon: "scalemass.fill")
                                    .keyboardType(.decimalPad)
                            }
                            
                            HStack(spacing: 12) {
                                inputField("Run Distance", placeholder: "km", text: $runDistance, icon: "figure.run")
                                    .keyboardType(.decimalPad)
                                
                                inputField("Workout Time", placeholder: "minutes", text: $workoutDuration, icon: "clock.fill")
                                    .keyboardType(.numberPad)
                            }
                            
                            if !errorMessage.isEmpty {
                                Text(errorMessage)
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            PrimaryButton(title: "Register", icon: "person.badge.plus.fill") {
                                register()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Button(action: onShowLogin) {
                        Text("Already have an account? Login")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.vertical, 14)
                            .padding(.horizontal, 24)
                            .background(Color.white.opacity(0.16))
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
                            )
                    }
                    
                    Spacer(minLength: 30)
                }
            }
        }
    }
    
    //styled text input field with icon
    private func inputField(
        _ title: String,
        placeholder: String,
        text: Binding<String>,
        icon: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.82))
            
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundColor(FitHubTheme.orange)
                    .frame(width: 22)
                
                TextField("", text: text, prompt: Text(placeholder).foregroundColor(.white.opacity(0.5)))
                    .foregroundColor(.white)
                    .tint(.white)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
            .padding()
            .background(Color.white.opacity(0.18))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.white.opacity(0.35), lineWidth: 1)
            )
        }
    }
    
    //styled secure password field
    private func secureInput(
        _ title: String,
        placeholder: String,
        text: Binding<String>
    ) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.82))
            
            SecureField("", text: text, prompt: Text(placeholder).foregroundColor(.white.opacity(0.5)))
                .foregroundColor(.white)
                .tint(.white)
                .padding()
                .background(Color.white.opacity(0.18))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.white.opacity(0.35), lineWidth: 1)
                )
        }
    }
    
    //validate inputs and register the user
    private func register() {
        let trimmedName = fullName.trimmingCharacters(in: .whitespaces)
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)

        guard !trimmedName.isEmpty else {
            errorMessage = "Please enter your full name."
            return
        }

        guard trimmedEmail.contains("@") else {
            errorMessage = "Please enter a valid email address."
            return
        }

        guard password.count >= 4 else {
            errorMessage = "Password must be at least 4 characters."
            return
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }

        let profile = UserProfile(
            heightCm: Double(height) ?? 170,
            weightKg: Double(weight) ?? 70,
            runDistanceKm: Double(runDistance) ?? 0,
            workoutMinutes: Int(workoutDuration) ?? 0
        )

        let registered = AuthStorage.registerUser(
            fullName: trimmedName,
            email: trimmedEmail,
            password: password,
            profile: profile
        )

        guard registered else {
            errorMessage = "An account with this email already exists."
            return
        }

        if let user = AuthStorage.loginUser(email: trimmedEmail, password: password) {
            onRegisterSuccess(user)
        }
    }
}
