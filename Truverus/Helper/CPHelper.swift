//
//  CPHelper.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 3/8/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//


import UIKit
import IHProgressHUD

class CPHelper {
    
    static func roundCorners(_view : UIView)  {
        _view.layer.cornerRadius = 10
        _view.clipsToBounds = true
    }
    
    static func showHud(){
        IHProgressHUD.show()
    }
    
    static func hideHud(){
        IHProgressHUD.dismiss()
    }
}
