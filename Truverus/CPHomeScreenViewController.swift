//
//  CPHomeScreenViewController.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 3/25/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPHomeScreenViewController: UIViewController {
    
    @IBOutlet weak var segmentController: CPCustomSegmentedControll!
    @IBOutlet weak var ProductContainer: UIView!
    @IBOutlet weak var CollectionContainer: UIView!
    
    let Transition = CPSlideInTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        segmentController.isHidden = false
        ProductContainer.alpha = 1
        CollectionContainer.alpha = 0
        
    }
  
    @IBAction func SelectionChanged(_ sender: CPCustomSegmentedControll) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("default home screen")
            ProductContainer.alpha = 1
            CollectionContainer.alpha = 0
        case 1:
            print("My collection")
            CollectionContainer.alpha = 1
            ProductContainer.alpha = 0
        default:
            print("nothing in switch")
        }
        
    }
    
    @IBAction func MenuButtonAction(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let x = appDelegate.state
        
        print("state is ::: \(x)")
        
        if (x == "logedin") {
            
            guard let MenuViewController = storyboard?.instantiateViewController(withIdentifier: "CPMenuViewController") else {return}
            MenuViewController.modalPresentationStyle = .overCurrentContext
            MenuViewController.transitioningDelegate = self
            present(MenuViewController, animated: true)
            
        } else if (x == "logedout") {
            
            guard let MenuViewController = storyboard?.instantiateViewController(withIdentifier: "CPLogedOutMenuViewController") else {return}
            MenuViewController.modalPresentationStyle = .overCurrentContext
            MenuViewController.transitioningDelegate = self
            present(MenuViewController, animated: true)
            
        }
        
    }
    
    
    
    
}

extension CPHomeScreenViewController : UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        Transition.IsPresenting = true
        return Transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        Transition.IsPresenting = false
        return Transition
    }
    
}
