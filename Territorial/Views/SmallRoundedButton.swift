//
//  SmallRoundedButton.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/30/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import UIKit

class SmallRoundedButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setBackgroundImage(UIImage(named: "SmallRoundedButtonBackground"), for: .normal)
        setTitleColor(.background, for: .normal)
        titleLabel?.font = .smallRoundedButton
        contentEdgeInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported.")
    }
    
}
