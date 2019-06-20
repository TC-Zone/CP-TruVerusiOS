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
        //ScrollView.validateScrolling(view: ScrollView)
        CreateButton()
        settextDelegates()
        checkSavedTokensInDefaults()
        self.HideKeyboardWhenTappedAround()
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
        
        if EmailTextField.text?.isEmpty != true && isValidEmail(email: EmailTextField.text ?? "") {
            if PasswordTextField.text?.isEmpty != true {
                
                getLoggedInUser(email: EmailTextField.text!, password: PasswordTextField.text!)
                
            } else {
                
                showValidationAlerts(message: "Please check password.")
                
            }
            
        } else {
            
            showerrormessage(messege: "Please check your email address")
            
        }
        
        
    }
    
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
   
    
    func showValidationAlerts(message : String) {
        
        let alert = UIAlertController(title: "Sorry!", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
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
        
        
        
        let story = UIStoryboard.init(name: "CPHomeView", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "CPHomeView") as! CPHomeViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
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
            defaults.set(nil, forKey: keys.RegisteredUserID)
            StructProductRelatedData.purchaseAvailability = false
            
            self.handleWebServiceData()
            
        }catch {
            print(error)
        }
    }
    
    
    
    private func getLoggedInUser(email : String, password : String){
        
        
        SVProgressHUD.show()
        ApiManager.shared().logInUser(usernameinput: email, passwordinput: password) { (response) in
            switch response {
            case let .success(data):
                SVProgressHUD.dismiss()
                self.serializeUserLoginResponse(data: data)
                print(response)
            case .failure(let error):
                print("error in retrieving new access token :: \(error)")
                if error.statusCode == 400 {
                    let alert = UIAlertController(title: "Sorry!", message: "Please try again. something went wrong", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    
    func serializeUserLoginResponse(data: Data) {
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            print("data in response :: \(json)")
            guard let userloginResponse: UserLoginData = Mapper<UserLoginData>().map(JSONObject: json) else {
                return
            }
            
            print("user login response is :: \(userloginResponse)")
            
            if userloginResponse.access_token == nil || userloginResponse.access_token == "" {
                
                guard let userloginErrorResponse: loginErrorDataMap = Mapper<loginErrorDataMap>().map(JSONObject: json) else {
                    return
                }
                
                print("loginerror map :: \(userloginErrorResponse)")
                
                if userloginErrorResponse.error_description == "Bad credentials" {
                    
                    showerrormessage(messege: "Invalid Credentials, please try again")
                    
                } else if userloginErrorResponse.error_description == "User account is locked" {
                    
                    //showerrormessage(messege: "Your account is locked, verify your account")
                    
                    let alertController = UIAlertController(title: "Sorry!", message: "Your account is locked, verify your account", preferredStyle: .alert)
                    
                    // Create the actions
                    let okAction = UIAlertAction(title: "Vefify", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        NSLog("OK Pressed")
                        let storyboard : UIStoryboard = UIStoryboard(name: "CPLogin", bundle: nil)
                        let vc : CPVerifyEmailViewController = storyboard.instantiateViewController(withIdentifier: "verifyemailscreen") as! CPVerifyEmailViewController
                        self.dismiss(animated: true, completion: nil)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
                        UIAlertAction in
                        NSLog("Cancel Pressed")
                    }
                    
                    // Add the actions
                    alertController.addAction(okAction)
                    alertController.addAction(cancelAction)
                    
                    // Present the controller
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                
            } else {
                
                if userloginResponse.refresh_token != "" && userloginResponse.access_token != "" {
                    
                    defaults.set(userloginResponse.access_token, forKey: keys.accesstoken)
                    defaults.set(userloginResponse.refresh_token, forKey: keys.refreshtoken)
                    
                }
                
                if userloginResponse.user_id != "" {
                    defaults.set(userloginResponse.user_id, forKey: keys.RegisteredUserID)
                }
                
                
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.state = "logedin"
                
                retrieveUserData()
                
                let storyboard : UIStoryboard = UIStoryboard(name: "CPHomeView", bundle: nil)
                let vc : CPHomeViewController = storyboard.instantiateViewController(withIdentifier: "CPHomeView") as! CPHomeViewController
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
        }catch {
            print(error)
        }
    }
    
    
    private func retrieveUserData() {
        SVProgressHUD.show()
        
        let access = defaults.value(forKey: keys.accesstoken)
        
        let accessState = validateToken(token: access)
        
        if accessState == true {
            
            
            let headers: [String: String] = ["Authorization": "Bearer "+(access as! String)]
            
            let userid = defaults.value(forKey: keys.RegisteredUserID)
            
            print("mobileuserid is :: \(userid)")
            //jbhjbbjbnb
            
            let url = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.VIEW_USER_BY_ID + "\(userid ?? "")") as String
            
            print("url is :: \(url)")
            //        let parameters : [String : Any] = ["authCode=" : "89a9a3077550a1f6df9066a6091017a13e1a266e01e1b071093a4b75a84f338cf979056621a5d2a455c23ebeb2deb74b5cace5c9c6e10620a5741af3d67d5f1b2b752134e9c9"]
            
            let parameters : [String : Any] = [:]
            
            if let url = URL(string: url) {
                ApiManager.shared().makeRequestAlamofire(route: url, method: .get, autherized: false, parameter: parameters, header: headers){ (response) in
                    SVProgressHUD.dismiss()
                    switch response{
                    case let .success(data):
                        self.serializeLoggedUserDataa(data: data)
                        print("hereee")
                        print(response)
                    case .failure(let error):
                        print("\(error.errorCode)")
                        print("\(error.description)")
                        print("error status code :: \(error.statusCode)")
                        if error.statusCode == 401 { // MARK -: Means access token is expired
                            ApiManager.shared().RetrieveNewAccessToken(callback: { (response) in
                                switch response {
                                case let .success(data):
                                    self.serializeNewAccessToken(data: data)
                                    self.retrieveUserData()
                                    print(response)
                                case .failure(let error):
                                    print("error in retrieving new access token :: \(error)")
                                }
                            })
                        }
                    }
                }
            }
            
        }
        
    }
    
    
    func serializeLoggedUserDataa(data: Data) {
        do{
            print("data is :: \(data.description)")
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            print("data in response :: \(json)")
            guard let userpackageResponse: userPackageModel = Mapper<userPackageModel>().map(JSONObject: json) else {
                return
            }
            
            if userpackageResponse.content?.user?.accountName != "" && userpackageResponse.content?.user?.email != "" {
                
                PercistanceService.deleteAllRecords()
                
                let RegisteredLoggeduser = RegisteredUserData(context: PercistanceService.context)
                
                
                RegisteredLoggeduser.firstname = userpackageResponse.content?.user?.accountName
                RegisteredLoggeduser.email = userpackageResponse.content?.user?.email
                
                PercistanceService.saveContext()
                
                print("user data saved to model")
                
                StructProfile.ProfilePicture.email = (userpackageResponse.content?.user?.email)!
                StructProfile.ProfilePicture.name = (userpackageResponse.content?.user?.accountName)!
                
            }
            
            
            
        }catch {
            print(error)
        }
    }
    
    private func validateToken(token : Any?) -> Bool {
        
        if token == nil {
            // Create the alert controller
            let alertController = UIAlertController(title: "Sorry!", message: "You are not loggedIn", preferredStyle: .alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "Login", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
                let homeStoryBoard : UIStoryboard = UIStoryboard(name: "CPLogin", bundle: nil)
                let vc = homeStoryBoard.instantiateViewController(withIdentifier: "CPLoginView") as! CPLoginViewController
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
                NSLog("Cancel Pressed")
            }
            
            // Add the actions
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
            
            return false
        } else {
            return true
        }
        
    }
    
    func serializeNewAccessToken(data: Data) {
        do{
            print("data is :: \(data.description)")
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            print("data in response :: \(json)")
            guard let newTokenResponse: RefreshAccessTokenData = Mapper<RefreshAccessTokenData>().map(JSONObject: json) else {
                return
            }
            print("new Access token is :: \(newTokenResponse.access_token)")
            defaults.set(newTokenResponse.access_token, forKey: "Access_Token")
            print("new refresh token is :: \(newTokenResponse.refresh_token)")
            defaults.set(newTokenResponse.refresh_token, forKey: "Refresh_Token")
            print("User defaults updated!!")
            
        }catch {
            print(error)
        }
        
    }
    
    func showerrormessage(messege : String) {
        
        let alert = UIAlertController(title: "Sorry!", message: messege, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
