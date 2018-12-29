//
//  Prompt.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/29/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import UIKit

protocol Prompt {
    var picture: UIImage { get }
    var message: String { get }
    var buttonTitle: String { get }
    func handleButton()
}
