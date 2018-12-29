//
//  PromptView.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/27/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import UIKit

final class PromptView: UIView {
    let picture = UIImageView()
    let message = UILabel()
    let button = HeroButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .background
        layoutMargins = UIEdgeInsets.margins
        
        let margins = layoutMarginsGuide
        
        // picture
        
        let leftPictureSpacer = UILayoutGuide()
        addLayoutGuide(leftPictureSpacer)
        let topPictureSpacer = UILayoutGuide()
        addLayoutGuide(topPictureSpacer)
        addSubview(picture)
        picture.translatesAutoresizingMaskIntoConstraints = false
        picture.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            picture.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            leftPictureSpacer.leftAnchor.constraint(equalTo: margins.leftAnchor),
            leftPictureSpacer.rightAnchor.constraint(equalTo: picture.leftAnchor),
            leftPictureSpacer.heightAnchor.constraint(equalTo: leftPictureSpacer.widthAnchor, multiplier: 1.0),
            topPictureSpacer.heightAnchor.constraint(equalTo: leftPictureSpacer.heightAnchor, multiplier: 1.0),
            topPictureSpacer.widthAnchor.constraint(equalTo: topPictureSpacer.heightAnchor, multiplier: 1.0),
            topPictureSpacer.topAnchor.constraint(equalTo: margins.topAnchor),
            picture.topAnchor.constraint(equalTo: topPictureSpacer.bottomAnchor),
            ])
        
        // button

        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.leftAnchor.constraint(equalTo: margins.leftAnchor),
            button.rightAnchor.constraint(equalTo: margins.rightAnchor),
            button.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            ])
        
        // message label
        
        let topMessageSpacer = UILayoutGuide()
        addLayoutGuide(topMessageSpacer)
        addSubview(message)
        message.font = .emphasizedBody
        message.textColor = .text
        message.textAlignment = .center
        message.numberOfLines = 0
        message.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            message.leftAnchor.constraint(equalTo: margins.leftAnchor),
            message.rightAnchor.constraint(equalTo: margins.rightAnchor),
            topMessageSpacer.heightAnchor.constraint(equalTo: topPictureSpacer.heightAnchor, multiplier: 1.0),
            topMessageSpacer.topAnchor.constraint(equalTo: picture.bottomAnchor),
            message.topAnchor.constraint(equalTo: topMessageSpacer.bottomAnchor),
            message.bottomAnchor.constraint(lessThanOrEqualTo: button.topAnchor),
            ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported.")
    }
}

