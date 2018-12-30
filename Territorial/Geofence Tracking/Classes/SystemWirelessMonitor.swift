//
//  SystemWirelessMonitor.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/30/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import Foundation
import SystemConfiguration.CaptiveNetwork

final class SystemWirelessMonitor: WirelessMonitor {
    
    weak var delegate: WirelessMonitorDelegate?
    
    class var ssid: String? {
        var ssid: String?
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    break
                }
            }
        }
        return ssid
    }
    
    private lazy var darwinNotifyCenter = CFNotificationCenterGetDarwinNotifyCenter()
    private var opaqueSelf: UnsafeMutableRawPointer {
        return Unmanaged.passUnretained(self).toOpaque()
    }
    
    func startMonitoring() {
        lastKnownSSID = SystemWirelessMonitor.ssid
        CFNotificationCenterAddObserver(darwinNotifyCenter, opaqueSelf, { (_, observer, _, _, _) in
            guard let observer = observer else { return }
            let `self` = Unmanaged<SystemWirelessMonitor>.fromOpaque(observer).takeUnretainedValue()
            self.trackNetworkChange()
        }, DarwinNetworkChangeNotification, nil, .coalesce)
        delegate?.wirelessMonitor(self, didUpdateSSID: lastKnownSSID)
    }
    
    func stopMonitoring() {
        CFNotificationCenterRemoveObserver(darwinNotifyCenter, opaqueSelf, CFNotificationName(DarwinNetworkChangeNotification), nil)
    }
    
    private var lastKnownSSID: String?
    
    private func trackNetworkChange() {
        assert(Thread.isMainThread)
        let ssid = SystemWirelessMonitor.ssid
        
        if ssid != lastKnownSSID {
            delegate?.wirelessMonitor(self, didUpdateSSID: ssid)
            lastKnownSSID = ssid
        }
    }
}
