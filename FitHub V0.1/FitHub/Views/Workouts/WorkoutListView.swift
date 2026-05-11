//
//  WorkoutListView.swift
//  FitHub
//
//  Created by Safiullah Noori on 23/4/2026.
//

import SwiftUI

//build the workout list screen
struct WorkoutListView: View {
    @Binding var navigationPath: NavigationPath
    @State private var membershipPlan: String = FitHubStore.string(forKey: "membershipPlan", default: "Premium")

    //available workouts
    let workouts: [Workout] = [
        Workout(
            title: "Chest Blast",
            category: "Chest",
            duration: 15,
            videoName: "chest_workout",
            calories: 120,
            youtubeLink: "https://www.youtube.com/watch?v=O9K0k7fzrqU"
        ),
        Workout(
            title: "Leg Power",
            category: "Legs",
            duration: 20,
            videoName: "legs_workout",
            calories: 180,
            youtubeLink: "https://www.youtube.com/watch?v=LOvQLuIusXY"
        ),
        Workout(
            title: "Core Focus",
            category: "Abs",
            duration: 10,
            videoName: "abs_workout",
            calories: 90,
            youtubeLink: "https://www.youtube.com/watch?v=BdhqubW1GJE"
        ),
        Workout(
            title: "Back Strength",
            category: "Back",
            duration: 18,
            videoName: "back_workout",
            calories: 140,
            youtubeLink: "https://www.youtube.com/watch?v=fgTexBcnvRA"
        ),
        Workout(
            title: "Arm Builder",
            category: "Arms",
            duration: 16,
            videoName: "arms_workout",
            calories: 110,
            youtubeLink: "https://www.youtube.com/watch?v=FeLUBQ4OsX4"
        )
    ]

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Workouts")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)

                            Text("Choose a workout plan and follow the guided video.")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(.top, 20)

                        if membershipPlan == "Basic" {
                            GlassCard {
                                HStack(spacing: 14) {
                                    Image(systemName: "lock.fill")
                                        .font(.title2)
                                        .foregroundColor(FitHubTheme.orange)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Videos Locked")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Text("Upgrade to Premium or Elite to unlock workout videos.")
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.65))
                                    }
                                }
                            }
                        }

                        ForEach(workouts) { workout in
                            NavigationLink(value: workout) {
                                workoutCard(workout)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                    .padding(.bottom, 90)
                }
            .background(FitHubTheme.background.ignoresSafeArea())
            .navigationDestination(for: Workout.self) { workout in
                WorkoutDetailView(workout: workout)
            }
        }
    }

    //build a single workout card
    private func workoutCard(_ workout: Workout) -> some View {
        GlassCard {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(FitHubTheme.orange.opacity(0.18))
                        .frame(width: 54, height: 54)

                    Image(systemName: iconForCategory(workout.category))
                        .font(.title2)
                        .foregroundColor(FitHubTheme.orange)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(workout.title)
                        .font(.headline)
                        .foregroundColor(.white)

                    Text(workout.category)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))

                    Text("\(workout.duration) min • \(workout.calories) kcal")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.75))
                }

                Spacer()

                Image(systemName: membershipPlan == "Basic" ? "lock.fill" : "play.circle.fill")
                    .font(.title2)
                    .foregroundColor(membershipPlan == "Basic" ? .white.opacity(0.35) : FitHubTheme.blue)
            }
        }
    }

    //icon for each workout category
    private func iconForCategory(_ category: String) -> String {
        switch category {
        case "Chest": return "figure.strengthtraining.traditional"
        case "Legs":  return "figure.run"
        case "Abs":   return "figure.core.training"
        case "Back":  return "figure.cooldown"
        case "Arms":  return "dumbbell.fill"
        default:      return "flame.fill"
        }
    }
}

#Preview {
    WorkoutListView(navigationPath: .constant(NavigationPath()))
}
