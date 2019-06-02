//
//  CPLoginViewController.swift
//  Truverus
//
//  Created by User on 30/4/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import ObjectMapper
import SVProgressHUD

class CPLoginViewController: UIViewController, UITextFieldDelegate, GIDSignInDelegate, GIDSignInUIDelegate {
    
    var dataSourceArray = [googleUserResponse]()
    let defaults = UserDefaults.standard

    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var CheckBox: UIButton!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var btnCreateAccount: UIButton!
    
    var idToken : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        InitTextFields()
        ScrollView.validateScrolling(view: ScrollView)
        CreateButton()
        settextDelegates()
        checkSavedTokensInDefaults()
        // Do any additional setup after loading the view.
    }
  
    
    func InitTextFields(){
        
        let common = CPcommon()
        common.CreateTextFields(TextField: EmailTextField, img: UIImage(named: "email")!)
        common.CreateTextFields(TextField: PasswordTextField, img: UIImage(named: "passwordtextfield")!)
        
    }
    
    
    

    
    @IBAction func CheckBoxAction(_ sender: Any) {
        
        if (CheckBox.imageView?.image == UIImage(named: "uncheck")) {
            CheckBox.setImage(UIImage(named: "checkbox"), for: .normal)
        } else {
            CheckBox.setImage(UIImage(named: "uncheck"), for: .normal)
        }
        
    }
    
    func CreateButton(){
        
        btnCreateAccount.backgroundColor = .clear
        btnCreateAccount.layer.cornerRadius = 20
        btnCreateAccount.layer.borderWidth = 1
        btnCreateAccount.layer.borderColor = UIColor.black.cgColor
        
    }
    
    
    @IBAction func ForgotPasswordButtonAction(_ sender: Any) {
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
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.state = "logedin"
                CPSocialSignInHelper.fetchProfile()
                self.back()
            }
        }
        
    }
    
    @IBAction func GoogleSignInButtonAction(_ sender: Any) {
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
        
        
    }
    
    @IBAction func SignInButtonAction(_ sender: Any) {
    }
    
    
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        
        if error != nil {
            print(error as Any)
        }
        else {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.state = "logedin"
            if let gmailuser = user{
                print("username : \(String(describing: gmailuser.profile.name))")
            }
            let accessToken = GIDSignIn.sharedInstance().currentUser.authentication.accessToken
            print("Access Token IS +++++++++++========== : \(String(describing: accessToken))")
            idToken = user.authentication.idToken
            print("user id token :: \(String(describing: idToken))")
            
            let fullName = user.profile.name
            //            let givenName = user.profile.givenName
            //            let familyName = user.profile.familyName
            let email = user.profile.email
            
            print("fullname :: \(String(describing: fullName))")
            print("email :: \(String(describing: email))")
            
            if (user.profile.hasImage) {
                let imageUrl = user.profile.imageURL(withDimension: 75)
                print (imageUrl!)
                
                
                StructProfile.ProfilePicture.ProfilePicURL = imageUrl!.absoluteString
                
                PercistanceService.deleteAllRecords()
                
                let googlesignuser = User(context: PercistanceService.context)
                
                
                googlesignuser.profilepictureurl = imageUrl!.absoluteString
                googlesignuser.name = fullName!
                googlesignuser.email = email!
                PercistanceService.saveContext()
                
            }
            
            StructProfile.ProfilePicture.email = email!
            StructProfile.ProfilePicture.name = fullName!
            StructGoogleProfile.GoogleProfileData.email = email!
            StructGoogleProfile.GoogleProfileData.name = fullName!
            
            getGoogleUser()
            
            back()
            
        }
    }
    
    func handleWebServiceData () {
        
        defaults.set(dataSourceArray[0].response?.access_token, forKey: keys.accesstoken)
        defaults.set(dataSourceArray[0].response?.refresh_token, forKey: keys.refreshtoken)
        
    }
    
    func checkSavedTokensInDefaults() {
        
        let refreshtoken = defaults.value(forKey: keys.refreshtoken)
        
        
        if refreshtoken != nil {
            print("saved refresh token in defaults is :: \(String(describing: refreshtoken) )")
            print("access  token in defaults is :: \(String(describing: defaults.value(forKey: keys.accesstoken)))")
        } else {
            
            print("no saved token yet")
        }
        
    }
    
    func settextDelegates() {
        
        EmailTextField.delegate = self
        PasswordTextField.delegate = self
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        EmailTextField.resignFirstResponder()
        PasswordTextField.resignFirstResponder()
        
        return true
    }
    
   
    func back(){
        
        
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : ViewController = storyboard.instantiateViewController(withIdentifier: "MainView") as! ViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
        
//        UIApplication.shared.keyWindow?.setRootViewController(vc, options: .init(direction: .toLeft, style: .easeIn))
        
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


extension CPLoginViewController{
    private func getGoogleUser(){
        SVProgressHUD.show()
        
        let headers: [String: String] = [:]
        
        let url = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.SOCIAL_USER_SIGN_IN) as String
        
        print("url is :: \(url)")
        let parameters : [String :Any] = ["code" : idToken as Any, "authProvider" : "google"]
        
        if let url = URL(string: url) {
            ApiManager.shared().makeRequestAlamofire(route: url, method: .post, autherized: true, parameter: parameters, header: headers){ (response) in
                SVProgressHUD.dismiss()
                switch response{
                case let .success(data):
                    self.serializeCheckUserStatusResponse(data: data)
                    print("hereee")
                    print(response)
                case .failure(_):
                    print("fail")
                }
            }
        }
    }
    
    func serializeCheckUserStatusResponse(data: Data) {
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            print("data in response :: \(json)")
            guard let loginResponse: googleUserResponse = Mapper<googleUserResponse>().map(JSONObject: json) else {
                return
            }
            self.dataSourceArray = [loginResponse]
            
            self.handleWebServiceData()
            
            //            customerID = loginResponse.subscriberBean?.subscriberId
            //            self.rssSubscrib()
        }catch {
            print(error)
        }
    }
}
