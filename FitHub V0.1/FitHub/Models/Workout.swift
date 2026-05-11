//
//  Workout.swift
//  FitHub
//
//  Created by Safiullah Noori on 23/4/2026.
//

import Foundation

//workout details
struct Workout: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var category: String
    var duration: Int
    var videoName: String
    var calories: Int
    var youtubeLink: String

    //memberwise init
    init(
        id: UUID = UUID(),
        title: String,
        category: String,
        duration: Int,
        videoName: String,
        calories: Int,
        youtubeLink: String
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.duration = duration
        self.videoName = videoName
        self.calories = calories
        self.youtubeLink = youtubeLink
    }
}
