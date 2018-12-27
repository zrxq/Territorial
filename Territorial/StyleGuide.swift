//
//  UIColor+Shared.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/27/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import UIKit

extension UIColor {
    static let background = UIColor(red: 25 / 255, green: 28 / 255, blue: 28 / 255, alpha: 1.0)
    static let text = UIColor.white
}

extension UIEdgeInsets {
    static let margins = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
    static let heroButtonContent = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
}

extension UIFont {
    static let emphasizedBody = UIFont.systemFont(ofSize: 17, weight: .regular)
    static let heroButton = UIFont.systemFont(ofSize: 19, weight: .semibold)
}
