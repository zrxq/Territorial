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
        
        let guide = layoutMarginsGuide
        
        // picture
        
        let leftPictureSpacer = UILayoutGuide()
        addLayoutGuide(leftPictureSpacer)
        let topPictureSpacer = UILayoutGuide()
        addLayoutGuide(topPictureSpacer)
        addSubview(picture)
        picture.translatesAutoresizingMaskIntoConstraints = false
        picture.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            picture.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            leftPictureSpacer.leftAnchor.constraint(equalTo: guide.leftAnchor),
            leftPictureSpacer.rightAnchor.constraint(equalTo: picture.leftAnchor),
            leftPictureSpacer.heightAnchor.constraint(equalTo: leftPictureSpacer.widthAnchor, multiplier: 1.0),
            topPictureSpacer.heightAnchor.constraint(equalTo: leftPictureSpacer.heightAnchor, multiplier: 1.0),
            topPictureSpacer.widthAnchor.constraint(equalTo: topPictureSpacer.heightAnchor, multiplier: 1.0),
            topPictureSpacer.topAnchor.constraint(equalTo: guide.topAnchor),
            picture.topAnchor.constraint(equalTo: topPictureSpacer.bottomAnchor),
            ])
        
        // button

        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.leftAnchor.constraint(equalTo: guide.leftAnchor),
            button.rightAnchor.constraint(equalTo: guide.rightAnchor),
            button.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
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
            message.leftAnchor.constraint(equalTo: guide.leftAnchor),
            message.rightAnchor.constraint(equalTo: guide.rightAnchor),
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

