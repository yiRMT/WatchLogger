//
//  WatchLoggerViewModel.swift
//  WatchLogger
//
//  Created by iwashita on 2023/06/13.
//

import Foundation
import WatchConnectivity

final class WatchLoggerViewModel: NSObject, ObservableObject {
    @Published var stateModel: ConnectivityStateModel
    
    private var session: WCSession
    
    init(session: WCSession = .default, stateModel: ConnectivityStateModel) {
        self.session = session
        self.stateModel = stateModel
        super.init()
        self.session.delegate = self
        session.activate()
    }
    
    var isPaired: Bool {
        get {
            return stateModel.isPaired
        }
        set {
            stateModel.changeParied(state: newValue)
        }
    }
    
    var isReachable: Bool {
        get {
            return stateModel.isReachable
        }
        set {
            stateModel.changeReachable(state: newValue)
        }
    }
    
    var isComplicationEnabled: Bool {
        get {
            return stateModel.isComplicationEnabled
        }
        set {
            stateModel.changeComplicationEnabled(state: newValue)
        }
    }
    
    var isWatchAppInstalled: Bool {
        get {
            return stateModel.isWatchAppInstalled
        }
        set {
            stateModel.changeWatchAppInstalled(state: newValue)
        }
    }
    
    var wcSessionState: WCSessionActivationState {
        get {
            return stateModel.wcSessionState
        }
        set {
            stateModel.changeWCSession(state: newValue)
        }
    }
}

extension WatchLoggerViewModel: WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("The session has completed activation.")
        }
    }
}
