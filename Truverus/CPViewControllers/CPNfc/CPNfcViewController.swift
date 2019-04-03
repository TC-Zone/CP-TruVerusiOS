//
//  CPNfcViewController.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 3/29/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPNfcViewController: UIViewController {

    let Transition = CPSlideInTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func MenuButtonAction(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let x = appDelegate.state
        
        print("state is ::: \(x)")
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let MenuViewController : CPMenuViewController = storyboard.instantiateViewController(withIdentifier: "CPMenuViewController") as! CPMenuViewController
        
        let MenuViewController1 : CPLogedOutMenuViewController = storyboard.instantiateViewController(withIdentifier: "CPLogedOutMenuViewController") as! CPLogedOutMenuViewController
        
        if (x == "logedin") {
            
            
            MenuViewController.modalPresentationStyle = .overCurrentContext
            MenuViewController.transitioningDelegate = self
            present(MenuViewController, animated: true)
            
        } else if (x == "logedout") {
            
            
            MenuViewController1.modalPresentationStyle = .overCurrentContext
            MenuViewController1.transitioningDelegate = self
            present(MenuViewController1, animated: true)
            
        }
        
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

extension CPNfcViewController : UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        Transition.IsPresenting = true
        return Transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        Transition.IsPresenting = false
        return Transition
    }
    
}
