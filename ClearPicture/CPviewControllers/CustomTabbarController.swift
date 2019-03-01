//
//  UITabBarController.swift
//  ClearPicture
//
//  Created by pasan vimukthi wijesuriya on 2/25/19.
//  Copyright © 2019 Trumpcode. All rights reserved.
//

import UIKit

class CustomTabbarController: UITabBarController, UITabBarControllerDelegate {
    
    let layerGradient = CAGradientLayer()
    let buttonGradient = CAGradientLayer()
    //private var cachedSafeAreaInsets = UIEdgeInsets.zero
    
    private struct Constants {
        static let actionButtonSize = CGSize(width: 64, height: 64)
    }
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = UIColor.darkGray
        button.layer.cornerRadius = Constants.actionButtonSize.height/2
        
        button.addTarget(self, action: #selector(actionButtonTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(actionButton)
        setupConstraints()
        //self.tabBarController?.tabBar.delegate = self
        layerGradient.colors = [ UIColor(named: "DarkBlue")?.cgColor as Any , UIColor(named: "LightBlue")?.cgColor as Any]
        layerGradient.startPoint = CGPoint(x: 0, y: 0.5)
        layerGradient.endPoint = CGPoint(x: 1, y: 0.5)
        layerGradient.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        //self.tabBar.layer.addSublayer(layerGradient)
        self.tabBar.layer.insertSublayer(layerGradient, at:0)
        self.tabBar.tintColor = UIColor.black
        self.tabBar.unselectedItemTintColor = UIColor.red
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        actionButton.isHidden = false
    }
    
    private func setupConstraints() {
        actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        actionButton.widthAnchor.constraint(equalToConstant: Constants.actionButtonSize.width).isActive = true
        actionButton.heightAnchor.constraint(equalToConstant: Constants.actionButtonSize.height).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: tabBar.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    @objc private func actionButtonTapped(sender: UIButton) {
        print("Clicked")
    }
    
}

