//
//  UIViewController+Util.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/29/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import UIKit

extension UIViewController {
    func install(_ viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
    
    func uninstall() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
