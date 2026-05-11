//
//  ContentView.swift
//  FitHub
//
//  Created by Safiullah Noori on 23/4/2026.
//

import SwiftUI

//app screen states
enum AppScreen {
    case login
    case register
    case mainApp
}

//build the root view
struct ContentView: View {
    @State private var currentUser: UserAccount? = AuthStorage.loadLoggedInUser()
    @State private var currentScreen: AppScreen = .login
    @State private var selectedTab: AppTab = .home
    @State private var workoutsPath = NavigationPath()

    var body: some View {
        Group {
            if let user = currentUser {
                tabContent(for: user)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .safeAreaInset(edge: .bottom, spacing: 0) {
                        CustomTabBar(selectedTab: selectedTab) { tappedTab in
                            if tappedTab == .workouts {
                                workoutsPath = NavigationPath()
                            }
                            selectedTab = tappedTab
                        }
                    }
            } else {
                switch currentScreen {
                case .login:
                    LoginView(
                        onLoginSuccess: { user in
                            currentUser = user
                            currentScreen = .mainApp
                        },
                        onShowRegister: {
                            currentScreen = .register
                        }
                    )

                case .register:
                    RegisterView(
                        onRegisterSuccess: { user in
                            currentUser = user
                            currentScreen = .mainApp
                        },
                        onShowLogin: {
                            currentScreen = .login
                        }
                    )

                case .mainApp:
                    EmptyView()
                }
            }
        }
        .onAppear {
            if currentUser != nil {
                currentScreen = .mainApp
            }
        }
    }

    //switch between tab screens
    @ViewBuilder
    private func tabContent(for user: UserAccount) -> some View {
        switch selectedTab {
        case .home:
            HomeView(
                user: user,
                onLogout: {
                    AuthStorage.logoutUser()
                    currentUser = nil
                    currentScreen = .login
                    selectedTab = .home
                }
            )
        case .membership:
            MembershipView()
        case .workouts:
            WorkoutListView(navigationPath: $workoutsPath)
        case .progress:
            FitnessProgressView(user: user)
        }
    }
}

#Preview {
    ContentView()
}
