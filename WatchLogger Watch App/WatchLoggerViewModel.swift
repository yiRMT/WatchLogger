//
//  WatchLoggerViewModel.swift
//  WatchLogger Watch App
//
//  Created by iwashita on 2023/06/12.
//

import SwiftUI
import WatchConnectivity
import CoreMotion

final class WatchLoggerViewModel: NSObject, ObservableObject {
    private var session: WCSession
    private let motionManager: CMMotionManager
    
    private var format = DateFormatter()
    private var intervalSeconds = 0.02
    
    private var attitude = SIMD3<Double>.zero
    private var gyro = SIMD3<Double>.zero
    private var gravity = SIMD3<Double>.zero
    private var acc = SIMD3<Double>.zero
    
    // The screen will be updated when this value is changed
    @Published private(set) var isRecording = false
    
    init(session: WCSession = .default, motionManager: CMMotionManager = .init()) {
        self.session = session
        self.motionManager = motionManager
        super.init()
        self.session.delegate = self
        session.activate()
    }
        
    private func sendLog(log: String) {
        let data = Data(log.utf8)
        session.sendMessageData(data, replyHandler: nil) { (error) in
            print(error.localizedDescription)
        }
    }
    
    /// Start recording sensor data
    /// - Parameter intervalSeconds: 記録周期
    func startSensorUpdates(intervalSeconds: Double = 0.02) {
        isRecording = true
        let message = ["isRecording": isRecording]
        session.sendMessage(message, replyHandler: nil)
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = intervalSeconds
            motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: { (motion, error) in
                guard let motion = motion else { return }
                let log = self.getMotionData(deviceMotion: motion)
                self.sendLog(log: log)
            })
        }
    }
    
    /// Stop or resume sensor data
    func stopSensorUpdates() {
        isRecording = false
        let message = ["isRecording": isRecording]
        session.sendMessage(message, replyHandler: nil)
        if motionManager.isDeviceMotionAvailable {
            motionManager.stopDeviceMotionUpdates()
        }
    }
    
    /// Get sensor data as string
    /// - Parameter deviceMotion: センサ
    func getMotionData(deviceMotion: CMDeviceMotion) -> String {
        attitude.x = deviceMotion.attitude.pitch
        attitude.y = deviceMotion.attitude.roll
        attitude.z = deviceMotion.attitude.yaw
        gyro.x = deviceMotion.rotationRate.x
        gyro.y = deviceMotion.rotationRate.y
        gyro.z = deviceMotion.rotationRate.z
        gravity.x = deviceMotion.gravity.x
        gravity.y = deviceMotion.gravity.y
        gravity.z = deviceMotion.gravity.z
        acc.x = deviceMotion.userAcceleration.x
        acc.y = deviceMotion.userAcceleration.y
        acc.z = deviceMotion.userAcceleration.z
                
        format.dateFormat = "yyyy/MM/dd HH:mm:ss.SSS"
        
        var text = ""
        text += format.string(from: Date()) + ","
        text += String(attitude.x) + ","
        text += String(attitude.y) + ","
        text += String(attitude.z) + ","
        text += String(gyro.x) + ","
        text += String(gyro.y) + ","
        text += String(gyro.z) + ","
        text += String(gravity.x) + ","
        text += String(gravity.y) + ","
        text += String(gravity.z) + ","
        text += String(acc.x) + ","
        text += String(acc.y) + ","
        text += String(acc.z) + ","
        text += "\n"
        
        return text
    }
}

extension WatchLoggerViewModel: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("The session has completed activation.")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        guard let isRecording = message["isRecording"] else { return }
        self.isRecording = isRecording as! Bool
        if self.isRecording {
            startSensorUpdates()
        } else {
            stopSensorUpdates()
        }
    }
}
