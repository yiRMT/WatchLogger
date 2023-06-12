//
//  ContentView.swift
//  WatchLogger Watch App
//
//  Created by iwashita on 2023/06/12.
//

import SwiftUI

struct ContentView: View {
    @State var recordingState: RecordingState = .stop
    var logger = SensorLogger()
    var body: some View {
        VStack {
            Text("Watch Logger")
                .bold()
                .multilineTextAlignment(.center)
            Spacer()
            switch recordingState {
            case .start:
                VStack {
                    Button {
                        logger.stopSensorUpdates()
                        recordingState = .resume
                    } label: {
                        Text("Resume Recording")
                    }
                    .foregroundStyle(.yellow)
                    Button {
                        do {
                            try logger.saveAsCsv()
                            recordingState = .stop
                        } catch {
                            print(error)
                        }
                    } label: {
                        Text("Stop Recording")
                    }
                    .foregroundStyle(.red)
                }
            case .resume:
                VStack {
                    Button {
                        logger.startSensorUpdates(reset: false)
                        recordingState = .start
                    } label: {
                        Text("Start Recording")
                    }
                    .foregroundStyle(.green)
                    Button {
                        do {
                            try logger.saveAsCsv()
                            recordingState = .stop
                        } catch {
                            print(error)
                        }
                    } label: {
                        Text("Stop Recording")
                    }
                    .foregroundStyle(.red)
                }
            case .stop:
                VStack {
                    Button {
                        logger.startSensorUpdates(reset: true)
                        recordingState = .start
                    } label: {
                        Text("Start Recording")
                    }
                    .foregroundStyle(.green)
                }
            }
            
        }
        .padding()
    }
    
    enum RecordingState {
        case start
        case resume
        case stop
    }
}

#Preview {
    ContentView()
}
