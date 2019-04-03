//
//  CPSocialSignInManager.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 3/28/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn

class  CPSocialSignInManager : NSObject, GIDSignInDelegate, GIDSignInUIDelegate {
    
    
    weak var googleView: UIViewController!

    
    init(view: UIViewController) {
        super.init()
        googleView = view    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func login() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        googleView.present(viewController, animated: true, completion: nil)
    }
    
    // this method is the one that wont invoke
    
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
            
        }
     
    }
  
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        googleView.dismiss(animated: true, completion: nil)
    }
    
    
    
    static func fetchProfile() {
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
                StructProfile.ProfilePicture.ProfilePicURL = pictureUrl
                StructProfile.ProfilePicture.email = email!
                StructProfile.ProfilePicture.name = firstName! + lastName!
                // menu.CreateProfilePic()
            }
        })
    }
 
    
}


