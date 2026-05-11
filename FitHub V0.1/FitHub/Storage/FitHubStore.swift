//
//  FitHubStore.swift
//  FitHub
//
//  Created by Safiullah Noori on 23/4/2026.
//

import Foundation

//save and load simple app settings to a JSON file in Documents
class FitHubStore {

    //path to the settings file
    private static var fileURL: URL {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("fithub_settings.json")
    }

    //load all stored settings
    private static func loadSettings() -> [String: String] {
        guard let data = try? Data(contentsOf: fileURL) else { return [:] }
        return (try? JSONDecoder().decode([String: String].self, from: data)) ?? [:]
    }

    //save all settings to disk immediately
    private static func saveSettings(_ settings: [String: String]) {
        guard let data = try? JSONEncoder().encode(settings) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    //save a single string value
    static func set(_ value: String, forKey key: String) {
        var settings = loadSettings()
        settings[key] = value
        saveSettings(settings)
    }

    //load a single string value with a fallback default
    static func string(forKey key: String, default fallback: String) -> String {
        loadSettings()[key] ?? fallback
    }
}
