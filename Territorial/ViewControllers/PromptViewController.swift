//
//  PromptViewController.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/29/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import UIKit

final class PromptViewController: UIViewController {

    let prompt: Prompt

    init(with prompt: Prompt) {
        self.prompt = prompt
        super.init(nibName: nil, bundle: nil)
    }
    
    private lazy var promptView = PromptView()
    
    override func loadView() {
        view = promptView
    }
    
    override func viewDidLoad() {
        promptView.picture.image = prompt.picture
        promptView.message.text = prompt.message
        promptView.button.setTitle(prompt.buttonTitle, for: .normal)
        promptView.button.addTarget(self, action: #selector(forwardHandleButton), for: .touchUpInside)
    }
    
    @objc func forwardHandleButton() {
        prompt.handleButton()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported.")
    }
}
