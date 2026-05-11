//
//  LoginView.swift
//  FitHub
//
//  Created by Safiullah Noori on 23/4/2026.
//

import SwiftUI

//build the login screen
struct LoginView: View {
    var onLoginSuccess: (UserAccount) -> Void
    var onShowRegister: () -> Void
    
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack {
            FitHubTheme.background
                .ignoresSafeArea()
            
            VStack(spacing: 28) {
                
                Spacer()
                
                VStack(spacing: 12) {
                    Image(systemName: "figure.strengthtraining.traditional")
                        .font(.system(size: 60))
                        .foregroundColor(FitHubTheme.orange)
                        .shadow(color: FitHubTheme.orange.opacity(0.6), radius: 15)
                    
                    Text("FitHub Pro")
                        .font(.system(size: 38, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Train smarter. Track better.")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.65))
                }
                
                GlassCard {
                    VStack(spacing: 18) {
                        Text("Login")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        TextField("", text: $email, prompt: Text("Email").foregroundColor(.white.opacity(0.5)))
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .padding()
                            .background(Color.white.opacity(0.12))
                            .foregroundColor(.white)
                            .tint(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        
                        SecureField("", text: $password, prompt: Text("Password").foregroundColor(.white.opacity(0.5)))
                            .padding()
                            .background(Color.white.opacity(0.12))
                            .foregroundColor(.white)
                            .tint(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        
                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        PrimaryButton(title: "Login", icon: "arrow.right.circle.fill") {
                            login()
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                Button(action: onShowRegister) {
                    Text("Create New Account")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 26)
                        .background(Color.white.opacity(0.12))
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                }
                
                Spacer()
            }
        }
    }
    
    //validate inputs and log in
    private func login() {
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
        let trimmedPassword = password.trimmingCharacters(in: .whitespaces)

        if trimmedEmail.isEmpty {
            errorMessage = "Please enter your email."
            return
        }

        if trimmedPassword.isEmpty {
            errorMessage = "Please enter your password."
            return
        }

        if let user = AuthStorage.loginUser(email: trimmedEmail, password: trimmedPassword) {
            onLoginSuccess(user)
        } else {
            errorMessage = "Incorrect email or password."
        }
    }
}
