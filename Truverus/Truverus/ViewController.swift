//
//  ViewController.swift
//  Truverus
//
//  Created by User on 30/4/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SVProgressHUD

class ViewController: BaseViewController {

    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSlideMenuButton()
        GetmobileUserData()
        
        if productStruct.productObj.productTitle != "" {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "CPHomeView", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "CPHomeView") as! CPHomeViewController
            self.navigationController?.pushViewController(newViewController, animated: true)
            
        } else {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "NFC", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "CPNFCView") as! CPNfcViewController
            self.navigationController?.pushViewController(newViewController, animated: true)
            
        }
        
    }
}


extension ViewController {
    
    private func GetmobileUserData(){
        showProgressHud()
        
        let access = defaults.value(forKey: keys.accesstoken)
        let accessState = validateToken(token: access)
        let user = defaults.value(forKey: keys.RegisteredUserID)
        
        if accessState == true && user != nil {
            
            let headers: [String: String] = ["Authorization": "Bearer "+(access as! String)]
            
            //Correct line for nfc reding
            let url = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.MOBILE_USER_VIEW_BY_ID + "\(user ?? "")") as String
            
            let parameters : [String : Any] = [:]
            
            if let url = URL(string: url) {
                ApiManager.shared().makeRequestAlamofire(route: url, method: .get, autherized: true, parameter: parameters, header: headers){ (response) in
                    SVProgressHUD.dismiss()
                    switch response{
                    case let .success(data):
                        self.serializeMobileUserViewResponse(data: data)
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
                                    self.GetmobileUserData()
                                    print(response)
                                case .failure(let error):
                                    print("error in retrieving new access token :: \(error)")
                                    if error.statusCode == 400 {
                                        
                                        
                                        self.ShowValidateAlerts(message : "400 was returned", title: "Sorry!")
                                        
                                    }
                                   
                                }
                            })
                        }
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
            
            print("mobile user id : \(MobileUserViewBaseResponse.content?.id)")
            
            defaults.set(MobileUserViewBaseResponse.content?.id, forKey: keys.mobileUserId)
            print("mobile user id saved successfully")
            
            UpdateUserFCMToken()
            
        }catch {
            print(error)
        }
    }
  
  
    private func UpdateUserFCMToken() {
        SVProgressHUD.show()
        
        
        let access = defaults.value(forKey: keys.accesstoken)
        
        let accessState = validateToken(token: access)
        
        if accessState == true {
            
            
            let headers: [String: String] = ["Authorization": "Bearer "+(access as! String)]
            
            let userid = defaults.value(forKey: keys.mobileUserId)
            
            print("mobileuserid is :: \(userid)")
            
            let url = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.REFRESH_FCMTOKEN) as String
            
            print("url is :: \(url)")
            
            let parameters = [
                "id": userid!,
                "registerToken": StructProfile.ProfilePicture.FCMToken
                ] as [String : Any]
            
            
            if let url = URL(string: url) {
                ApiManager.shared().makeRequestAlamofire(route: url, method: .put, autherized: false, parameter: parameters, header: headers){ (response) in
                    SVProgressHUD.dismiss()
                    switch response{
                    case let .success(data):
                        self.serializeUpdatedUserDataaResponse(data: data)
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
                                    self.UpdateUserFCMToken()
                                    print(response)
                                case .failure(let error):
                                    print("error in retrieving new access token :: \(error)")
                                    if error.statusCode == 400 {
                                        
                                        
                                        self.ShowValidateAlerts(message : "400 was returned", title: "Sorry!")
                                        
                                    }
                                    
                                    
                                }
                            })
                        }
                    }
                }
            }
            
        }
        
    }
    
    
    func serializeUpdatedUserDataaResponse(data: Data) {
        do{
            print("data is :: \(data.description)")
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            print("data in response :: \(json)")
            guard let UpdatedFCMToken: MobileUserBase = Mapper<MobileUserBase>().map(JSONObject: json) else {
                return
            }
            
            print("updated FCM token is :: \(UpdatedFCMToken.content?.registerToken)")
            
            
        }catch {
            print(error)
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
            
            defaults.set(newTokenResponse.access_token, forKey: "Access_Token")
            
            defaults.set(newTokenResponse.refresh_token, forKey: "Refresh_Token")
            print("User defaults updated!!")
            
        }catch {
            print(error)
        }
        
    }
    
    
    private func validateToken(token : Any?) -> Bool {
        
        if token == nil {
            // Create the alert controller
            ShowValidateAlerts(message : "You are not logged in", title: "Sorry!")
            
            return false
        } else {
            return true
        }
        
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
