//
//  BaseViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, SlideMenuDelegate {
    
    //let btnMenuSearch = UIButton(type: UIButton.ButtonType.system)
    
    let btnMenuSearch: UIButton = {
        let b = UIButton(type: UIButton.ButtonType.system)
        b.setImage(UIImage(named: "search"), for: .normal)
        b.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        b.addTarget(self, action: #selector(BaseViewController.onMenuSearchTapped(_:)), for: UIControl.Event.touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func slideMenuItemSelectedAtIndex(_ index: Int32) {
        let topViewController : UIViewController = self.navigationController!.topViewController!
        print("View Controller is : \(topViewController) \n", terminator: "")
        switch(index){
        case 0:
            print("Home\n", terminator: "")

            self.openViewControllerBasedOnIdentifier("Home")
            
            break
        case 1:
            print("Play\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("PlayVC")
            
            break
        default:
            print("default\n", terminator: "")
        }
    }
    
    func openViewControllerBasedOnIdentifier(_ strIdentifier:String){
        let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: strIdentifier)
        
        let topViewController : UIViewController = self.navigationController!.topViewController!
        
        if (topViewController.restorationIdentifier! == destViewController.restorationIdentifier!){
            print("Same VC")
        } else {
            self.navigationController!.pushViewController(destViewController, animated: true)
        }
    }
    
    func addSlideMenuButton(){
        let btnShowMenu = UIButton(type: UIButton.ButtonType.system)
        btnShowMenu.setImage(self.defaultMenuImage(), for: UIControl.State())
        btnShowMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnShowMenu.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        self.navigationItem.leftBarButtonItem = customBarItem;
    }
    
    func addSlideSearchButton() {
        
        let customBarItem = UIBarButtonItem(customView: btnMenuSearch)
        self.navigationItem.rightBarButtonItem = customBarItem;
        
    }
    
    func RemoveSlideInSearchButton() {
        UIView.animate(withDuration: 0.2) {
            self.navigationItem.rightBarButtonItem?.customView?.alpha = 0
        }
    }
    
    func ShowSlideInSearchButton() {
        UIView.animate(withDuration: 0.3) {
            self.navigationItem.rightBarButtonItem?.customView?.alpha = 1
        }
    }
    
    
    @objc func onMenuSearchTapped(_ sender : UIButton) {
    
        print("search tapped")
    
    }
    

    func defaultMenuImage() -> UIImage {
        var defaultMenuImage = UIImage()
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 30, height: 22), false, 0.0)
        
        UIColor.black.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 3, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 10, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 17, width: 30, height: 1)).fill()
        
        UIColor.white.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 4, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 11,  width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 18, width: 30, height: 1)).fill()
        
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
       
        return defaultMenuImage;
    }
    
    @objc func onSlideMenuButtonPressed(_ sender : UIButton){
        if (sender.tag == 10)
        {
            // To Hide Menu If it already there
            self.slideMenuItemSelectedAtIndex(-1);
            
            sender.tag = 0;
            
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                viewMenuBack.removeFromSuperview()
                
            })
            
            return
        }
        
        sender.isEnabled = false
        sender.tag = 10
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "CPMenuView", bundle: nil)
        let menuVC : CPMenuViewController = storyBoard.instantiateViewController(withIdentifier: "CPMenuView") as! CPMenuViewController
        menuVC.btnMenu = sender
        menuVC.modalPresentationStyle = .currentContext
        menuVC.delegate = self
        self.view.addSubview(menuVC.view)
        self.addChild(menuVC)
        menuVC.view.layoutIfNeeded()
        
        menuVC.btnCloseMenuOverlay.backgroundColor = UIColor(white: 0, alpha: 0.5)
        menuVC.btnCloseMenuOverlay.alpha = 0
        
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            //sender.isEnabled = true
            sender.isHidden = true
        }) { (finished) in
            
            UIView.animate(withDuration: 0.15, animations: {
                menuVC.btnCloseMenuOverlay.alpha = 1
            })
            
        }
        
        
    }
}
