//
//  RatingController.swift
//  Truverus
//
//  Created by User on 13/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation

import UIKit

class RatingController : UIStackView {
    
    var starRating = 0
    var starEmptyPicName = "star ouline"
    var starFilledPicName = "StarFilled"
    
    override func draw(_ rect: CGRect) {
        let views  = self.subviews.filter{$0 is UIButton}
        var starTag = 1
        
        for theview in views {
            
            if let theButton = theview as? UIButton {
                
                theButton.setImage(UIImage(named: starEmptyPicName), for: .normal)
                theButton.addTarget(self, action: #selector(pressed), for: .touchUpInside)
                theButton.tag = starTag
                starTag = starTag + 1
                
            }
            
        }
    }
    
    @objc func pressed (sender : UIButton) {
        
        starRating = sender.tag
        let views  = self.subviews.filter{$0 is UIButton}
        
        for theview in views {
            
            if let theButton = theview as? UIButton {
                
                if theButton.tag > sender.tag {
                    
                    theButton.setImage(UIImage(named: starEmptyPicName), for: .normal)
                    
                } else {
                    
                    theButton.setImage(UIImage(named: starFilledPicName), for: .normal)
                    
                }
                
            }
            
        }
        
    }
    
    
}
