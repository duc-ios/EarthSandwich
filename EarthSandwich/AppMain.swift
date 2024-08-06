//
//  AppMain.swift
//  EarthSandwich
//
//  Created by Duc on 6/8/24.
//

import SwiftUI
import SwiftData

@main
struct AppMain: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            SearchHistory.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            AppView()
        }
        .modelContainer(sharedModelContainer)
    }
}
