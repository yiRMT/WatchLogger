//
//  ContentView.swift
//  WatchLogger Watch App
//
//  Created by iwashita on 2023/06/12.
//

import SwiftUI

struct ContentView: View {
    @State var isRecording = false
    @State var loggingRate: Double = 50
    var logger = SensorLogger()
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
                    viewModel.sendMessage(message: ["state": true])
//                    logger.startSensorUpdates(reset: true, intervalSeconds: 1.0/loggingRate)
//                    isRecording.toggle()
                } label: {
                    Text("Start Recording")
                }
                .foregroundStyle(.green)
                .opacity(isRecording ? 0.5 : 1.0)
                .disabled(isRecording)
                
                Button {
                    do {
                        try logger.stopSensorUpdates()
                        isRecording.toggle()
                    } catch {
                        print(error)
                    }
                } label: {
                    Text("Stop Recording")
                }
                .foregroundStyle(.red)
                .opacity(!isRecording ? 0.5 : 1.0)
                .disabled(!isRecording)
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
