//
//  CPRemovePopupViewController.swift
//  Truverus
//
//  Created by User on 10/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPRemovePopupViewController: UIViewController {
    
    @IBOutlet weak var TopView: UIView!
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var RemoveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        let transfrom = CGAffineTransform(translationX: 0, y: -200)
        TopView.transform = transfrom
        UIView.commitAnimations()
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view == self.view {
            print("touched")
            
            dismissview()
        }
    }
    
    func dismissview() {
        
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.view.removeFromSuperview()
        })
        // Your animation here
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        let transfrom = CGAffineTransform(translationX: 0, y: 200)
        self.TopView.transform = transfrom
        self.view.backgroundColor = UIColor.clear
        UIView.commitAnimations()
        CATransaction.commit()
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
