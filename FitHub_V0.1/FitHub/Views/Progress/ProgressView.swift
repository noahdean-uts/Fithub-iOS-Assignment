//
//  ProgressView.swift
//  FitHub
//
//  Created by Safiullah Noori on 23/4/2026.
//

import SwiftUI

//build the progress screen
struct FitnessProgressView: View {
    let user: UserAccount

    @State private var allActivities: [LoggedActivity] = []
    private let runGoal: Double = 5.0
    private let workoutGoal: Double = 60.0

    //total run km including logged activities
    var totalRunKm: Double {
        user.runDistance + ActivityStorage.totalRunKm()
    }

    //total workout minutes including logged activities
    var totalWorkoutMinutes: Double {
        user.workoutDuration + Double(ActivityStorage.totalWorkoutMinutes())
    }

    //run distance towards goal
    var runProgress: Double {
        min(totalRunKm / runGoal, 1.0)
    }

    //workout time towards goal
    var workoutProgress: Double {
        min(totalWorkoutMinutes / workoutGoal, 1.0)
    }

    //average of all goal progress
    var overallProgress: Double {
        (runProgress + workoutProgress) / 2
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {

                    Text("Your Progress")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 8)

                    GlassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Overall Fitness Progress")
                                .font(.headline)
                                .foregroundColor(.white)

                            ProgressView(value: overallProgress)
                                .tint(FitHubTheme.orange)

                            Text("\(Int(overallProgress * 100))% of daily goals complete")
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Run Distance")
                                .font(.headline)
                                .foregroundColor(.white)

                            Text(String(format: "%.1f km / %.1f km", totalRunKm, runGoal))
                                .foregroundColor(.white.opacity(0.8))

                            ProgressView(value: runProgress)
                                .tint(FitHubTheme.green)
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Workout Time")
                                .font(.headline)
                                .foregroundColor(.white)

                            Text("\(Int(totalWorkoutMinutes)) min / \(Int(workoutGoal)) min")
                                .foregroundColor(.white.opacity(0.8))

                            ProgressView(value: workoutProgress)
                                .tint(FitHubTheme.blue)
                        }
                    }

                    HStack(spacing: 16) {
                        StatCard(
                            title: "Calories",
                            value: "\(Int(totalWorkoutMinutes * 8)) kcal",
                            icon: "flame.fill",
                            color: FitHubTheme.orange
                        )
                        StatCard(
                            title: "BMI",
                            value: bmiText,
                            icon: "heart.fill",
                            color: FitHubTheme.green
                        )
                    }

                    // activity history
                    if !allActivities.isEmpty {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 14) {
                                Text("Activity History")
                                    .font(.headline)
                                    .foregroundColor(.white)

                                ForEach(allActivities.reversed()) { activity in
                                    historyRow(activity)
                                }
                            }
                        }
                    }
                }
                .padding()
                .padding(.bottom, 90)
            }
        .background(FitHubTheme.background.ignoresSafeArea())
        .onAppear {
            allActivities = ActivityStorage.load()
        }
    }

    //bmi as a formatted string
    var bmiText: String {
        let heightMeters = user.height / 100
        let bmi = user.weight / (heightMeters * heightMeters)
        return String(format: "%.1f", bmi)
    }

    //display a single history row
    private func historyRow(_ activity: LoggedActivity) -> some View {
        HStack(spacing: 12) {
            Image(systemName: activity.type == .run ? "figure.run" : "dumbbell.fill")
                .foregroundColor(activity.type == .run ? FitHubTheme.blue : FitHubTheme.orange)
                .frame(width: 26)

            VStack(alignment: .leading, spacing: 2) {
                Text(activity.type == .run ? "Run" : activity.workoutCategory)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                Text(activity.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
            }

            Spacer()

            if activity.type == .run {
                Text(String(format: "%.1f km", activity.distanceKm))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(FitHubTheme.green)
            } else {
                Text("\(activity.durationMinutes) min")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(FitHubTheme.green)
            }
        }
    }
}
