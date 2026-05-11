//
//  LogActivityView.swift
//  FitHub
//
//  Created by Safiullah Noori on 23/4/2026.
//

import SwiftUI

//build the log activity sheet
struct LogActivityView: View {
    @Environment(\.dismiss) private var dismiss
    var onSaved: () -> Void

    @State private var selectedType: ActivityType = .run
    @State private var distanceText: String = ""
    @State private var durationText: String = ""
    @State private var selectedCategory: String = LoggedActivity.workoutCategories[0]
    @State private var showCategoryPicker: Bool = false
    @State private var errorMessage: String = ""
    @State private var saved: Bool = false

    var body: some View {
        ZStack {
            FitHubTheme.background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Log Today's Activity")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Record what you completed to update your progress.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.65))
                    }
                    .padding(.top, 8)

                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Activity Type")
                                .font(.headline)
                                .foregroundColor(.white)

                            HStack(spacing: 12) {
                                typeButton(label: "Run", icon: "figure.run", type: .run)
                                typeButton(label: "Workout", icon: "dumbbell.fill", type: .workout)
                            }
                        }
                    }

                    if selectedType == .run {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Image(systemName: "figure.run")
                                        .foregroundColor(FitHubTheme.orange)
                                    Text("Run Details")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }

                                inputRow(
                                    icon: "location.fill",
                                    label: "Distance",
                                    placeholder: "km",
                                    text: $distanceText,
                                    keyboard: .decimalPad
                                )

                                inputRow(
                                    icon: "clock.fill",
                                    label: "Duration",
                                    placeholder: "minutes",
                                    text: $durationText,
                                    keyboard: .numberPad
                                )
                            }
                        }
                    }

                    if selectedType == .workout {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Image(systemName: "dumbbell.fill")
                                        .foregroundColor(FitHubTheme.orange)
                                    Text("Workout Details")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }

                                VStack(alignment: .leading, spacing: 7) {
                                    Text("Workout Type")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white.opacity(0.8))

                                    Button {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            showCategoryPicker.toggle()
                                        }
                                    } label: {
                                        HStack {
                                            Image(systemName: "list.bullet")
                                                .foregroundColor(FitHubTheme.orange)
                                                .frame(width: 22)
                                            Text(selectedCategory)
                                                .foregroundColor(.white)
                                                .fontWeight(.medium)
                                            Spacer()
                                            Image(systemName: showCategoryPicker ? "chevron.up" : "chevron.down")
                                                .font(.caption.weight(.semibold))
                                                .foregroundColor(FitHubTheme.orange)
                                        }
                                        .padding()
                                        .background(Color.white.opacity(0.18))
                                        .clipShape(RoundedRectangle(cornerRadius: 14))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14)
                                                .stroke(
                                                    showCategoryPicker
                                                        ? FitHubTheme.orange.opacity(0.6)
                                                        : Color.white.opacity(0.35),
                                                    lineWidth: 1
                                                )
                                        )
                                    }

                                    if showCategoryPicker {
                                        VStack(spacing: 2) {
                                            ForEach(LoggedActivity.workoutCategories, id: \.self) { cat in
                                                Button {
                                                    selectedCategory = cat
                                                    withAnimation(.easeInOut(duration: 0.2)) {
                                                        showCategoryPicker = false
                                                    }
                                                } label: {
                                                    HStack {
                                                        Text(cat)
                                                            .foregroundColor(.white)
                                                            .fontWeight(selectedCategory == cat ? .semibold : .regular)
                                                        Spacer()
                                                        if selectedCategory == cat {
                                                            Image(systemName: "checkmark")
                                                                .font(.caption.weight(.bold))
                                                                .foregroundColor(FitHubTheme.orange)
                                                        }
                                                    }
                                                    .padding(.horizontal, 16)
                                                    .padding(.vertical, 11)
                                                    .background(
                                                        selectedCategory == cat
                                                            ? FitHubTheme.orange.opacity(0.18)
                                                            : Color.white.opacity(0.07)
                                                    )
                                                }
                                            }
                                        }
                                        .clipShape(RoundedRectangle(cornerRadius: 14))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14)
                                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                        )
                                        .transition(.opacity.combined(with: .scale(scale: 0.97, anchor: .top)))
                                    }
                                }

                                inputRow(
                                    icon: "clock.fill",
                                    label: "Duration",
                                    placeholder: "minutes",
                                    text: $durationText,
                                    keyboard: .numberPad
                                )
                            }
                        }
                    }

                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal, 4)
                    }

                    PrimaryButton(title: "Save Activity", icon: "checkmark.circle.fill") {
                        saveActivity()
                    }

                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.6))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                    }
                }
                .padding()
            }

            if saved {
                savedOverlay
            }
        }
    }

    //full-screen success confirmation overlay
    private var savedOverlay: some View {
        ZStack {
            Color.black.opacity(0.72)
                .ignoresSafeArea(.all)
                .transition(.opacity)

            VStack(spacing: 22) {
                ZStack {
                    Circle()
                        .fill(FitHubTheme.green.opacity(0.18))
                        .frame(width: 90, height: 90)
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 56))
                        .foregroundColor(FitHubTheme.green)
                }

                VStack(spacing: 10) {
                    Text("Activity Saved!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("Your activity has been added\nto your progress.")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }

                Button {
                    dismiss()
                } label: {
                    Text("Done")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(FitHubTheme.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.top, 4)
            }
            .padding(32)
            .background(
                Color(red: 0.08, green: 0.09, blue: 0.14)
                    .clipShape(RoundedRectangle(cornerRadius: 28))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 28)
                    .stroke(FitHubTheme.green.opacity(0.35), lineWidth: 1)
            )
            .padding(.horizontal, 32)
            .shadow(color: .black.opacity(0.5), radius: 30, x: 0, y: 16)
        }
        .animation(.easeInOut(duration: 0.25), value: saved)
    }

    //type selector button
    private func typeButton(label: String, icon: String, type: ActivityType) -> some View {
        Button {
            selectedType = type
            distanceText = ""
            durationText = ""
            errorMessage = ""
            showCategoryPicker = false
        } label: {
            HStack(spacing: 8) {
                Image(systemName: icon)
                Text(label)
                    .fontWeight(.semibold)
            }
            .foregroundColor(selectedType == type ? .white : .white.opacity(0.45))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                selectedType == type
                    ? FitHubTheme.orange
                    : Color.white.opacity(0.1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }

    //labelled text input row
    private func inputRow(
        icon: String,
        label: String,
        placeholder: String,
        text: Binding<String>,
        keyboard: UIKeyboardType
    ) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(label)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.8))

            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundColor(FitHubTheme.orange)
                    .frame(width: 22)

                TextField(
                    "",
                    text: text,
                    prompt: Text(placeholder).foregroundColor(.white.opacity(0.5))
                )
                .foregroundColor(.white)
                .tint(.white)
                .keyboardType(keyboard)
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

    //validate and save the activity
    private func saveActivity() {
        errorMessage = ""

        guard let duration = Int(durationText), duration > 0 else {
            errorMessage = "Please enter a valid duration in minutes."
            return
        }

        if selectedType == .run {
            guard let distance = Double(distanceText), distance > 0 else {
                errorMessage = "Please enter a valid run distance in km."
                return
            }
            ActivityStorage.add(LoggedActivity(
                type: .run,
                distanceKm: distance,
                durationMinutes: duration
            ))
        } else {
            ActivityStorage.add(LoggedActivity(
                type: .workout,
                workoutCategory: selectedCategory,
                durationMinutes: duration
            ))
        }

        onSaved()
        saved = true
    }
}

#Preview {
    LogActivityView(onSaved: {})
}
