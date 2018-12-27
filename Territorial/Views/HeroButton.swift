//
//  HeroButton.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/27/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import UIKit

final class HeroButton: UIButton {
    
    convenience init() {
        self.init(type: .custom)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setBackgroundImage(UIImage(named: "HeroButtonBackground"), for: .normal)
        setTitleColor(.text, for: .normal)
        titleLabel?.font = .heroButton
        contentEdgeInsets = .heroButtonContent
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported")
    }
}
