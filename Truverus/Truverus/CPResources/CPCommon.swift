//
//  CPCommon.swift
//  Truverus
//
//  Created by User on 30/4/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation
import UIKit

class CPcommon {
    
    func CreateTextFields(TextField : UITextField , img : UIImage) {
        
        let ImgView = UIImageView(frame: CGRect(x: 5.0, y: 0.0, width: img.size.width, height: img.size.height))
        ImgView.image = img
        
        let leftView = UIView()
        leftView.addSubview(ImgView)
        
        leftView.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
        ImgView.frame = CGRect(x: 11, y: 0, width: 15, height: 15)
        
        TextField.leftView = leftView
        TextField.leftViewMode = .always
        
        TextField.layer.borderColor = UIColor(named: "ShadedLightBlue")?.cgColor
        TextField.layer.borderWidth = 1.0
        TextField.layer.cornerRadius = 23
        
    }
    
}

extension UIScrollView  {
    
    func validateScrolling(view : UIScrollView) {
        
        
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                view.isScrollEnabled = true
            case 1334:
                print("iPhone 6/6S/7/8")
                view.isScrollEnabled = false
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                view.isScrollEnabled = false
                
            case 2436:
                print("iPhone X, XS")
                view.isScrollEnabled = false
                
            case 2688:
                print("iPhone XS Max")
                view.isScrollEnabled = false
                
            case 1792:
                print("iPhone XR")
                view.isScrollEnabled = false
                
            default:
                print("Unknown")
            }
        }
        
    }
    
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}


struct keys {
    
    static let accesstoken = "Access_Token"
    static let refreshtoken = "Refresh_Token"
    
}
