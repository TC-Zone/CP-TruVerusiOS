//
//  CPHelper.swift
//  ClearPicture
//
//  Created by pasan vimukthi wijesuriya on 2/20/19.
//  Copyright © 2019 Trumpcode. All rights reserved.
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
