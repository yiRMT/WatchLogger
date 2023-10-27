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
            Text(viewModel.logString)
            Button {
                viewModel.startSensorUpdates()
                
            } label: {
                Text("Start Recording")
            }
            .foregroundStyle(.green)
            .opacity(viewModel.isRecording ? 0.5 : 1.0)
            .disabled(viewModel.isRecording)
            
            Button {
                viewModel.stopSensorUpdates()
            } label: {
                Text("Stop Recording")
            }
            .foregroundStyle(.red)
            .opacity(!viewModel.isRecording ? 0.5 : 1.0)
            .disabled(!viewModel.isRecording)
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
