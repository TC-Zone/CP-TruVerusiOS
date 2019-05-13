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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSlideMenuButton()
        addSlideSearchButton()
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
