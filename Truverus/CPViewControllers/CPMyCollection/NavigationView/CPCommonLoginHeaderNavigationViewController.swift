//
//  CPCommonLoginHeaderNavigationViewController.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 3/26/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPCommonLoginHeaderNavigationViewController: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var headerLable: UILabel!
    @IBOutlet weak var backButton: UIButton!
    

    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
        UINib(nibName: "CPCommonLoginHeaderNavigationViewController", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
    }
 
    
    
}
