//
//  WatchLoggerApp.swift
//  WatchLogger Watch App
//
//  Created by iwashita on 2023/06/12.
//

import SwiftUI

@main
struct WatchLogger_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                viewModel: WatchLoggerViewModel()
            )
        }
    }
}
