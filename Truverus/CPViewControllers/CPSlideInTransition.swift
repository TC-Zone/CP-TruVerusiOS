//
//  CPSlideInTransition.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 3/11/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPSlideInTransition: NSObject, UIViewControllerAnimatedTransitioning {

    var IsPresenting = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from) else
        { return }
        
        let containerView = transitionContext.containerView
        
        let finalWidth = toViewController.view.bounds.width * 0.8
        let finalHeight = toViewController.view.bounds.height
        
        if IsPresenting {
            
            containerView.addSubview(toViewController.view)
            
            toViewController.view.frame = CGRect(x: -finalWidth, y: 0, width: finalWidth, height: finalHeight)
            
        }
        
        let transform = {
            
            toViewController.view.transform = CGAffineTransform(translationX: finalWidth, y: 0)
            
        }
        
        let identity = {
            
            fromViewController.view.transform = .identity
            
        }
        
        let duration = transitionDuration(using: transitionContext)
        let isCanceled = transitionContext.transitionWasCancelled
        
        UIView.animate(withDuration: duration, animations: {
            self.IsPresenting ? transform() : identity()
        }) { (_) in
            transitionContext.completeTransition(!isCanceled)
        }
        
    }
    
}

