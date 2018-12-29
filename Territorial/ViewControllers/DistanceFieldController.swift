//
//  DistanceFieldController.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/29/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import UIKit

class DistanceFieldController: UIViewController {
    
    var shouldEndEditingOnReturn = true
    var minValue: Double?
    var maxValue: Double?
    
    typealias Handler = (Double?) -> ()
    var onChange: Handler?
    
    var value: Double? {
        set {
            if let value = newValue {
                textField.text = formatter.string(from: value as NSNumber)
            } else {
                textField.text = nil
            }
        }
        get {
            if let text = textField.text {
                return formatter.number(from: text)?.doubleValue
            } else {
                return nil
            }
        }
    }
    
    var textField: UITextField! {
        get {
            return view as! UITextField?
        }
        
        set {
            view = newValue
            assert(newValue.delegate == nil)
            newValue.delegate = self
        }
    }
    
    private lazy var formatter: NumberFormatter = {
        let f = NumberFormatter()
        f.maximumFractionDigits = 0
        f.usesGroupingSeparator = false
        return f
    }()
    
    override func loadView() {
        assertionFailure("\(type(of: self)) requires .textField/.view to be set before use.")
    }
    
    private func clamp(_ value: Double?) -> Double? {
        guard let value = value else { return nil }
        var clamped = value
        if let minValue = minValue {
            clamped = max(minValue, clamped)
        }
        if let maxValue = maxValue {
            clamped = min(maxValue, clamped)
        }
        return clamped
    }
}

extension DistanceFieldController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectAll(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if shouldEndEditingOnReturn {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let current = (textField.text ?? "") as NSString
        let resulting = current.replacingCharacters(in: range, with: string)
        if resulting.isEmpty {
            onChange?(nil)
            return true
        }
        if let value = formatter.number(from: resulting)?.doubleValue {
            onChange?(clamp(value))
            return true
        } else {
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        value = clamp(value)
    }
}
