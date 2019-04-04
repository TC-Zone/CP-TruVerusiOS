//
//  CPExtenssions.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 3/26/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation
import UIKit

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
