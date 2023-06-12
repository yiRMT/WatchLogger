//
//  LoggerManager.swift
//  WatchLogger
//
//  Created by iwashita on 2023/06/12.
//

import Foundation
import CoreMotion

class SensorLogger {
    let motionManager = CMMotionManager()
    let csvManager = LogDataCSVManager()
    
    var format = DateFormatter()
    var intervalSeconds = 0.02
    var attitude = SIMD3<Double>.zero
    var gyro = SIMD3<Double>.zero
    var gravity = SIMD3<Double>.zero
    var acc = SIMD3<Double>.zero
    
    /// Start recording sensor data
    /// - Parameter intervalSeconds: 記録周期
    func startSensorUpdates(reset: Bool, intervalSeconds: Double = 0.02) {
        csvManager.startRecording(reset: reset)
        if motionManager.isDeviceMotionAvailable{
            motionManager.deviceMotionUpdateInterval = intervalSeconds
            motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: { (motion, error) in
                self.getMotionData(deviceMotion: motion!)
            })
        }
    }
    
    /// Stop or resume sensor data
    func stopSensorUpdates() {
        csvManager.stopRecording()
        
        if motionManager.isDeviceMotionAvailable {
            motionManager.stopDeviceMotionUpdates()
        }
    }
    
    /// センサデータを書き込む
    /// - Parameter deviceMotion: センサ
    func getMotionData(deviceMotion: CMDeviceMotion) {
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
                
        // record sensor data
        if csvManager.isRecording {
            format.dateFormat = "yyyy/MM/dd HH:mm:ss.SSS"
            
            var text = ""
            text += format.string(from: Date()) + ","
            //print(text)
                        
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
            text += String(acc.z)
            
            csvManager.addRecordText(addText: text)
        }
    }
    
    /// CSVに記録する
    func saveAsCsv() throws {
        if csvManager.isRecording {
            csvManager.stopRecording()
            
            // save csv file
            format.dateFormat = "yyyy-MMdd-HHmmss"
            let dateText = format.string(from: Date())
            do {
                try csvManager.saveSensorDataToCsv(fileName: "watchmotion_" + dateText)
            } catch {
                throw error
            }
        }
    }

}
