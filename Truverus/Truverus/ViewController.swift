//
//  ViewController.swift
//  Truverus
//
//  Created by User on 30/4/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {

    
//    let Transition = CPSlideInTransition()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSlideMenuButton()
        
//        let storyBoard: UIStoryboard = UIStoryboard(name: "CPLogin", bundle: nil)
//        let newViewController = storyBoard.instantiateViewController(withIdentifier: "CPLoginView") as! CPLoginViewController
//        self.navigationController?.pushViewController(newViewController, animated: true)
        
    }

    @IBAction func button(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "CPLogin", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "CPLoginView") as! CPLoginViewController
        //self.present(newViewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(newViewController, animated: true)
        
    }
    
//    @IBAction func MenUButtonAction(_ sender: Any) {
//
//        let storyboard : UIStoryboard = UIStoryboard(name: "CPMenuView", bundle: nil)
//        let MenuViewController : CPMenuViewController = storyboard.instantiateViewController(withIdentifier: "CPMenuView") as! CPMenuViewController
//        MenuViewController.modalPresentationStyle = .overCurrentContext
//        MenuViewController.transitioningDelegate = self
//        let currentController = self.getCurrentViewController()
//        currentController?.present(MenuViewController, animated: true, completion: nil)
//
//    }
    
  
//    func getCurrentViewController() -> UIViewController? {
//
//        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
//            var currentController: UIViewController! = rootController
//            while( currentController.presentedViewController != nil ) {
//                currentController = currentController.presentedViewController
//            }
//            return currentController
//        }
//        return nil
//
//    }
    
}


//extension ViewController : UIViewControllerTransitioningDelegate {
//
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        Transition.IsPresenting = true
//        return Transition
//    }
//
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        Transition.IsPresenting = false
//        return Transition
//    }
//
//}


