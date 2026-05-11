//
//  WorkoutDetailView.swift
//  FitHub
//
//  Created by Safiullah Noori on 23/4/2026.
//

import SwiftUI

//build the workout detail screen
struct WorkoutDetailView: View {
    let workout: Workout
    @Environment(\.dismiss) private var dismiss
    @State private var membershipPlan: String = FitHubStore.string(forKey: "membershipPlan", default: "Premium")
    @State private var videoFailed = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(workout.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(workout.category)
                            .font(.headline)
                            .foregroundColor(FitHubTheme.orange)
                    }
                    .padding(.top, 20)
                    
                    GlassCard {
                        VStack(alignment: .leading, spacing: 14) {
                            HStack {
                                Image(systemName: "play.rectangle.fill")
                                    .foregroundColor(FitHubTheme.orange)
                                
                                Text("Workout Video")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            
                            if membershipPlan == "Basic" {
                                lockedVideoView
                            } else if videoFailed {
                                Button {
                                    if let url = URL(string: workout.youtubeLink) {
                                        UIApplication.shared.open(url)
                                    }
                                } label: {
                                    VStack(spacing: 12) {
                                        Image(systemName: "play.circle.fill")
                                            .font(.system(size: 48))
                                            .foregroundColor(FitHubTheme.orange)
                                        Text("Watch on YouTube")
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                        Text("Tap to open in YouTube")
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.55))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 220)
                                    .background(Color.black.opacity(0.35))
                                    .clipShape(RoundedRectangle(cornerRadius: 18))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 18)
                                            .stroke(FitHubTheme.orange.opacity(0.4), lineWidth: 1)
                                    )
                                }
                            } else {
                                YouTubePlayerView(videoURL: workout.youtubeLink,
                                                  playerFailed: $videoFailed)
                                    .frame(height: 220)
                                    .clipShape(RoundedRectangle(cornerRadius: 18))
                            }
                        }
                    }
                    
                    HStack(spacing: 14) {
                        StatCard(
                            title: "Duration",
                            value: "\(workout.duration) min",
                            icon: "clock.fill",
                            color: FitHubTheme.blue
                        )
                        
                        StatCard(
                            title: "Calories",
                            value: "\(workout.calories)",
                            icon: "flame.fill",
                            color: FitHubTheme.orange
                        )
                    }
                    
                    GlassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Workout Details")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            detailRow(icon: "tag.fill", title: "Category", value: workout.category)
                            detailRow(icon: "clock.fill", title: "Duration", value: "\(workout.duration) minutes")
                            detailRow(icon: "flame.fill", title: "Calories Burn", value: "\(workout.calories) kcal")
                        }
                    }
                    
                    GlassCard {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Instructions")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            instruction("Warm up for 5 minutes before starting.")
                            instruction("Focus on correct form, not just heavy weight.")
                            instruction("Take short rests between sets.")
                            instruction("Stay hydrated during the workout.")
                        }
                    }
                }
                .padding()
                .padding(.bottom, 90)
            }
        .background(FitHubTheme.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Back")
                            .font(.subheadline.weight(.semibold))
                    }
                    .foregroundColor(FitHubTheme.orange)
                }
            }
        }
        .toolbarBackground(Color(red: 0.06, green: 0.07, blue: 0.11), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }

    //locked video placeholder for basic members
    private var lockedVideoView: some View {
        VStack(spacing: 14) {
            Image(systemName: "lock.fill")
                .font(.system(size: 40))
                .foregroundColor(FitHubTheme.orange)
            Text("Video Locked")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            Text("Upgrade to Premium or Elite to access workout videos.")
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 220)
        .background(Color.black.opacity(0.35))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(FitHubTheme.orange.opacity(0.35), lineWidth: 1)
        )
    }
    
    //display a workout detail row
    private func detailRow(icon: String, title: String, value: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(FitHubTheme.orange)
                .frame(width: 26)
            
            Text(title)
                .foregroundColor(.white.opacity(0.7))
            
            Spacer()
            
            Text(value)
                .foregroundColor(.white)
                .fontWeight(.semibold)
        }
    }
    
    //display an instruction row
    private func instruction(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(FitHubTheme.green)
            
            Text(text)
                .foregroundColor(.white.opacity(0.8))
        }
    }
}

#Preview {
    WorkoutDetailView(
        workout: Workout(
            title: "Chest Blast",
            category: "Chest",
            duration: 15,
            videoName: "chest_workout",
            calories: 120,
            youtubeLink: "https://youtu.be/O9K0k7fzrqU?si=2oEJtsGtg3--42Gj"
        )
    )
}
