//
//  WirelessMonitor.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/29/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import Foundation

protocol WirelessMonitorDelegate: AnyObject {
    
    func wirelessMonitor(_ monitor: WirelessMonitor, didUpdateSSID ssid: String?)
    
}

protocol WirelessMonitor: AnyObject {
    
    func startMonitoring()
    
    func stopMonitoring()
    
    var delegate: WirelessMonitorDelegate? { get set }
    
}
