//
//  CPHomeViewController.swift
//  Truverus
//
//  Created by User on 30/4/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPHomeViewController: BaseViewController {

    @IBOutlet weak var segmentController: CPCustomSegmentedControll!
    @IBOutlet weak var ProductContainer: UIView!
    @IBOutlet weak var CollectionContainer: UIView!
    
    let Transition = CPSlideInTransition()
    var callingFrom : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentController.buttonTapped(button: segmentController.buttons.last!)
        if callingFrom == "MCOL" {
            
            CollectionContainer.alpha = 1
            ProductContainer.alpha = 0
            ShowSlideInSearchButton()
            segmentController.buttonTapped(button: segmentController.buttons.last!)
           
            
        } else if callingFrom == "PRO" {
            
            segmentController.isHidden = false
            ProductContainer.alpha = 1
            CollectionContainer.alpha = 0
            segmentController.buttonTapped(button: segmentController.buttons.first!)
            
        } 
        
        addSlideMenuButton()
        addSlideSearchButton()
        validateSelectedIndex()
        
        
    }
    
    func validateSelectedIndex() {
        
        if segmentController.selectedSegmentIndex == 0 {
            RemoveSlideInSearchButton()
        } else {
            ShowSlideInSearchButton()
        }
        
    }
    
    
    @IBAction func SelectionChanged(_ sender: CPCustomSegmentedControll) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("default home screen")
            ProductContainer.alpha = 1
            CollectionContainer.alpha = 0
            RemoveSlideInSearchButton()
        case 1:
            print("My collection")
            CollectionContainer.alpha = 1
            ProductContainer.alpha = 0
            ShowSlideInSearchButton()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadProductsFromAPI"), object: nil)
        default:
            print("nothing in switch")
        }
        
    }
 
    
}




extension CPHomeViewController : UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        Transition.IsPresenting = true
        return Transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        Transition.IsPresenting = false
        return Transition
    }
    
}
