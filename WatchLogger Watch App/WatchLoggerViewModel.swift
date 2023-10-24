//
//  WatchLoggerViewModel.swift
//  WatchLogger Watch App
//
//  Created by iwashita on 2023/06/12.
//

import SwiftUI
import WatchConnectivity

final class WatchLoggerViewModel: NSObject, ObservableObject {
    private var session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        //self.session.delegate = self
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
}
