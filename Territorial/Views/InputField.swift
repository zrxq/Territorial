//
//  InputField.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/28/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import UIKit

class InputField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = .text
        font = .formField
        borderStyle = .roundedRect
        backgroundColor = .fieldBackground
        keyboardAppearance = .dark
        returnKeyType = .done
        spellCheckingType = .no
        autocorrectionType = .no
        autocapitalizationType = .none
    }
    
    override var placeholder: String? {
        get {
            return super.placeholder
        }
        set {
            if let newValue = newValue {
            super.attributedPlaceholder = NSAttributedString(string: newValue, attributes: [.foregroundColor: UIColor.placeholder])
            } else {
                super.placeholder = nil
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported")
    }
}
