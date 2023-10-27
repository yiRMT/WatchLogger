//
//  ContentView.swift
//  WatchLogger Watch App
//
//  Created by iwashita on 2023/06/12.
//

import SwiftUI

struct ContentView: View {
    @State var loggingRate: Double = 50
    @StateObject var viewModel: WatchLoggerViewModel
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "applewatch.side.right")
                    .imageScale(.large)
                Text("Watch Logger")
                    .bold()
            }
            VStack {
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
            }
            .padding(.vertical)
        }
        .padding()
    }
    
    enum RecordingState {
        case recording
        case stopping
    }
    
    
}

#Preview {
    ContentView(
        viewModel: WatchLoggerViewModel()
    )
}
