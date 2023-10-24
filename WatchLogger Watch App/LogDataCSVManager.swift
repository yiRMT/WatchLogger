//
//  LogDataCSVManager.swift
//  WatchLogger
//
//  Created by iwashita on 2023/06/12.
//

import Foundation
import WatchConnectivity

class LogDataCSVManager {
    private(set) var isRecording = false
    private let headerText = "timestamp,attitudeX,attitudeY,attitudeZ,gyroX,gyroY,gyroZ,gravityX,gravityY,gravityZ,accX,accY,accZ"
    private var recordText = ""
    
    var format = DateFormatter()
    
    
    /// Initializer
    init() {
        format.dateFormat = "yyyyMMddHHmmssSSS"
    }
    
    func startRecording(reset: Bool) {
        if reset {
            recordText = ""
            recordText += headerText + "\n"
        }
        isRecording = true
    }
        
    func stopRecording() {
        isRecording = false
    }
    
    func addRecordText(addText: String) {
        recordText += addText + "\n"
    }
    
    func saveSensorDataToCsv(fileName: String) throws {
        let fileManager = FileManager.default
        let docPath = NSHomeDirectory() + "/Documents"
        let filePath = docPath + "\(fileName).csv"
        let data = recordText.data(using: .utf8) ?? Data()
        
        if !fileManager.fileExists(atPath: filePath) {
            fileManager.createFile(atPath: filePath, contents: data)
        } else {
            throw NSError(domain: "error", code: -1, userInfo: nil)
        }
    }
}
