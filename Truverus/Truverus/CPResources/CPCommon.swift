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
