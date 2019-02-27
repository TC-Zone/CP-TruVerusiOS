//
//  UIviewExtensions.swift
//  ClearPicture
//
//  Created by pasan vimukthi wijesuriya on 2/25/19.
//  Copyright © 2019 Trumpcode. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    
    func setGradientBackground(ColorOne: UIColor, ColorTwo: UIColor){
        
        let GradiantLayer = CAGradientLayer()
        GradiantLayer.frame = bounds
        GradiantLayer.colors = [ColorOne.cgColor , ColorTwo.cgColor]
        GradiantLayer.locations = [0.0 , 1.0]
        GradiantLayer.startPoint = CGPoint(x: 0.0 , y: 0.5)
        GradiantLayer.endPoint = CGPoint(x: 1.0 , y: 0.5)
        
        layer.insertSublayer(GradiantLayer, at: 0)
    }
    
}

extension UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        guard let window = UIApplication.shared.keyWindow else {
            return super.sizeThatFits(size)
        }
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = window.safeAreaInsets.bottom + 40
        return sizeThatFits
    }
}

extension UIView  {
    
    func setUiViewShadows(view : UIView) {
        
        view.clipsToBounds = false
        
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 2, height: 8)//Here your control your spread
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 5.0 //Here your control your blur
        
    }
    
}
