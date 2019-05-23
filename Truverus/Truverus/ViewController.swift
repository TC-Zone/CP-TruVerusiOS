//
//  ViewController.swift
//  Truverus
//
//  Created by User on 30/4/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSlideMenuButton()
        
        if productStruct.productObj.productTitle != "" {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "CPHomeView", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "CPHomeView") as! CPHomeViewController
            self.navigationController?.pushViewController(newViewController, animated: true)
            
        } else {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "NFC", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "CPNFCView") as! CPNfcViewController
            self.navigationController?.pushViewController(newViewController, animated: true)
            
        }
        
        
        
    }
}


