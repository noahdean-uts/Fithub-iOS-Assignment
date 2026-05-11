//
//  MembershipView.swift
//  FitHub
//
//  Created by Safiullah Noori on 23/4/2026.
//

import SwiftUI

//build the membership screen
struct MembershipView: View {
    @State private var membershipPlan: String = FitHubStore.string(forKey: "membershipPlan", default: "Premium")

    private var accessDescription: String {
        switch membershipPlan {
        case "Basic":   return "Gym Access Only"
        case "Premium": return "Gym + Workout Videos"
        case "Elite":   return "Gym + Videos + Personal Coaching"
        default:        return "Gym Access Only"
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Membership")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text("Choose the plan that matches your fitness goal.")
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.top, 20)

                    GlassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: planIcon(membershipPlan))
                                    .font(.title)
                                    .foregroundColor(planColor(membershipPlan))

                                VStack(alignment: .leading) {
                                    Text("Current Plan")
                                        .foregroundColor(.white.opacity(0.7))

                                    Text(membershipPlan)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }

                                Spacer()

                                Text("ACTIVE")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(FitHubTheme.green)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 10)
                                    .background(FitHubTheme.green.opacity(0.18))
                                    .clipShape(Capsule())
                            }

                            Divider()
                                .background(Color.white.opacity(0.25))

                            membershipRow(title: "Start Date",  value: "01 Apr 2026")
                            membershipRow(title: "Expiry Date", value: "01 Jul 2026")
                            membershipRow(title: "Access",      value: accessDescription)
                        }
                    }

                    Text("Available Plans")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    planCard(
                        name: "Basic",
                        price: "$29/month",
                        description: "Gym access and basic workout tracking.",
                        icon: "figure.walk"
                    )

                    planCard(
                        name: "Premium",
                        price: "$49/month",
                        description: "Gym access, workout videos, progress tracking.",
                        icon: "flame.fill"
                    )

                    planCard(
                        name: "Elite",
                        price: "$79/month",
                        description: "All features plus dedicated personal coaching.",
                        icon: "star.fill"
                    )

                    //elite coaching section
                    if membershipPlan == "Elite" {
                        eliteCoachingCard
                    }

                    PrimaryButton(title: "Manage Subscription", icon: "arrow.clockwise.circle.fill") {}
                }
                .padding()
                .padding(.bottom, 90)
            }
        .background(FitHubTheme.background.ignoresSafeArea())
    }

    //coaching card shown for elite members
    private var eliteCoachingCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 18) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(FitHubTheme.orange.opacity(0.18))
                            .frame(width: 50, height: 50)
                        Image(systemName: "person.crop.circle.badge.checkmark")
                            .font(.title2)
                            .foregroundColor(FitHubTheme.orange)
                    }
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Personal Coaching")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("Elite Member Benefit")
                            .font(.caption)
                            .foregroundColor(FitHubTheme.orange)
                    }
                }

                Divider()
                    .background(Color.white.opacity(0.2))

                coachRow(icon: "person.fill",      label: "Your Coach",   value: "Alex Thompson")
                coachRow(icon: "phone.fill",        label: "Contact",      value: "+1 800 FIT-HUB")
                coachRow(icon: "envelope.fill",     label: "Email",        value: "coach@fithub.app")
                coachRow(icon: "calendar",          label: "Sessions",     value: "3 × 45 min / week")
                coachRow(icon: "clock.fill",        label: "Next Session", value: "Mon, 12 May – 9:00 AM")

                Divider()
                    .background(Color.white.opacity(0.2))

                Button {
                    if let url = URL(string: "mailto:coach@fithub.app") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    HStack {
                        Image(systemName: "message.fill")
                        Text("Message Your Coach")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(FitHubTheme.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }

    //membership detail row
    private func membershipRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.white.opacity(0.65))
            Spacer()
            Text(value)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
    }

    //coaching detail row
    private func coachRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(FitHubTheme.orange)
                .frame(width: 22)
            Text(label)
                .foregroundColor(.white.opacity(0.65))
            Spacer()
            Text(value)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
    }

    //plan selection card
    private func planCard(name: String, price: String, description: String, icon: String) -> some View {
        Button {
            membershipPlan = name
            FitHubStore.set(name, forKey: "membershipPlan")
        } label: {
            GlassCard {
                HStack(spacing: 16) {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(planColor(name))
                        .frame(width: 42, height: 42)
                        .background(planColor(name).opacity(0.16))
                        .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 6) {
                        Text(name)
                            .font(.headline)
                            .foregroundColor(.white)

                        Text(description)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.65))
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 6) {
                        Text(price)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        if membershipPlan == name {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(FitHubTheme.green)
                        }
                    }
                }
            }
        }
    }

    //icon for each plan
    private func planIcon(_ plan: String) -> String {
        switch plan {
        case "Basic":   return "figure.walk"
        case "Premium": return "flame.fill"
        case "Elite":   return "star.fill"
        default:        return "crown.fill"
        }
    }

    //colour for each plan
    private func planColor(_ plan: String) -> Color {
        switch plan {
        case "Basic":   return FitHubTheme.blue
        case "Premium": return FitHubTheme.orange
        case "Elite":   return Color(red: 0.9, green: 0.75, blue: 0.2)
        default:        return FitHubTheme.orange
        }
    }
}
