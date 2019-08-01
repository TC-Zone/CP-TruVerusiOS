//
//  CPSignUpViewController.swift
//  Truverus
//
//  Created by User on 30/4/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SVProgressHUD
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import FlagPhoneNumber

class CPSignUpViewController: BaseViewController, UITextFieldDelegate, GIDSignInDelegate, GIDSignInUIDelegate{

    @IBOutlet weak var FirstNameTextField: UITextField!
    @IBOutlet weak var LastNameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var ReEnterPasswordTextField: UITextField!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var ContactNumber: FPNTextField!
    @IBOutlet weak var createaccountbutton: UIButton!
    
    var idToken : String?
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //addSlideMenuButton()
        InitTextFields()
        settextDelegates()
        self.HideKeyboardWhenTappedAround()
        //ScrollView.validateScrolling(view: ScrollView)
        
        // Do any additional setup after loading the view.
    }
    
    func InitTextFields(){
        
        let common = CPcommon()
        common.CreateTextFields(TextField: FirstNameTextField, img: UIImage(named: "name_edit")!)
        common.CreateTextFields(TextField: LastNameTextField, img: UIImage(named: "name_edit")!)
        common.CreateTextFields(TextField: EmailTextField, img: UIImage(named: "email")!)
        common.CreateTextFields(TextField: PasswordTextField, img: UIImage(named: "passwordtextfield")!)
        common.CreateTextFields(TextField: ReEnterPasswordTextField, img: UIImage(named: "passwordtextfield")!)
        ContactNumber.flagSize.height = 15
        ContactNumber.flagSize.width = 25
        ContactNumber.flagButtonEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 3)
        common.createTextFieldBorder(TextField: ContactNumber)
        
    }
    
    func settextDelegates() {
        
        EmailTextField.delegate = self
        PasswordTextField.delegate = self
        FirstNameTextField.delegate = self
        LastNameTextField.delegate = self
        ReEnterPasswordTextField.delegate = self
        ContactNumber.delegate = self
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        EmailTextField.resignFirstResponder()
        PasswordTextField.resignFirstResponder()
        FirstNameTextField.resignFirstResponder()
        LastNameTextField.resignFirstResponder()
        ContactNumber.resignFirstResponder()
        ReEnterPasswordTextField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func CreateAccountButtonAction(_ sender: Any) {
        
        
        if FirstNameTextField.text?.isEmpty != true && nameValidation(input: FirstNameTextField) && FirstNameTextField.text != "" {
            if LastNameTextField.text?.isEmpty != true && nameValidation(input: LastNameTextField)  && LastNameTextField.text != ""{
                if ContactNumber.text?.isEmpty != true {
                    if EmailTextField.text?.isEmpty != true && isValidEmail(email: EmailTextField.text ?? ""){
                        if PasswordTextField.text?.isEmpty != true && isValidPassword(testStr: PasswordTextField.text){
                            if ReEnterPasswordTextField.text?.isEmpty != true {
                                if PasswordTextField.text == ReEnterPasswordTextField.text {
                                    
                                    
                                    let phone = ContactNumber.getFormattedPhoneNumber(format: .International)
                                    
                                    
                                    if phone == "" || phone == nil {
                                        print("all good and phone number is :: \(phone)")
                                        
                                        showValidationAlerts(message: "Please check contact number. invalid format")
                                        
                                    } else {
                                        
                                        let name = "\(FirstNameTextField.text!) \(LastNameTextField.text!)"
                                        print("data gathered after validations :: first name \(FirstNameTextField.text) last name \(LastNameTextField.text) phone \(phone) email \(EmailTextField.text) password \(PasswordTextField.text) confirm password \(ReEnterPasswordTextField.text))")
                                        
                                        getRegisteredUser(name: name, email: EmailTextField.text!, password: PasswordTextField.text!, mobileNumber: phone!)
                                        
                                    }
                                    
                                    
                                } else {
                                    showValidationAlerts(message: "Password and confirm password doesn't match")
                                }
                            } else {
                                showValidationAlerts(message: "Please check confirm password field")
                            }
                        } else {
                            showValidationAlerts(message: "Passwords must be at least 8 characters long and must contain at least one number,both lower and uppercase letters and special characters.")
                        }
                    } else {
                        showValidationAlerts(message: "Please check your email address")
                    }
                } else {
                    showValidationAlerts(message: "Please check your contact number")
                }
            } else {
                showValidationAlerts(message: "Please check your last name")
            }
        } else {
            showValidationAlerts(message: "Please check your first name")
        }
        
    }
    
    
    func isValidPhone(phone: String) -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func isValidPassword(testStr:String?) -> Bool {
        guard testStr != nil else { return false }
        
        // at least one uppercase,
        // at least one digit
        // at least one lowercase
        // 8 characters total
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: testStr)
    }
    
    func showValidationAlerts(message : String) {
        
        let alert = UIAlertController(title: "Sorry!", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    func nameValidation(input: UITextField)->Bool
    {
        let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ")
        if input.text?.rangeOfCharacter(from: set.inverted) != nil {
            print("ERROR: There are numbers included!")
            showValidationAlerts(message: "\(input.text ?? "name textfields") contains unacceptable charachters.")
            return false
        } else {
            
            return true
        }
    }
    
    
    @IBAction func GoogleSignInButtonAction(_ sender: Any) {
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
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


extension CPSignUpViewController{
    private func getGoogleUser(){
        showProgressHud()
        
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
            
            defaults.set(loginResponse.response?.access_token, forKey: keys.accesstoken)
            defaults.set(loginResponse.response?.refresh_token, forKey: keys.refreshtoken)
            
            //            customerID = loginResponse.subscriberBean?.subscriberId
            //            self.rssSubscrib()
        }catch {
            print(error)
        }
    }
    
    
    private func getRegisteredUser(name : String, email : String, password : String, mobileNumber : String){
       
        showProgressHud()
        self.createaccountbutton.isEnabled = false
        self.createaccountbutton.backgroundColor = UIColor.lightGray
        ApiManager.shared().RegisterNewUser(name: name, email: email, password: password, mobileNumber: mobileNumber) { (response) in
            switch response {
            case let .success(data):
                SVProgressHUD.dismiss()
                self.createaccountbutton.isEnabled = true
                self.createaccountbutton.backgroundColor = UIColor.black
                self.serializeRegisteredUserResponse(data: data)
                print(response)
            case .failure(let error):
                print("error in retrieving new access token :: \(error)")
            }
        }
        
    }
    
    func serializeRegisteredUserResponse(data: Data) {
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            print("data in response :: \(json)")
            guard let loginResponse: UserRegisterDataModel = Mapper<UserRegisterDataModel>().map(JSONObject: json) else {
                return
            }
            
            print("user register response is :: \(loginResponse)")
            
            if loginResponse.statusCode == 200 {
                
                
                defaults.set(loginResponse.content?.mobileUser?.id, forKey: keys.RegisteredUserID)
                
                print("saved to defalts user id is :: \(loginResponse.content?.mobileUser?.id)")
                
                let storyboard : UIStoryboard = UIStoryboard(name: "CPLogin", bundle: nil)
                let Acc : CPVerifyEmailViewController = storyboard.instantiateViewController(withIdentifier: "verifyemailscreen") as! CPVerifyEmailViewController
                self.dismiss(animated: true, completion: nil)
                //self.navigationController?.popToViewController(Acc, animated: true)
                self.navigationController?.pushViewController(Acc, animated: true)
                
            } else if loginResponse.statusCode == 400 {
                
                guard let errorResponse: registerErrorData = Mapper<registerErrorData>().map(JSONObject: json) else {
                    return
                }
                
                print("error was :: \(errorResponse.validationFailures![0].code)")
                
                let errordescription = errorResponse.validationFailures?[0].code
                
                if errordescription != "" {
                    if errordescription == "registerMobileUser.emailduplicate" {
                        showValidationAlerts(message: "email already exists")
                    }
                } else {
                    showValidationAlerts(message: "something went wrong")
                }
                
                
                
            }
            
            
            
            //            customerID = loginResponse.subscriberBean?.subscriberId
            //            self.rssSubscrib()
        }catch {
            print(error)
        }
    }
 
}


extension CPSignUpViewController: FPNTextFieldDelegate {
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        print(name, dialCode, code) // Output "France", "+33", "FR"
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        if isValid {
            // Do something...
            textField.getFormattedPhoneNumber(format: .E164)           // Output "+33600000001"
            textField.getFormattedPhoneNumber(format: .International)  // Output "+33 6 00 00 00 01"
            textField.getFormattedPhoneNumber(format: .National)       // Output "06 00 00 00 01"
            textField.getFormattedPhoneNumber(format: .RFC3966)        // Output "tel:+33-6-00-00-00-01"
            textField.getRawPhoneNumber()                               // Output "600000001"
        } else {
            // Do something...
        }
    }
}

