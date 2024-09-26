//
//  CPMyAccountViewController.swift
//  Truverus
//
//  Created by User on 9/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import CoreData
import FlagPhoneNumber
import Alamofire
import ObjectMapper
import SVProgressHUD

class CPMyAccountViewController: BaseViewController {
    
    
    @IBOutlet weak var EditProfileButton: UIButton!
    @IBOutlet weak var ProfilePicture: UIImageView!
    @IBOutlet weak var ProfileName: UILabel!
    @IBOutlet weak var ProfileEmail: UILabel!
    @IBOutlet weak var GenderText: UILabel!
    @IBOutlet weak var BirthdayText: UILabel!
    @IBOutlet weak var AddressText: UILabel!
    @IBOutlet weak var ContactText: FPNTextField!
    @IBOutlet weak var JobTitleText: UILabel!
    @IBOutlet weak var FashionInterestsText: UILabel!
    @IBOutlet weak var FavouritSportsText: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var userdata = [User]()
    var registeruser = [RegisteredUserData]()
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSlideMenuButton()
        fillData()
        CreateProfilePic()
        GetmobileUserData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadFromRemote), name: NSNotification.Name(rawValue: "updateMenu"), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(LoadImageUpdate), name: NSNotification.Name(rawValue: "loadImageWhenUpdated"), object: nil)
        
        // Do any additional setup after loading the view.
    }
   
    
//    @IBAction func EditProfileButtonAction(_ sender: Any) {
//        
//        let storyboard : UIStoryboard = UIStoryboard(name: "MyAccount", bundle: nil)
//        let vc : CPEditAccountViewController = storyboard.instantiateViewController(withIdentifier: "CPEditAccountViewController") as! CPEditAccountViewController
//        
//        
//        UIApplication.shared.keyWindow?.setRootViewController(vc, options: .init(direction: .toRight, style: .easeIn))
//        
//    }
    
    @objc func LoadImageUpdate() {
        
        if userProfileDataEdit.imageUrl != nil {

            ProfilePicture.kf.indicatorType = .activity
            ProfilePicture.kf.setImage(with: userProfileDataEdit.imageUrl, options: [.transition(.fade(0.2))])

        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateMenu"), object: nil)
        
        //GetmobileUserData()
        
    }
    
    @objc func loadFromRemote() {
        
        GetmobileUserData()
        fillData()
        
    }
    
    func fillData() {

        if GIDSignIn.sharedInstance().hasAuthInKeychain() {

            //userdata.removeAll()
            print("User Has Already signed in using google")


            
            let fetchRequest : NSFetchRequest<User> = User.fetchRequest()

            do {

                let userdata = try PercistanceService.context.fetch(fetchRequest)
                self.userdata = userdata

            } catch {

                print("Error occured while fetching core data")
                
            }

            print("user data ::: \(userdata)")
            let img = userdata.last
            
            if (userdata.count != 0) {
                
                let url = URL(string: img!.profilepictureurl!)!
                ProfilePicture.kf.setImage(with: url)
                ProfileName.text = img!.name!
                ProfileEmail.text = img?.email

            }
            

        } else if FBSDKAccessToken.current() != nil {

            print("user is already logged in using facebook")
            let url = URL(string: StructProfile.ProfilePicture.ProfilePicURL)!
            ProfilePicture.kf.setImage(with: url)
            ProfileName.text = StructProfile.ProfilePicture.name
            ProfileEmail.text = StructProfile.ProfilePicture.email
            
        } else if defaults.value(forKey: keys.RegisteredUserID) != nil {
            
            let fetchRequest : NSFetchRequest<RegisteredUserData> = RegisteredUserData.fetchRequest()
            
            do {
                
                let Registereduserdata = try PercistanceService.context.fetch(fetchRequest)
                self.registeruser = Registereduserdata
                
            } catch {
                
                print("Error occured while fetching core data")
                
            }
            
            let img = registeruser.last
            
            if (registeruser.count != 0) {
                
                if img?.picture != nil {
                    ProfilePicture.image = UIImage(named: "user icon")
                } else {
                    ProfilePicture.image = UIImage(named: "newusericon")
                }
                if img?.email != nil {
                    ProfileEmail.text = img!.email!
                } else {
                    ProfileEmail.text = "-"
                }
                if img?.firstname != nil {
                    ProfileName.text = img!.firstname!
                } else {
                    ProfileName.text = ""
                }
                
            }
            
        }
        else {
            print("user is not logged in")
            
            ProfilePicture.image = UIImage(named: "user icon")
            ProfileName.text = ""
            ProfileEmail.text = ""
            
        }


    }

    
    func CreateProfilePic(){
        
        
        ProfilePicture.layer.borderWidth = 3.0
        ProfilePicture.layer.masksToBounds = false
        ProfilePicture.layer.borderColor = UIColor(named: "TextGray")?.cgColor
        ProfilePicture.layer.cornerRadius = ProfilePicture.frame.size.width / 2
        ProfilePicture.clipsToBounds = true
        
        
        
    }
    
    func ShowValidateAlerts(message : String, title : String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }

}


extension CPMyAccountViewController {
    
    private func GetmobileUserData(){
        showProgressHud()
        
        let access = defaults.value(forKey: keys.accesstoken)
        let accessState = validateToken(token: access)
        let user = defaults.value(forKey: keys.RegisteredUserID)
        
        if accessState == true && user != nil {
        
        let headers: [String: String] = ["Authorization": "Bearer "+(access as! String)]
        
        //Correct line for nfc reding
        let url = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.MOBILE_USER_VIEW_BY_ID + "\(user ?? "")") as String
        
        //        let url = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.AUTHENTICATE_PRODUCT + "authCode=ff3ef0e59db43394c5e3fb9f62ea8de34c7714277187b48022bf7da6aaeccee3cc47cd77ac6a207b8cbcbcec0d78f666ff2ee89ce14175a487daf7a9141d2c6324d2b39f3c3c" ) as String
        //        tagValue = "ff3ef0e59db43394c5e3fb9f62ea8de34c7714277187b48022bf7da6aaeccee3cc47cd77ac6a207b8cbcbcec0d78f666ff2ee89ce14175a487daf7a9141d2c6324d2b39f3c3c"
        //        StructProductRelatedData.ProductTagCode = tagValue
        //  up to this point iys invalid
        
        
        print("url is :: \(url)")
        //        let parameters : [String : Any] = ["authCode=" : "89a9a3077550a1f6df9066a6091017a13e1a266e01e1b071093a4b75a84f338cf979056621a5d2a455c23ebeb2deb74b5cace5c9c6e10620a5741af3d67d5f1b2b752134e9c9"]
        
        let parameters : [String : Any] = [:]
        
        if let url = URL(string: url) {
            ApiManager.shared().makeRequestAlamofire(route: url, method: .get, autherized: true, parameter: parameters, header: headers){ (response) in
                SVProgressHUD.dismiss()
                switch response{
                case let .success(data):
                    self.serializeMobileUserViewResponse(data: data)
                    print("hereee")
                    print(response)
                case .failure(_):
                    print("fail")
                }
            
            }
        
            }
        }
    }
    
    func serializeMobileUserViewResponse(data: Data) {
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            print("data in response :: \(json)")
            guard let MobileUserViewBaseResponse: MobileUserBase = Mapper<MobileUserBase>().map(JSONObject: json) else {
                return
            }
            
            print("Name : \(MobileUserViewBaseResponse.content?.user?.accountName)")
            print("email : \(MobileUserViewBaseResponse.content?.user?.email)")
            print("profileImage : \(MobileUserViewBaseResponse.content?.user?.profileImage)")
            print("status : \(MobileUserViewBaseResponse.content?.user?.status)")
            print("mobileNumber : \(MobileUserViewBaseResponse.content?.mobileNumber)")
            print("birthday : \(MobileUserViewBaseResponse.content?.birthday)")
            print("gender : \(MobileUserViewBaseResponse.content?.gender)")
            print("address : \(MobileUserViewBaseResponse.content?.address)")
            print("just user id : \(MobileUserViewBaseResponse.content?.id)")
            
            defaults.set(MobileUserViewBaseResponse.content?.id, forKey: keys.justUserId)
            
            
            let imageurl = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.GET_PROFILEPIC_BY_USER_ID + "\(MobileUserViewBaseResponse.content?.user?.id ?? "")") as String
            let imgUrl = URL(string: imageurl)
            print("user image url :: \(imgUrl)")
            
            if imgUrl != nil {
                
                userProfileDataEdit.imageurlString = imageurl
                StructProfile.ProfilePicture.ProfilePicURL = imageurl
                userProfileDataEdit.imageUrl = imgUrl
                ProfilePicture.kf.indicatorType = .activity
                ProfilePicture.kf.setImage(with: imgUrl, options: [.transition(.fade(0.2))])
                
            }
            
            if MobileUserViewBaseResponse.content?.mobileNumber != nil || MobileUserViewBaseResponse.content?.mobileNumber != "" {
                
                ContactText.text = MobileUserViewBaseResponse.content?.mobileNumber
                userProfileDataEdit.contacton = MobileUserViewBaseResponse.content?.mobileNumber
                
            }
            if MobileUserViewBaseResponse.content?.birthday != nil || MobileUserViewBaseResponse.content?.birthday != "" {
                
                BirthdayText.text = MobileUserViewBaseResponse.content?.birthday
                userProfileDataEdit.Birthdayon = MobileUserViewBaseResponse.content?.birthday
                
            }
            if MobileUserViewBaseResponse.content?.gender != nil || MobileUserViewBaseResponse.content?.gender != "" {
                
                GenderText.text = MobileUserViewBaseResponse.content?.gender
                
                if MobileUserViewBaseResponse.content?.gender == "M" {
                    userProfileDataEdit.genderon = "Male"
                } else if MobileUserViewBaseResponse.content?.gender == "F" {
                    userProfileDataEdit.genderon = "Female"
                } else {
                    userProfileDataEdit.genderon = "Other"
                }
                
                
                
            }
            if MobileUserViewBaseResponse.content?.address != nil || MobileUserViewBaseResponse.content?.address != "" {
                
                AddressText.text = MobileUserViewBaseResponse.content?.address
                userProfileDataEdit.Addresson = MobileUserViewBaseResponse.content?.address
                
            }
            if MobileUserViewBaseResponse.content?.user?.accountName != nil || MobileUserViewBaseResponse.content?.user?.accountName != "" {
                
                userProfileDataEdit.nameon = MobileUserViewBaseResponse.content?.user?.accountName
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setvaluesforEdit"), object: nil)
            
            
        }catch {
            print(error)
        }
    }
    
    
    private func validateToken(token : Any?) -> Bool {
        
        if token == nil {
            // Create the alert controller
            let alertController = UIAlertController(title: "Sorry!", message: "You are not loggedIn to view community", preferredStyle: .alert)
            
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
    
    
}
