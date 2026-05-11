//
//  Membership.swift
//  FitHub
//
//  Created by Safiullah Noori on 23/4/2026.
//

import Foundation

//membership plan details
struct Membership: Codable {
    var type: String
    var startDate: String
    var expiryDate: String
    var isActive: Bool
}
