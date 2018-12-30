//
//  MockWirelessMonitor.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/30/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import Foundation

class MockWirelessMonitor: WirelessMonitor {
    
    var isMonitoring = false
    
    var ssid: String? {
        didSet {
            delegate?.wirelessMonitor(self, didUpdateSSID: ssid)
        }
    }
    
    func startMonitoring() {
        assert(!isMonitoring)
        delegate?.wirelessMonitor(self, didUpdateSSID: ssid)
        isMonitoring = true
    }
    
    func stopMonitoring() {
        assert(isMonitoring)
        isMonitoring = false
    }
    
    var delegate: WirelessMonitorDelegate?
}
