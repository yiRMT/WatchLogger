//
//  WatchLoggerApp.swift
//  WatchLogger
//
//  Created by iwashita on 2023/06/12.
//

import SwiftUI

@main
struct WatchLoggerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                viewModel: WatchLoggerViewModel(
                    stateModel: ConnectivityStateModel()
                )
            )
        }
    }
}
