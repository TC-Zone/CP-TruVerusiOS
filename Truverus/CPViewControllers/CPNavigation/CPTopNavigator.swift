//
//  CPTopNavigator.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 4/1/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation


class CPTopNavigator: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var MenuButton: UIButton!
    
    let Transition = CPSlideInTransition()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
        UINib(nibName: "CPTopNavigator", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
    }
    
    @IBAction func MenuAction(_ sender: Any) {
        
        let x = appDelegate.state
        
        print("state is ::: \(x)")
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let MenuViewController : CPMenuViewController = storyboard.instantiateViewController(withIdentifier: "CPMenuViewController") as! CPMenuViewController
        
        let MenuViewController1 : CPLogedOutMenuViewController = storyboard.instantiateViewController(withIdentifier: "CPLogedOutMenuViewController") as! CPLogedOutMenuViewController
        
        if (x == "logedin") {
            
            
            MenuViewController.modalPresentationStyle = .overCurrentContext
            MenuViewController.transitioningDelegate = self
            let currentController = self.getCurrentViewController()
            currentController?.present(MenuViewController, animated: true, completion: nil)
            //present(MenuViewController, animated: true)
            
        } else if (x == "logedout") {
            
            
            MenuViewController1.modalPresentationStyle = .overCurrentContext
            MenuViewController1.transitioningDelegate = self
            let currentController = self.getCurrentViewController()
            currentController?.present(MenuViewController1, animated: true, completion: nil)
            
        }
        
    }
    
    
    func getCurrentViewController() -> UIViewController? {
        
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while( currentController.presentedViewController != nil ) {
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
        
    }
    
}


extension CPTopNavigator : UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        Transition.IsPresenting = true
        return Transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        Transition.IsPresenting = false
        return Transition
    }
    
}
