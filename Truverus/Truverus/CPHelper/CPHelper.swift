//
//  CPHelper.swift
//  Truverus
//
//  Created by User on 15/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation
import SVProgressHUD

class CPHelper {
    
    static func roundCorners(_view : UIView)  {
        _view.layer.cornerRadius = 10
        _view.clipsToBounds = true
    }
    
    static func showHud(){
        SVProgressHUD.show()
    }
    
    static func hideHud(){
        SVProgressHUD.dismiss()
    }
}
