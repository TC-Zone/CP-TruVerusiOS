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
        
        hideLabels()
        hideBurrons()
        
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
        
        self.button.layer.addSublayer(setGradiants(gradian: ButtonGradient))

        
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
            
            sender.layer.addSublayer(setGradiants(gradian: signinButtonGradiant))
            
            let image = UIImage(named: "signInIcon") as UIImage?
            sender.addSubview(setImageView(img: image!, btn: sender))
            
            signinLabel.frame.size = CGSize(width: 40, height: 10)
            signinLabel.layer.masksToBounds = true
            signinLabel.center = CGPoint(x: UIScreen.main.bounds.width / 2, y:
                UIScreen.main.bounds.height - 70)
            signinLabel.text = "Sign In"
            signinLabel.font = UIFont.systemFont(ofSize: 9)
            signinLabel.textColor = UIColor(named: "PlusButtonLightPurple")
            view.addSubview(signinLabel)
        }
        else if (sender == nfcbutton) {
            
            sender.layer.addSublayer(setGradiants(gradian: NfcButtonGradiant))
            
            let image = UIImage(named: "nfcIcon") as UIImage?
            sender.addSubview(setImageView(img: image!, btn: sender))
            
            nfcLabel.frame.size = CGSize(width: 80, height: 30)
            nfcLabel.layer.masksToBounds = true
            nfcLabel.center = CGPoint(x: UIScreen.main.bounds.width / 2, y:
                UIScreen.main.bounds.height - 70)
            nfcLabel.text = "NFC Scan"
            nfcLabel.font = UIFont.systemFont(ofSize: 9)
            nfcLabel.textColor = UIColor(named: "PlusButtonLightPurple")
            view.addSubview(nfcLabel)
            
        } else if (sender == signupbutton) {
            
            sender.layer.addSublayer(setGradiants(gradian: signUpButtonGradiant))
            
            let image = UIImage(named: "signUpIcon") as UIImage?
            sender.addSubview(setImageView(img: image!, btn: sender))
            
            signupLabel.frame.size = CGSize(width: 40, height: 10)
            //signupLabel.layer.masksToBounds = true
            signupLabel.center = CGPoint(x: UIScreen.main.bounds.width / 2, y:
                UIScreen.main.bounds.height - 70)
            
            //signupLabel.font = UIFont(name:"AvenirNextLTPro", size: 1)
            signupLabel.font = UIFont.systemFont(ofSize: 9)
            signupLabel.text = "Sign Up"
            signupLabel.textColor = UIColor(named: "PlusButtonLightPurple")
            view.addSubview(signupLabel)
            
            
        }
        
       
        self.view.addSubview(sender)
        self.view.bringSubviewToFront(sender)
  
    }
    
    func setGradiants(gradian : CAGradientLayer) -> CAGradientLayer {
        
        gradian.colors = [ UIColor(named: "PlisButtonDarkPurple")?.cgColor as Any , UIColor(named: "PlusButtonLightPurple")?.cgColor as Any]
        gradian.startPoint = CGPoint(x: 0, y: 0.5)
        gradian.endPoint = CGPoint(x: 0.15, y: 0.5)
        gradian.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        
        return gradian
    }
    
    func setImageView(img : UIImage,btn : UIButton) -> UIImageView{
        
        let imageView = UIImageView(image: img)
        imageView.frame = CGRect(x: ( btn.bounds.size.width)/4,
                                 y: ( btn.bounds.size.width)/4,
                                 width: ( btn.bounds.size.width)/2,
                                 height: ( btn.bounds.size.width)/2 )
        
        return imageView
    }
    
    @objc func pressed(sender: UIButton!) {

        if (bRec == true){
            bRec = false
            print("expand")
            
            UIView.animate(withDuration: 0.3, animations:{
                
                self.signinButton.center = CGPoint(x: (UIScreen.main.bounds.width / 2) - 85, y:
                    UIScreen.main.bounds.height - 125)
                self.signinLabel.center = CGPoint(x: (UIScreen.main.bounds.width / 2) - 81, y:
                    UIScreen.main.bounds.height - 95)
                
            })
            UIView.animate(withDuration: 0.5, animations:{
                
                self.nfcbutton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y:
                    UIScreen.main.bounds.height - 175)
                self.nfcLabel.center = CGPoint(x: (UIScreen.main.bounds.width / 2) + 18, y:
                    UIScreen.main.bounds.height - 143)
                
            })
            UIView.animate(withDuration: 0.7, animations:{
                
                self.signupbutton.center = CGPoint(x: (UIScreen.main.bounds.width/2) + 85, y:
                    UIScreen.main.bounds.height - 125)
                self.signupLabel.center = CGPoint(x: (UIScreen.main.bounds.width/2) + 84, y:
                    UIScreen.main.bounds.height - 95)
                
            })
            
            self.overlay.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)

            
            UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve, animations: {
               self.view.addSubview(self.overlay)
            })
           
            
            bringSubViewstoFront()
            visibleLabels()
            visibleBurrons()
            
            
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
            
            hideLabels()
            
            
        }



    }
    
    func bringSubViewstoFront() {
        
        view.bringSubviewToFront(signinButton)
        view.bringSubviewToFront(signinLabel)
        view.bringSubviewToFront(nfcbutton)
        view.bringSubviewToFront(nfcLabel)
        view.bringSubviewToFront(signupbutton)
        view.bringSubviewToFront(signupLabel)
        view.bringSubviewToFront(button)
        
    }
    
    func hideLabels() {
        
        signinLabel.isHidden = true
        nfcLabel.isHidden = true
        signupLabel.isHidden = true
        
    }
    
    func visibleLabels() {
        
        signinLabel.isHidden = false
        nfcLabel.isHidden = false
        signupLabel.isHidden = false
        
    }
    
    func hideBurrons () {
        
        signinButton.isHidden = true
        nfcbutton.isHidden = true
        signupbutton.isHidden = true
        
    }
    
    func visibleBurrons () {
        
        signinButton.isHidden = false
        nfcbutton.isHidden = false
        signupbutton.isHidden = false
        
    }
    
    
}
