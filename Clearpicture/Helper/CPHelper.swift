//
//  CPHelper.swift
//  Clearpicture
//
//  Created by Hasitha De Mel on 1/19/19.
//  Copyright © 2019 Hasitha. All rights reserved.
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
