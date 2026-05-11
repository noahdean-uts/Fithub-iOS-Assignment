//
//  PrimaryButton.swift
//  FitHub
//
//  Created by Safiullah Noori on 29/4/2026.
//

import SwiftUI

//primary action button
struct PrimaryButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.headline)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .fontWeight(.bold)
            }
            .foregroundColor(.white)
            .padding()
            .background(
                LinearGradient(
                    colors: [FitHubTheme.orange, Color.red.opacity(0.85)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(color: FitHubTheme.orange.opacity(0.35), radius: 12, x: 0, y: 8)
        }
    }
}
