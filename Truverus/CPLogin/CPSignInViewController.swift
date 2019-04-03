//
//  CPSignInViewController.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 3/25/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import CoreData
import GoogleSignIn

class CPSignInViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var CreateAccountButton: UIButton!
    @IBOutlet weak var SignInButton: UIButton!
    @IBOutlet weak var forgotPassword: UIButton!
    @IBOutlet weak var CheckBox: UIButton!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var EmailText: UITextField!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var headerNavigation: CPCommonLoginHeaderNavigationViewController!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollview.validateScrolling(view: scrollview)
        headerNavigation.headerLable.text = "LOGIN"
        headerNavigation.backButton.addTarget(self, action: #selector(BackButtonAction), for: .touchUpInside)
        InitTextFields()
        CreateButton()
    }
   
    
    @IBAction func SignInAction(_ sender: Any) {
    }
    
    
    @IBAction func CreateAccountAction(_ sender: Any) {
    }
    
    
    @IBAction func FacebookAction(_ sender: Any) {
        
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
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.state = "logedin"
                CPSocialSignInManager.fetchProfile()
                self.back()
            }
        }

        
    }
    
    @IBAction func googleAction(_ sender: Any) {
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
//
//        let googleLogin = CPSocialSignInManager(view: self)
//        googleLogin.login()
//
//        back()
        
        
    }
    
    @IBAction func checkboxRemember(_ sender: Any) {
        
        if (CheckBox.imageView?.image == UIImage(named: "uncheck")) {
            CheckBox.setImage(UIImage(named: "checkbox"), for: .normal)
        } else {
            CheckBox.setImage(UIImage(named: "uncheck"), for: .normal)
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

            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.state = "logedin"
            if let gmailuser = user{
                print("username : \(String(describing: gmailuser.profile.name))")
            }
            let accessToken = GIDSignIn.sharedInstance().currentUser.authentication.accessToken
            print("Access Token IS +++++++++++========== : \(String(describing: accessToken))")
            let idToken = user.authentication.idToken
            print("user id token :: \(String(describing: idToken))")

            let fullName = user.profile.name
//            let givenName = user.profile.givenName
//            let familyName = user.profile.familyName
            let email = user.profile.email
            if (user.profile.hasImage) {
                let imageUrl = user.profile.imageURL(withDimension: 75)
                print (imageUrl!)


                StructProfile.ProfilePicture.ProfilePicURL = imageUrl!.absoluteString

                PercistanceService.deleteAllRecords()

                let googlesignuser = User(context: PercistanceService.context)


                   googlesignuser.profileimageurl = imageUrl!.absoluteString
                   googlesignuser.name = fullName!
                   googlesignuser.email = email!
                   PercistanceService.saveContext()

            }

            StructProfile.ProfilePicture.email = email!
            StructProfile.ProfilePicture.name = fullName!
            StructGoogleProfile.GoogleProfileData.email = email!
            StructGoogleProfile.GoogleProfileData.name = fullName!

            back()

        }
    }
    
    @objc private func BackButtonAction () {

        back()
        
        
    }
    
    func back(){
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : CPHomeScreenViewController = storyboard.instantiateViewController(withIdentifier: "CPHomeScreenViewController") as! CPHomeScreenViewController
        
        
        UIApplication.shared.keyWindow?.setRootViewController(vc, options: .init(direction: .toLeft, style: .easeIn))
        
    }
    
    func InitTextFields(){
        CreateTextFields(TextField: EmailText, img: UIImage(named: "email")!)
        CreateTextFields(TextField: passwordText, img: UIImage(named: "passwordtextfield")!)
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
    
    func CreateButton(){
        
        SignInButton.layer.cornerRadius = 20
        CreateAccountButton.backgroundColor = .clear
        CreateAccountButton.layer.cornerRadius = 20
        CreateAccountButton.layer.borderWidth = 1
        CreateAccountButton.layer.borderColor = UIColor.black.cgColor
        
    }


}


