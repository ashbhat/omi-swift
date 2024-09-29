//
//  OmiManager.swift
//  omi-swift
//
//  Created by Ash Bhat on 9/29/24.
//

import Foundation

class OmiManager {
    private static var singleton = FriendManager()
    var deviceCompletion: ((Friend?, Error?) -> Void)?

    static func startScan(completion: ((Friend?, Error?) -> Void)?) {
        singleton.deviceCompletion = completion
        singleton.startScan()
    }
    
    static func endScan() {
        self.singleton.deviceCompletion = nil
        self.singleton.bluetoothScanner.centralManager.stopScan()
    }
    
    static func connectToDevice(device: Friend) {
        self.singleton.connectToDevice(device: device)
    }
    
    static func connectionUpdated(completion: @escaping(Bool) -> Void) {
        self.singleton.connectionStatus(completion: completion)
    }
    
    static func getLiveTranscription(device: Friend, completion: @escaping (String?) -> Void) {
        self.singleton.getLiveTranscription(device: device, completion: completion)
    }
    
    static func getLiveAudio(device: Friend, completion: @escaping (URL?) -> Void) {
        self.singleton.getRawAudio(device: device, completion: completion)
    }
}
