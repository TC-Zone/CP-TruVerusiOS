//
//  UITabBarController.swift
//  ClearPicture
//
//  Created by pasan vimukthi wijesuriya on 2/25/19.
//  Copyright © 2019 Trumpcode. All rights reserved.
//

import UIKit

class CustomTabbarController: UITabBarController, UITabBarControllerDelegate {
    
    var bRec:Bool = true
    let layerGradient = CAGradientLayer()
    let buttonGradient = CAGradientLayer()
    let signinButton = UIButton.init(type: .custom)
    let nfcbutton = UIButton.init(type: .custom)
    let signupbutton = UIButton.init(type: .custom)
    let signinLabel = UILabel()
    let nfcLabel = UILabel()
    let signupLabel = UILabel()
   
    let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    //private var cachedSafeAreaInsets = UIEdgeInsets.zero
    
    private struct Constants {
        static let actionButtonSize = CGSize(width: 64, height: 64)
    }
    
    private let actionButton: UIButton = {
        
        let ActionGradiant = CAGradientLayer()
        
        
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 4
        button.layer.borderColor = UIColor.white.cgColor
        //button.backgroundColor = UIColor.darkGray
        button.layer.cornerRadius = Constants.actionButtonSize.height/2
        
        ActionGradiant.colors = [ UIColor(named: "PlisButtonDarkPurple")?.cgColor as Any , UIColor(named: "PlusButtonLightPurple")?.cgColor as Any]
        ActionGradiant.startPoint = CGPoint(x: 0, y: 0.5)
        ActionGradiant.endPoint = CGPoint(x: 0.7, y: 0.5)
        ActionGradiant.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        ActionGradiant.cornerRadius = Constants.actionButtonSize.height/2
        
        button.layer.addSublayer(ActionGradiant)
        
        let image = UIImage(named: "plusImage")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 15,
                                 y:  15,
                                 width:  34,
                                 height: 34)
        button.addSubview(imageView)
        button.bringSubviewToFront(imageView)
      
        button.addTarget(self, action: #selector(actionButtonTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeButtons(sender: signinButton)
        makeButtons(sender: nfcbutton)
        makeButtons(sender: signupbutton)
        
        hideLabels()
        hideBurrons()
        
        view.addSubview(actionButton)
        setupConstraints()
        
        //self.tabBarController?.tabBar.delegate = self
        layerGradient.colors = [ UIColor(named: "DarkBlue")?.cgColor as Any , UIColor(named: "LightBlue")?.cgColor as Any]
        layerGradient.startPoint = CGPoint(x: 0, y: 0.5)
        layerGradient.endPoint = CGPoint(x: 1, y: 0.5)
        layerGradient.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        //self.tabBar.layer.addSublayer(layerGradient)
        self.tabBar.layer.insertSublayer(layerGradient, at:0)
        self.tabBar.tintColor = UIColor.black
        self.tabBar.unselectedItemTintColor = UIColor.red
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        actionButton.isHidden = false
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
            
            sender.addTarget(self, action: #selector(SignUpButtonAction), for: .touchUpInside)
            
            
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
    
    private func setupConstraints() {
        actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        actionButton.widthAnchor.constraint(equalToConstant: Constants.actionButtonSize.width).isActive = true
        actionButton.heightAnchor.constraint(equalToConstant: Constants.actionButtonSize.height).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: tabBar.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    @objc private func actionButtonTapped(sender: UIButton) {
        print("Clicked")
        
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
                self.signupLabel.center = CGPoint(x: (UIScreen.main.bounds.width/2) + 86, y:
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
            print("fold back")
            
            FoldButtonsBack()
            
            hideLabels()
            
            
        }
        
    }
    
    
    func FoldButtonsBack(){
        bRec = true
        print("fold back")
        
        UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.overlay.removeFromSuperview()
        })
        
        UIView.animate(withDuration: 0.3, animations: {
            self.signinButton.center = self.actionButton.center
            self.signinLabel.center = self.actionButton.center
        })
        UIView.animate(withDuration: 0.5, animations: {
            self.nfcbutton.center = self.actionButton.center
            self.nfcLabel.center = self.actionButton.center
        })
        UIView.animate(withDuration: 0.7, animations: {
            self.signupbutton.center = self.actionButton.center
            self.signupLabel.center = self.actionButton.center
        })
    }
    
    func bringSubViewstoFront() {
        
        view.bringSubviewToFront(signinButton)
        view.bringSubviewToFront(signinLabel)
        view.bringSubviewToFront(nfcbutton)
        view.bringSubviewToFront(nfcLabel)
        view.bringSubviewToFront(signupbutton)
        view.bringSubviewToFront(signupLabel)
        view.bringSubviewToFront(actionButton)
        
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
    
    @objc private func SignUpButtonAction () {
//
//        let mainStoryBoard = UIStoryboard(name: "CPSignIn", bundle: Bundle.main)
//        let newViewController = mainStoryBoard.instantiateViewController(withIdentifier: "CPSignInViewController")
//        self.present(newViewController, animated: true, completion: nil)

         self.selectedIndex = 2
        FoldButtonsBack()
        
        
    }
    
    
}

