//
//  CPSocialSignInHelper.swift
//  Truverus
//
//  Created by User on 6/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class CPSocialSignInHelper {
    
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
//                StructProfile.ProfilePicture.ProfilePicURL = pictureUrl
//                StructProfile.ProfilePicture.email = email!
//                StructProfile.ProfilePicture.name = firstName! + lastName!
                // menu.CreateProfilePic()
            }
        })
    }
    
}
