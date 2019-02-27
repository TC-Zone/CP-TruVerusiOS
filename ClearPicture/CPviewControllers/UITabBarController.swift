//
//  UITabBarController.swift
//  ClearPicture
//
//  Created by pasan vimukthi wijesuriya on 2/25/19.
//  Copyright © 2019 Trumpcode. All rights reserved.
//

import UIKit

class tabbarcontroller: UITabBarController {
    
    
    var bRec:Bool = true
    let button = UIButton.init(type: .custom)
    let signinButton = UIButton.init(type: .custom)
    let nfcbutton = UIButton.init(type: .custom)
    let signupbutton = UIButton.init(type: .custom)
    let layerGradient = CAGradientLayer()
    let ButtonGradient = CAGradientLayer()
    private var cachedSafeAreaInsets = UIEdgeInsets.zero
    let signinLabel = UILabel()
    let nfcLabel = UILabel()
    let signupLabel = UILabel()
    
    
    let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        makeButtons(sender: signinButton)
        makeButtons(sender: nfcbutton)
        makeButtons(sender: signupbutton)
        
        
        
        layerGradient.colors = [ UIColor(named: "DarkBlue")?.cgColor as Any , UIColor(named: "LightBlue")?.cgColor as Any]
        layerGradient.startPoint = CGPoint(x: 0, y: 0.5)
        layerGradient.endPoint = CGPoint(x: 1, y: 0.5)
        layerGradient.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        self.tabBar.layer.addSublayer(layerGradient)
        
        
        var safeAreaInsets: UIEdgeInsets {
            let insets = super.additionalSafeAreaInsets
            
            if insets.bottom < tabBar.bounds.height {
                cachedSafeAreaInsets = insets
                
            }
            
            return cachedSafeAreaInsets
        }
        
        self.tabBarController?.view.addSubview(button)
         button.addTarget(self, action: #selector(pressed(sender:)), for: .touchUpInside)
        
        addPhotoButton()
        
    }
    
    
    
    func addPhotoButton() {
        
        
        // Start of code to center button in the tab bar
        guard let tabItems = tabBar.items else { return }
        tabItems[0].titlePositionAdjustment = UIOffset(horizontal: -5, vertical: 0)
        tabItems[1].titlePositionAdjustment = UIOffset(horizontal: -30, vertical: 0)
        //tabItems[2].titlePositionAdjustment = UIOffset(horizontal: 30, vertical: 0)
        //tabItems[3].titlePositionAdjustment = UIOffset(horizontal: 5, vertical: 0)
        
        
        button.frame.size = CGSize(width: 70, height: 70)
        button.backgroundColor = .white
        button.layer.borderWidth = 4
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 35
        button.layer.masksToBounds = true
        button.center = CGPoint(x: UIScreen.main.bounds.width / 2, y:
            UIScreen.main.bounds.height - 40)
        
        ButtonGradient.colors = [ UIColor(named: "PlisButtonDarkPurple")?.cgColor as Any , UIColor(named: "PlusButtonLightPurple")?.cgColor as Any]
        ButtonGradient.startPoint = CGPoint(x: 0, y: 0.5)
        ButtonGradient.endPoint = CGPoint(x: 0.15, y: 0.5)
        ButtonGradient.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        self.button.layer.addSublayer(ButtonGradient)

        
        let heightDifference = button.frame.size.height - self.tabBar.frame.size.height
        
        let image = UIImage(named: "plusImage") as UIImage?
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: ( button.bounds.size.width)/4,
                                 y: ( button.bounds.size.width)/4,
                                 width: ( button.bounds.size.width)/2,
                                 height: ( button.bounds.size.width)/2 )
        button.addSubview(imageView)
        
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                
            case 1334:
                print("iPhone 6/6S/7/8")
                
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                var center = self.tabBar.center;
                center.y = center.y - heightDifference/2.0 - 5
                button.center = center;
                
            case 2436:
                print("iPhone X, XS")
                var center = self.tabBar.center;
                center.y = center.y - heightDifference/2.0 - 40
                button.center = center;
                
            case 2688:
                print("iPhone XS Max")
                var center = self.tabBar.center;
                center.y = center.y - heightDifference/2.0 - 40
                button.center = center;
                
            case 1792:
                print("iPhone XR")
                var center = self.tabBar.center;
                center.y = center.y - heightDifference/2.0 - 40
                button.center = center;
                
            default:
                print("Unknown")
            }
        }
        
        
        self.view.addSubview(button)
        self.view.bringSubviewToFront(button)
        
        
        
    }
    
    func makeButtons(sender: UIButton) {
        
        let signinButtonGradiant = CAGradientLayer()
        let NfcButtonGradiant = CAGradientLayer()
        let signUpButtonGradiant = CAGradientLayer()
        
        
        
        sender.frame.size = CGSize(width: 48, height: 48)
        sender.backgroundColor = .white
        sender.layer.borderWidth = 4
        sender.layer.borderColor = UIColor.white.cgColor
        sender.layer.cornerRadius = 24
        sender.layer.masksToBounds = true
        sender.center = CGPoint(x: UIScreen.main.bounds.width / 2, y:
            UIScreen.main.bounds.height - 70)
        
        if (sender == signinButton){
            signinButtonGradiant.colors = [ UIColor(named: "PlisButtonDarkPurple")?.cgColor as Any , UIColor(named: "PlusButtonLightPurple")?.cgColor as Any]
            signinButtonGradiant.startPoint = CGPoint(x: 0, y: 0.5)
            signinButtonGradiant.endPoint = CGPoint(x: 0.15, y: 0.5)
            signinButtonGradiant.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
            sender.layer.addSublayer(signinButtonGradiant)
            
            let image = UIImage(named: "signInIcon") as UIImage?
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: ( sender.bounds.size.width)/4,
                                     y: ( sender.bounds.size.width)/4,
                                     width: ( sender.bounds.size.width)/2,
                                     height: ( sender.bounds.size.width)/2 )
            sender.addSubview(imageView)
            
            signinLabel.frame.size = CGSize(width: 55, height: 30)
            signinLabel.layer.masksToBounds = true
            signinLabel.center = CGPoint(x: UIScreen.main.bounds.width / 2, y:
                UIScreen.main.bounds.height - 70)
            signinLabel.text = "Sign In"
            signinLabel.font = UIFont(name:"AvenirNextLTPro-Regular", size: 1.0)
            signinLabel.textColor = UIColor(named: "PlusButtonLightPurple")
            view.addSubview(signinLabel)
        }
        else if (sender == nfcbutton) {
            NfcButtonGradiant.colors = [ UIColor(named: "PlisButtonDarkPurple")?.cgColor as Any , UIColor(named: "PlusButtonLightPurple")?.cgColor as Any]
            NfcButtonGradiant.startPoint = CGPoint(x: 0, y: 0.5)
            NfcButtonGradiant.endPoint = CGPoint(x: 0.15, y: 0.5)
            NfcButtonGradiant.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
            sender.layer.addSublayer(NfcButtonGradiant)
            
            let image = UIImage(named: "nfcIcon") as UIImage?
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: ( sender.bounds.size.width)/4,
                                     y: ( sender.bounds.size.width)/4,
                                     width: ( sender.bounds.size.width)/2,
                                     height: ( sender.bounds.size.width)/2 )
            sender.addSubview(imageView)
            
            nfcLabel.frame.size = CGSize(width: 80, height: 30)
            nfcLabel.layer.masksToBounds = true
            nfcLabel.center = CGPoint(x: UIScreen.main.bounds.width / 2, y:
                UIScreen.main.bounds.height - 70)
            nfcLabel.text = "NFC Scan"
            nfcLabel.font = UIFont(name:"AvenirNextLTPro-Regular", size: 1.0)
            nfcLabel.textColor = UIColor(named: "PlusButtonLightPurple")
            view.addSubview(nfcLabel)
            
        } else if (sender == signupbutton) {
            signUpButtonGradiant.colors = [ UIColor(named: "PlisButtonDarkPurple")?.cgColor as Any , UIColor(named: "PlusButtonLightPurple")?.cgColor as Any]
            signUpButtonGradiant.startPoint = CGPoint(x: 0, y: 0.5)
            signUpButtonGradiant.endPoint = CGPoint(x: 0.15, y: 0.5)
            signUpButtonGradiant.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
            sender.layer.addSublayer(signUpButtonGradiant)
            
            let image = UIImage(named: "signUpIcon") as UIImage?
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: ( sender.bounds.size.width)/4,
                                     y: ( sender.bounds.size.width)/4,
                                     width: ( sender.bounds.size.width)/2,
                                     height: ( sender.bounds.size.width)/2 )
            sender.addSubview(imageView)
            
            signupLabel.frame.size = CGSize(width: 62, height: 20)
            //signupLabel.layer.masksToBounds = true
            signupLabel.center = CGPoint(x: UIScreen.main.bounds.width / 2, y:
                UIScreen.main.bounds.height - 70)
            signupLabel.font = UIFont(name:"AvenirNextLTPro", size: 5)
            signupLabel.text = "Sign Up"
            signupLabel.textColor = UIColor(named: "PlusButtonLightPurple")
            view.addSubview(signupLabel)
            
            
        }
        
       
        self.view.addSubview(sender)
        self.view.bringSubviewToFront(sender)
  
    }
    
    
    @objc func pressed(sender: UIButton!) {

        if (bRec == true){
            bRec = false
            print("expand")
            
            UIView.animate(withDuration: 0.3, animations:{
                
                self.signinButton.center = CGPoint(x: (UIScreen.main.bounds.width / 2) - 85, y:
                    UIScreen.main.bounds.height - 125)
                self.signinLabel.center = CGPoint(x: (UIScreen.main.bounds.width / 2) - 85, y:
                    UIScreen.main.bounds.height - 90)
                
            })
            UIView.animate(withDuration: 0.5, animations:{
                
                self.nfcbutton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y:
                    UIScreen.main.bounds.height - 175)
                self.nfcLabel.center = CGPoint(x: UIScreen.main.bounds.width / 2, y:
                    UIScreen.main.bounds.height - 133)
                
            })
            UIView.animate(withDuration: 0.7, animations:{
                
                self.signupbutton.center = CGPoint(x: (UIScreen.main.bounds.width/2) + 85, y:
                    UIScreen.main.bounds.height - 125)
                self.signupLabel.center = CGPoint(x: (UIScreen.main.bounds.width/2) + 85, y:
                    UIScreen.main.bounds.height - 90)
                
            })
            
            self.overlay.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)

            
            UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve, animations: {
               self.view.addSubview(self.overlay)
            })
           
            view.bringSubviewToFront(signinButton)
            view.bringSubviewToFront(signinLabel)
            view.bringSubviewToFront(nfcbutton)
            view.bringSubviewToFront(nfcLabel)
            view.bringSubviewToFront(signupbutton)
            view.bringSubviewToFront(signupLabel)
            view.bringSubviewToFront(button)
            
        } else {
            bRec = true
            print("fold back")
            
            UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve, animations: {
                 self.overlay.removeFromSuperview()
            })
            
            UIView.animate(withDuration: 0.3, animations: {
                self.signinButton.center = self.button.center
                self.signinLabel.center = self.button.center
            })
            UIView.animate(withDuration: 0.5, animations: {
                self.nfcbutton.center = self.button.center
                self.nfcLabel.center = self.button.center
            })
            UIView.animate(withDuration: 0.7, animations: {
                self.signupbutton.center = self.button.center
                self.signupLabel.center = self.button.center
            })
            
        }



    }
    
   
    
}
