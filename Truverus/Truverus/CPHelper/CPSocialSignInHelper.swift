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
import Alamofire
import ObjectMapper
import SVProgressHUD


class CPSocialSignInHelper {
    
    static var idToken : String!
    static let defaults = UserDefaults.standard
    
    static func fetchProfile() {
        let parameters = ["fields": "first_name, email, last_name, picture"]
        
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start(completionHandler: { (connection, user, requestError) -> Void in
            
            if requestError != nil {
                print("----------ERROR-----------")
                print(requestError!)
                return
            }
            idToken = FBSDKAccessToken.current().tokenString
            print("id facebook is :: \(idToken)")
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
                
                getFacebookUser()
                
                PercistanceService.deleteAllRecords()
                
                let FBsignuser = FaceBookUser(context: PercistanceService.context)
                
                FBsignuser.profilePicture = pictureUrl
                FBsignuser.name = firstName! + lastName!
                FBsignuser.email = email!
                PercistanceService.saveContext()
                
                //menu.CreateProfilePic()
            }
        })
    }
   
}


extension CPSocialSignInHelper{
    private static func getFacebookUser(){
        SVProgressHUD.show()
        
        let headers: [String: String] = [:]
        
        let url = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.SOCIAL_USER_SIGN_IN) as String
        
        if CPSocialSignInHelper.idToken != nil && StructProfile.ProfilePicture.FCMToken != "not found" {
            
            print("url is :: \(url)")
            let parameters : [String :Any] = ["code" : CPSocialSignInHelper.idToken as Any, "authProvider" : "facebook", "registerToken" : StructProfile.ProfilePicture.FCMToken]
            
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
            } else {
                print("couldn't find all the parameters needed")
            }
            
            
        }
        
        
        
    }
    
    static func serializeCheckUserStatusResponse(data: Data) {
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            print("data in response :: \(json)")
            guard let loginResponse: googleUserResponse = Mapper<googleUserResponse>().map(JSONObject: json) else {
                return
            }
            
            print("data recieved from fb access token method :: \(loginResponse)")
            
            defaults.set(loginResponse.response?.access_token, forKey: keys.accesstoken)
            defaults.set(loginResponse.response?.refresh_token, forKey: keys.refreshtoken)
            defaults.set(loginResponse.response?.user_id, forKey: keys.RegisteredUserID)
            
            print("fb access token is saved successfully")
            //            customerID = loginResponse.subscriberBean?.subscriberId
            //            self.rssSubscrib()
        }catch {
            print(error)
        }
    }
}

