//
//  HomeView.swift
//  FitHub
//
//  Created by Safiullah Noori on 23/4/2026.
//

import SwiftUI

//build the home screen
struct HomeView: View {
    let user: UserAccount
    var onLogout: () -> Void

    @State private var showLogActivity = false
    @State private var todaysActivities: [LoggedActivity] = []

    //calculate bmi from user stats
    var bmi: Double {
        let h = user.height / 100
        return user.weight / (h * h)
    }

    //total active minutes logged today (runs + workouts)
    var todayWorkoutMinutes: Int {
        todaysActivities.reduce(0) { $0 + $1.durationMinutes }
    }

    //total km run today
    var todayRunKm: Double {
        todaysActivities.filter { $0.type == .run }.reduce(0) { $0 + $1.distanceKm }
    }

    //workout goal progress for today
    var workoutGoalProgress: Double {
        min(Double(todayWorkoutMinutes) / 60.0, 1.0)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Welcome back,")
                                .foregroundColor(.white.opacity(0.65))

                            Text(user.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }

                        Spacer()

                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 48))
                            .foregroundColor(FitHubTheme.orange)
                            .shadow(color: FitHubTheme.orange.opacity(0.5), radius: 12)
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 14) {
                            HStack {
                                Text("Today's Goal")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                                if todayWorkoutMinutes > 0 || todayRunKm > 0 {
                                    Text("Active today!")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(FitHubTheme.green)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(FitHubTheme.green.opacity(0.15))
                                        .clipShape(Capsule())
                                }
                            }

                            Text("Complete 60 minutes of exercise and track your daily run.")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))

                            ProgressView(value: workoutGoalProgress)
                                .tint(FitHubTheme.orange)

                            HStack {
                                Text("\(todayWorkoutMinutes) / 60 min workout")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.6))
                                Spacer()
                                if todayRunKm > 0 {
                                    Text(String(format: "%.1f km run", todayRunKm))
                                        .font(.caption)
                                        .foregroundColor(FitHubTheme.blue)
                                }
                            }
                        }
                    }

                    HStack(spacing: 14) {
                        StatCard(
                            title: "BMI",
                            value: String(format: "%.1f", bmi),
                            icon: "heart.fill",
                            color: FitHubTheme.green
                        )
                        StatCard(
                            title: "Run Today",
                            value: String(format: "%.1f km", todayRunKm),
                            icon: "figure.run",
                            color: FitHubTheme.blue
                        )
                    }

                    if !todaysActivities.isEmpty {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 14) {
                                Text("Today's Activities")
                                    .font(.headline)
                                    .foregroundColor(.white)

                                ForEach(todaysActivities) { activity in
                                    activityRow(activity)
                                }
                            }
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Fitness Summary")
                                .font(.headline)
                                .foregroundColor(.white)

                            summaryRow(icon: "flame.fill",  title: "Calories Today",  value: "\(todayWorkoutMinutes * 8) kcal")
                            summaryRow(icon: "clock.fill",  title: "Workout Today",   value: "\(todayWorkoutMinutes) min")
                            summaryRow(icon: "figure.walk", title: "Distance Today",  value: String(format: "%.1f km", todayRunKm))
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Coach Tip")
                                .font(.headline)
                                .foregroundColor(.white)

                            Text("Do not just open the app. Track your progress every day. Small consistency beats random hard training.")
                                .foregroundColor(.white.opacity(0.75))
                                .font(.subheadline)
                        }
                    }

                    Button {
                        showLogActivity = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.headline)
                            Text("Log Today's Activity")
                                .font(.headline)
                                .fontWeight(.bold)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption.weight(.bold))
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [FitHubTheme.blue, FitHubTheme.blue.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .shadow(color: FitHubTheme.blue.opacity(0.35), radius: 12, x: 0, y: 8)
                    }

                    Button(action: onLogout) {
                        HStack {
                            Image(systemName: "arrow.right.square.fill")
                            Text("Sign Out")
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.85))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .padding(.top, 4)
                }
                .padding()
                .padding(.bottom, 90)
            }
        .background(FitHubTheme.background.ignoresSafeArea())
        .onAppear {
            todaysActivities = ActivityStorage.todaysActivities()
        }
        .sheet(isPresented: $showLogActivity) {
            todaysActivities = ActivityStorage.todaysActivities()
        } content: {
            LogActivityView {
                todaysActivities = ActivityStorage.todaysActivities()
            }
        }
    }

    //display a single logged activity row
    private func activityRow(_ activity: LoggedActivity) -> some View {
        HStack(spacing: 12) {
            Image(systemName: activity.type == .run ? "figure.run" : "dumbbell.fill")
                .foregroundColor(activity.type == .run ? FitHubTheme.blue : FitHubTheme.orange)
                .frame(width: 26)

            VStack(alignment: .leading, spacing: 2) {
                Text(activity.type == .run ? "Run" : activity.workoutCategory)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                if activity.type == .run {
                    Text(String(format: "%.1f km  •  %d min", activity.distanceKm, activity.durationMinutes))
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                } else {
                    Text("\(activity.durationMinutes) min")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }
            }

            Spacer()

            Text("+\(activity.durationMinutes * 8) kcal")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(FitHubTheme.green)
        }
    }

    //display a fitness summary row
    private func summaryRow(icon: String, title: String, value: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(FitHubTheme.orange)
                .frame(width: 28)

            Text(title)
                .foregroundColor(.white.opacity(0.75))

            Spacer()

            Text(value)
                .foregroundColor(.white)
                .fontWeight(.semibold)
        }
    }
}
