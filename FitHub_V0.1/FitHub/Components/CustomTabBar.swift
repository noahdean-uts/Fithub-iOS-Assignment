//
//  CustomTabBar.swift
//  FitHub
//
//  Created by Safiullah Noori on 23/4/2026.
//

import SwiftUI

//tab identifiers
enum AppTab: Int, CaseIterable {
    case home       = 0
    case membership = 1
    case workouts   = 2
    case progress   = 3

    //display label for the tab
    var label: String {
        switch self {
        case .home:       return "Home"
        case .membership: return "Membership"
        case .workouts:   return "Workouts"
        case .progress:   return "Progress"
        }
    }

    //system icon name for the tab
    var icon: String {
        switch self {
        case .home:       return "house.fill"
        case .membership: return "person.text.rectangle"
        case .workouts:   return "play.rectangle.fill"
        case .progress:   return "chart.line.uptrend.xyaxis"
        }
    }
}

//custom tab bar
struct CustomTabBar: View {
    let selectedTab: AppTab
    let onTabSelected: (AppTab) -> Void

    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                Button {
                    onTabSelected(tab)
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 20, weight: .medium))
                        Text(tab.label)
                            .font(.system(size: 10, weight: .medium))
                    }
                    .foregroundColor(
                        selectedTab == tab
                            ? FitHubTheme.orange
                            : .white.opacity(0.45)
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.top, 12)
                    .padding(.bottom, 4)
                }
            }
        }
        .padding(.bottom, 24)
        .background(
            Color(red: 0.06, green: 0.07, blue: 0.11)
                .ignoresSafeArea(edges: .bottom)
        )
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(.white.opacity(0.15)),
            alignment: .top
        )
    }
}
