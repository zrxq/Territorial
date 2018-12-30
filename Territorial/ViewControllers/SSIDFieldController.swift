//
//  SSIDFieldController.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/29/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import UIKit

class SSIDFieldController: UIViewController {
    
    var value: String? {
        set { textField.text = newValue }
        get { return textField.text }
    }
    
    typealias Handler = (String?) -> ()
    var onChange: Handler?
    
    var textField: UITextField! {
        get {
            return view as! UITextField?
        }
        
        set {
            view = newValue
            assert(newValue.delegate == nil)
            newValue.delegate = self
            
            let autofillButton = WiFiOverlayButton(type: .system)
            autofillButton.sizeToFit()
            newValue.rightView = autofillButton
            newValue.rightViewMode = SystemWirelessMonitor.ssid == nil ? .never : .always
            
            autofillButton.addTarget(self, action: #selector(autofillSSID), for: .touchUpInside)
        }
    }

    override func loadView() {
        assertionFailure("\(type(of: self)) requires .textField/.view to be set before use.")
    }
    
    private let wifi = SystemWirelessMonitor()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        wifi.delegate = self
        wifi.startMonitoring()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        wifi.stopMonitoring()
    }
    
    @objc func autofillSSID() {
        value = SystemWirelessMonitor.ssid
        onChange?(value)
    }
}

extension SSIDFieldController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else {
            return false
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let current = (textField.text ?? "") as NSString
        let resulting = current.replacingCharacters(in: range, with: string)
        onChange?(resulting)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        onChange?(value)
    }
}

extension SSIDFieldController: WirelessMonitorDelegate {
    func wirelessMonitor(_ monitor: WirelessMonitor, didUpdateSSID ssid: String?) {
        textField.rightViewMode = ssid == nil ? .never : .always
    }
}
