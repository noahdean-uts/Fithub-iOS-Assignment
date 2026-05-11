//
//  FitHubTheme.swift
//  FitHub
//
//  Created by Safiullah Noori on 29/4/2026.
//

import SwiftUI

//app colours and gradients
struct FitHubTheme {
    //dark background gradient
    static let background = LinearGradient(
        colors: [
            Color(red: 0.04, green: 0.05, blue: 0.08),
            Color(red: 0.08, green: 0.09, blue: 0.14)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    //glass card gradient
    static let card = LinearGradient(
        colors: [
            Color.white.opacity(0.14),
            Color.white.opacity(0.06)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    //accent colours
    static let orange = Color(red: 1.0, green: 0.38, blue: 0.12)
    static let green = Color(red: 0.25, green: 0.95, blue: 0.55)
    static let blue = Color(red: 0.25, green: 0.55, blue: 1.0)
}
