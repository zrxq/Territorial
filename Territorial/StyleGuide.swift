//
//  UIColor+Shared.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/27/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import UIKit

extension UIColor {
    static let background = UIColor(red: 25 / 255, green: 28 / 255, blue: 28 / 255, alpha: 1)
    static let text = UIColor.white
    static let placeholder = UIColor(white: 102 / 255, alpha: 1)
    static let fieldLabel = UIColor(white: 0.7, alpha: 1)
    static let fieldBackground = UIColor(white: 57 / 255, alpha: 1)
    static let active = UIColor(red: 0, green: 208 / 255, blue: 162 / 255, alpha: 1)
}

extension UIEdgeInsets {
    static let margins = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
    static let heroButtonContent = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    static let panelMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
}

extension UIFont {
    static let emphasizedBody = UIFont.systemFont(ofSize: 17, weight: .regular)
    static let heroButton = UIFont.systemFont(ofSize: 19, weight: .semibold)
    static let formLabel = UIFont.systemFont(ofSize: 15)
    static let formField = UIFont.systemFont(ofSize: 17)
}
