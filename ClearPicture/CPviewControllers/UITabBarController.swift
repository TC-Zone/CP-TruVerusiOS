//
//  UITabBarController.swift
//  ClearPicture
//
//  Created by pasan vimukthi wijesuriya on 2/25/19.
//  Copyright © 2019 Trumpcode. All rights reserved.
//

import UIKit

class tabbarcontroller: UITabBarController {
    
    let button = UIButton.init(type: .custom)
    let layerGradient = CAGradientLayer()
    let ButtonGradient = CAGradientLayer()
    private var cachedSafeAreaInsets = UIEdgeInsets.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layerGradient.colors = [ UIColor(named: "DarkBlue")?.cgColor as Any , UIColor(named: "LightBlue")?.cgColor as Any]
        layerGradient.startPoint = CGPoint(x: 0, y: 0.5)
        layerGradient.endPoint = CGPoint(x: 1, y: 0.5)
        layerGradient.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        self.tabBar.layer.addSublayer(layerGradient)
        
        
        var safeAreaInsets: UIEdgeInsets {
            let insets = super.additionalSafeAreaInsets
            
            if insets.bottom < tabBar.bounds.height {
                cachedSafeAreaInsets = insets
                
            }
            
            return cachedSafeAreaInsets
        }
        
        self.tabBarController?.view.addSubview(button)
        
        addPhotoButton()
        
    }
    
    
    
    func addPhotoButton() {
        
        
        // Start of code to center button in the tab bar
        guard let tabItems = tabBar.items else { return }
        tabItems[0].titlePositionAdjustment = UIOffset(horizontal: -5, vertical: 0)
        tabItems[1].titlePositionAdjustment = UIOffset(horizontal: -30, vertical: 0)
        //tabItems[2].titlePositionAdjustment = UIOffset(horizontal: 30, vertical: 0)
        //tabItems[3].titlePositionAdjustment = UIOffset(horizontal: 5, vertical: 0)
        
        
        button.frame.size = CGSize(width: 70, height: 70)
        button.backgroundColor = .white
        button.layer.borderWidth = 4
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 35
        button.layer.masksToBounds = true
        button.center = CGPoint(x: UIScreen.main.bounds.width / 2, y:
            UIScreen.main.bounds.height - 40)
        
        ButtonGradient.colors = [ UIColor(named: "PlisButtonDarkPurple")?.cgColor as Any , UIColor(named: "PlusButtonLightPurple")?.cgColor as Any]
        ButtonGradient.startPoint = CGPoint(x: 0, y: 0.5)
        ButtonGradient.endPoint = CGPoint(x: 0.15, y: 0.5)
        ButtonGradient.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        self.button.layer.addSublayer(ButtonGradient)
        
        //button.setGradientBackground(ColorOne: UIColor(named: "DarkPurple")!, ColorTwo: UIColor(named: "LightPurple")!)
        
        let heightDifference = button.frame.size.height - self.tabBar.frame.size.height
        
        let image = UIImage(named: "plusImage") as UIImage?
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: ( button.bounds.size.width)/4,
                                 y: ( button.bounds.size.width)/4,
                                 width: ( button.bounds.size.width)/2,
                                 height: ( button.bounds.size.width)/2 )
        button.addSubview(imageView)
        
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                
            case 1334:
                print("iPhone 6/6S/7/8")
                
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                var center = self.tabBar.center;
                center.y = center.y - heightDifference/2.0 - 5
                button.center = center;
                
            case 2436:
                print("iPhone X, XS")
                var center = self.tabBar.center;
                center.y = center.y - heightDifference/2.0 - 40
                button.center = center;
                
            case 2688:
                print("iPhone XS Max")
                
            case 1792:
                print("iPhone XR")
                
            default:
                print("Unknown")
            }
        }
        
        
        self.view.addSubview(button)
        self.view.bringSubviewToFront(button)
    }
    
    
    
    
}
