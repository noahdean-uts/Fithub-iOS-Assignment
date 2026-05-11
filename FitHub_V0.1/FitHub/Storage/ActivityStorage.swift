//
//  ActivityStorage.swift
//  FitHub
//
//  Created by Safiullah Noori on 23/4/2026.
//

import Foundation

//save and load logged activities to a JSON file in Documents
class ActivityStorage {

    //path to the activities file
    private static var fileURL: URL {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("fithub_activities.json")
    }

    //load all logged activities
    static func load() -> [LoggedActivity] {
        guard let data = try? Data(contentsOf: fileURL) else { return [] }
        return (try? JSONDecoder().decode([LoggedActivity].self, from: data)) ?? []
    }

    //save all activities to disk immediately
    static func save(_ activities: [LoggedActivity]) {
        guard let data = try? JSONEncoder().encode(activities) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    //append a new activity and save
    static func add(_ activity: LoggedActivity) {
        var activities = load()
        activities.append(activity)
        save(activities)
    }

    //activities logged today
    static func todaysActivities() -> [LoggedActivity] {
        load().filter { Calendar.current.isDateInToday($0.date) }
    }

    //total active minutes from today (runs + workouts)
    static func todayWorkoutMinutes() -> Int {
        todaysActivities().reduce(0) { $0 + $1.durationMinutes }
    }

    //total run km from today
    static func todayRunKm() -> Double {
        todaysActivities()
            .filter { $0.type == .run }
            .reduce(0) { $0 + $1.distanceKm }
    }

    //total active minutes across all time (runs + workouts)
    static func totalWorkoutMinutes() -> Int {
        load().reduce(0) { $0 + $1.durationMinutes }
    }

    //total run km across all time
    static func totalRunKm() -> Double {
        load().filter { $0.type == .run }.reduce(0) { $0 + $1.distanceKm }
    }
}
