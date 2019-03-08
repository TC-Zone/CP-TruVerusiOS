//
//  CPSignUpViewController.swift
//  ClearPicture
//
//  Created by pasan vimukthi wijesuriya on 3/4/19.
//  Copyright © 2019 Trumpcode. All rights reserved.
//

import UIKit
import GoogleSignIn
import GoogleToolboxForMac
import FBSDKLoginKit
import FBSDKCoreKit

class CPSignUpViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate{
    
    
    
    
    
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var MiddleView: UIView!
    @IBOutlet weak var UserNameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var ReEnterPasswordTextField: UITextField!
    @IBOutlet weak var SignUpButton: UIButton!
    @IBOutlet weak var BackButton: UIButton!
    @IBOutlet weak var GoogleButton: UIButton!
    @IBOutlet weak var FacebookButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        initializeFirstView()
        ScrollView.validateScrolling(view: ScrollView)
        MiddleView.setUiViewShadows(view: MiddleView)
        InitTextFields()
       
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        
        
        
        let ActionGradiant = CAGradientLayer()
        
        ActionGradiant.colors = [ UIColor(named: "PlisButtonDarkPurple")?.cgColor as Any , UIColor(named: "PlusButtonLightPurple")?.cgColor as Any]
        ActionGradiant.startPoint = CGPoint(x: 0, y: 0.5)
        ActionGradiant.endPoint = CGPoint(x: 0.5, y: 0.5)
        ActionGradiant.frame = CGRect(x: 0, y: 0, width: SignUpButton.frame.width, height: SignUpButton.frame.height)
        ActionGradiant.cornerRadius = 23
        
        SignUpButton.layer.cornerRadius = 23
        SignUpButton.layer.addSublayer(ActionGradiant)
        
//        SignUpButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
//        SignUpButton.titleLabel?.font = UIFont(name: "AvenirNextLTPro-Demi", size: 15)
//        SignUpButton.titleLabel?.textColor = UIColor.white
//
//        SignUpButton.setTitle("Sign Up", for: UIControl.State.normal)
        SignUpButton.bringSubviewToFront(SignUpButton.titleLabel!)
        
    }
    
    func InitTextFields(){
        CreateTextFields(TextField: UserNameTextField, img: UIImage(named: "UserName")!)
        CreateTextFields(TextField: EmailTextField, img: UIImage(named: "EmailIcon")!)
        CreateTextFields(TextField: PasswordTextField, img: UIImage(named: "PasswordIcon")!)
        CreateTextFields(TextField: ReEnterPasswordTextField, img: UIImage(named: "PasswordIcon")!)
    }

    func CreateTextFields(TextField : UITextField , img : UIImage) {
        
        let ImgView = UIImageView(frame: CGRect(x: 5.0, y: 0.0, width: img.size.width, height: img.size.height))
        ImgView.image = img
        
        let leftView = UIView()
        leftView.addSubview(ImgView)
        
        leftView.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
        ImgView.frame = CGRect(x: 11, y: 0, width: 15, height: 15)
        
        TextField.leftView = leftView
        TextField.leftViewMode = .always
        
        TextField.layer.borderColor = UIColor(named: "ShadedLightBlue")?.cgColor
        TextField.layer.borderWidth = 1.0
        TextField.layer.cornerRadius = 23
        
    }
    
    func initializeFirstView() {
        if GIDSignIn.sharedInstance().hasAuthInKeychain(){

            print("signed in")
            tabBarController?.selectedIndex = 2

        } else{
            print("not signed in")
        }
    }
    
    
    
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
  
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print(error)
        }
        else {
            
            if let gmailuser = user{
                print("username : \(String(describing: gmailuser.profile.name))")
                tabBarController?.selectedIndex = 1
            }
            
        }
    }
    

    @IBAction func SignUpButtonAction(_ sender: Any) {
    }
    
    
    @IBAction func BackButtonAction(_ sender: Any) {
        
        if FBSDKAccessToken.current() != nil {
            print("user is already logged in using facebook")
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
        }
        else {
            print("user is not logged in using facebook")
        }
        
        tabBarController?.selectedIndex = 1
        
    }
    
    
    @IBAction func GoogleSignInButtonAction(_ sender: Any) {
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
        
    }
    
    @IBAction func FacebookSignInButtonAction(_ sender: Any) {
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        if Float(UIDevice.current.systemVersion) ?? 0.0 <= 9 {
            fbLoginManager.loginBehavior = FBSDKLoginBehavior.systemAccount
        } else {
            fbLoginManager.loginBehavior = FBSDKLoginBehavior.web
        }
        
        fbLoginManager.logIn(withReadPermissions: ["public_profile","email"], from: self) {
            (result, error) -> Void in
            if error != nil {
                print(error!.localizedDescription)
                self.dismiss(animated: true, completion: nil)
            } else if (result?.isCancelled)! {
                print("Cancelled")
                self.dismiss(animated: true, completion: nil)
            } else {
                
                self.fetchProfile()
                
            }
        }
        
    }
    
    func fetchProfile() {
        let parameters = ["fields": "first_name, email, last_name, picture"]
        
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start(completionHandler: { (connection, user, requestError) -> Void in
            
            if requestError != nil {
                print("----------ERROR-----------")
                print(requestError!)
                return
            }
            let userData = user as! NSDictionary
            let email = userData["email"] as? String
            print("fb profile email : \(String(describing: email))")
            let firstName = userData["first_name"] as? String
            print("fb profile first name : \(String(describing: firstName))")
            let lastName = userData["last_name"] as? String
            print("fb profile last name : \(String(describing: lastName))")
            var pictureUrl = ""
            if let picture = userData["picture"] as? NSDictionary, let data = picture["data"] as? NSDictionary, let url = data["url"] as? String {
                pictureUrl = url
                print(pictureUrl)
            }
        })
    }
    
    @IBAction func SignInButtonAction(_ sender: Any) {
       
        GIDSignIn.sharedInstance().disconnect()
        
    }
    
}
