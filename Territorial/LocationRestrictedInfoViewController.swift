//
//  LocationRestrictedInfoViewController.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/27/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import UIKit

class LocationRestrictedInfoViewController: UIViewController {
    
    @objc func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
    }
    
    override func loadView() {
        super.loadView()
        let contentView = makePromptView()
        view.addSubview(contentView)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func makePromptView() -> UIView {
        
        let promptView = PromptView(frame: view.frame)
        
        promptView.picture.image = UIImage(named: "LocationRestrictedPicture")
        
        promptView.message.text = NSLocalizedString("Frankly, this app can't do anything without Location access. Could you please use Settings to fix this?", comment: "Location unavailable info message.")
        promptView.button.setTitle(NSLocalizedString("Open Settings", comment: "Location unavailable Open Settings button title."), for: .normal)
        promptView.button.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
        
        return promptView
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported")
    }

}
