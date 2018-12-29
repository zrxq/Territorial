//
//  WiFiOverlayButton.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/29/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import UIKit

class WiFiOverlayButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImage(UIImage(named: "WiFiOverlayIcon"), for: .normal)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported.")
    }
}
