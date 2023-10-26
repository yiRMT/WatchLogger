//
//  ContentView.swift
//  WatchLogger
//
//  Created by iwashita on 2023/06/12.
//

import SwiftUI
import Charts

struct ContentView: View {
    @StateObject var viewModel: WatchLoggerViewModel
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "applewatch.side.right")
                    .imageScale(.large)
                Text("Watch Logger")
                    .bold()
            }
            Text(viewModel.isPaired ? "YES": "NO")
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView(
        viewModel: WatchLoggerViewModel(
            stateModel: ConnectivityStateModel()
        )
    )
}
