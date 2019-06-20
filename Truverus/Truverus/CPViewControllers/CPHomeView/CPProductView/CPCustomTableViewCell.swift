//
//  CPCustomTableViewCell.swift
//  Truverus
//
//  Created by User on 8/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import SVProgressHUD

class CPCustomTableViewCell: UITableViewCell {

    
    @IBOutlet weak var PageControll: UIPageControl!
    
    @IBOutlet weak var Descheight: NSLayoutConstraint!
    @IBOutlet weak var ProductNameLabel: UILabel!
    
    @IBOutlet weak var DescriptionTextArea: UITextView!
    
    @IBOutlet weak var WatchHereButton: UIButton!
    
    @IBOutlet weak var TransferButton: UIButton!
    @IBOutlet weak var BackButton: UIButton!
    
    @IBOutlet weak var CommunityButton: UIButton!
    @IBOutlet weak var PurchaseButton: UIButton!
    
    let defaults = UserDefaults.standard
    
    var youtubeVedioID : String!
    var Community : String!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
  
    }
    

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func SetText(description: String , productName: String) {
        
        
        DescriptionTextArea.translatesAutoresizingMaskIntoConstraints = true
        DescriptionTextArea.text = description
        
        
        if self.DescriptionTextArea.contentSize.height > 310{
            
            let height = (contentView.frame.height) / 2
            let screenwid = (UIScreen.main.bounds.width) / 2
            
            DescriptionTextArea.center = CGPoint(x: screenwid, y: height)
            Descheight.constant = 380
            DescriptionTextArea.isScrollEnabled = false
            let buttonHeight: CGFloat = 30
            let contentInset: CGFloat = 1
            DescriptionTextArea.textContainerInset = UIEdgeInsets(top: contentInset, left: contentInset, bottom: 0, right: contentInset)
            
            let button = UIButton(frame: CGRect(x: contentInset, y: DescriptionTextArea.contentSize.height - buttonHeight - contentInset, width: DescriptionTextArea.contentSize.width-contentInset*2, height: buttonHeight))
            button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
            button.contentVerticalAlignment = UIControl.ContentVerticalAlignment.top
            button.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 6.0)
            button.setTitle("...Read More", for: UIControl.State.normal)
            button.setTitleColor(UIColor(named: "readmorecolor"), for: UIControl.State.normal)
            button.titleLabel?.backgroundColor = UIColor.white
            button.titleLabel?.font = .systemFont(ofSize: 12)
            button.backgroundColor = UIColor.white
            DescriptionTextArea.addSubview(button)
            
            button.addTarget(self, action: #selector(actionButtonTapped(sender:)), for: .touchUpInside)
            
            
            
            
        } else {
            
            DescriptionTextArea.sizeToFit()
            DescriptionTextArea.isScrollEnabled = false
        }
        
        ProductNameLabel.text = productName
        
    }
    
    @objc func actionButtonTapped(sender: UIButton){
        
        DescriptionTextArea.isScrollEnabled = true
        sender.isHidden = true
        
    }
    
    func setPagecontrol(number : Int){
        
        PageControll.currentPage = number
        
    }
    
    @IBAction func CommunityButtonAction(_ sender: Any) {
        
        
        if productStruct.productObj.CommunityID != "" {
            print("Community Id in cell is :: \(productStruct.productObj.CommunityID)")
        }
        
    }
    
    
    @IBAction func PurchaseButtonAction(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.state == "logedin" {
            
            if StructProductRelatedData.purchaseAvailability == true  {
                
                ShowValidateAlerts(message : "You alredy Purchased this product", title: "Sorry!")
                
            } else {
                
                PurchaseProduct()
                
            }
            
            
        } else if appDelegate.state == "logedout" {
            
            ShowValidateAlerts(message : "You are not logged in", title: "Sorry!")
            
        }
        
        
    }
    

    func ShowValidateAlerts(message : String, title : String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
        }
        alertController.addAction(okAction)
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func WatchButtonAction(_ sender: Any) {
        
        print("button is clicked")
        
        var youtubeId = ""
        
        if productStruct.productObj.youtubeId != "" {
            print("youtube Id in cell is :: \(productStruct.productObj.youtubeId)")
            youtubeId = productStruct.productObj.youtubeId
            
            if let youtubeURL = URL(string: "youtube://\(youtubeId)"),
                UIApplication.shared.canOpenURL(youtubeURL) {
                // redirect to app
                UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
            } else if let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(youtubeId)") {
                // redirect through safari
                UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
            }
            
        } else {
            youtubeId = "EKyirtVHsK0"
            let alertController = UIAlertController(title: "Sorry!", message: "Vedio is not available for this product", preferredStyle: .actionSheet)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
            }
            
            alertController.addAction(okAction)
            self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
            
        }
        
       
        
        
    }
   
}


extension CPCustomTableViewCell {
    
    private func PurchaseProduct(){
        SVProgressHUD.show()
        
        self.PurchaseButton.isEnabled = false
        self.PurchaseButton.backgroundColor = UIColor.lightGray
        
        let headers: [String: String] = [:]
        
        let userid = defaults.value(forKey: keys.RegisteredUserID)
        
        if userid != nil && StructProductRelatedData.ProductTagCode != "" {
            
            
            //Correct line for nfc reding
            let url = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.PURCHASE_PRODUCT + "authCode=\(StructProductRelatedData.ProductTagCode)") as String
            
            
            if StructProfile.ProfilePicture.name != "" && productStruct.productObj.productTitle != ""{
                
                print("name was \(StructProfile.ProfilePicture.name)")
                
                let parameters : [String : Any] = [
                    "mobileId": "\(userid ?? "")",
                    "transferLogs": [["record": "\(StructProfile.ProfilePicture.name) purchased \(productStruct.productObj.productTitle)"]]
                    ] as [String : Any]
                
                if let url = URL(string: url) {
                    ApiManager.shared().makeRequestAlamofire(route: url, method: .post, autherized: true, parameter: parameters, header: headers){ (response) in
                        SVProgressHUD.dismiss()
                        switch response{
                        case let .success(data):
                            self.serializePurchaseResponse(data: data)
                            print("hereee")
                            print(response)
                        case .failure(let error):
                            print("fail error is :: \(error)")
                            print("error code is :: \(error.errorCode)")
                            print("error type is :: \(error.errorType)")
                            print("error description is :: \(error.description)")
                        }
                    }
                }
                
            }
            
            //        let url = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.AUTHENTICATE_PRODUCT + "authCode=c5aac93022011753ce3b696ae6ee393d424c62407349ff0c3192eed54b2e053320e503475df6ae034712e1e0c961c51873e47de8c4876c85100bf87707e5efa5d04ef60af435" ) as String
            
            print("url is :: \(url)")
            //        let parameters : [String : Any] = ["authCode=" : "89a9a3077550a1f6df9066a6091017a13e1a266e01e1b071093a4b75a84f338cf979056621a5d2a455c23ebeb2deb74b5cace5c9c6e10620a5741af3d67d5f1b2b752134e9c9"]
            
            
            
        } else {
            
            SVProgressHUD.dismiss()
            ShowValidateAlerts(message : "Something went wrong", title: "Sorry!")
            
        }
        
        
        
        
    }
    
    func serializePurchaseResponse(data: Data) {
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            print("data in response :: \(json)")
            guard let purResponse: PurchaseProductBase = Mapper<PurchaseProductBase>().map(JSONObject: json) else {
                return
            }
            if purResponse.status == "OK" && purResponse.statusCode == 200 {
                
                print("returned community id from ser :: \(purResponse.content?.product?.communityId)")
                StructProductRelatedData.purchaseAvailability = true
                productStruct.productObj.CommunityID = purResponse.content?.product?.communityId ?? ""
                UpdateUserCommunityData(CommunityID: "\(purResponse.content?.product?.communityId ?? "")")
                
                self.PurchaseButton.isEnabled = true
                self.PurchaseButton.backgroundColor = UIColor.black
               
            } else {
                
                ShowValidateAlerts(message : "Something went wrong", title: "Sorry!")
                self.PurchaseButton.isEnabled = true
                self.PurchaseButton.backgroundColor = UIColor.black
                
            }
            
            
        }catch {
            print(error)
        }
    }
    
    private func UpdateUserCommunityData(CommunityID : String) {
        SVProgressHUD.show()
        
        let access = defaults.value(forKey: keys.accesstoken)
        
        let accessState = validateToken(token: access)
        
        if accessState == true {
            
            
            let headers: [String: String] = ["Authorization": "Bearer "+(access as! String)]
            
            let userid = defaults.value(forKey: keys.RegisteredUserID)
            
            print("mobileuserid is :: \(userid)")
            //jbhjbbjbnb
            
            let url = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.UPDATE_COMMUNITY_BY_PURCHASES + "\(userid ?? "")") as String
            
            print("url is :: \(url)")
            //        let parameters : [String : Any] = ["authCode=" : "89a9a3077550a1f6df9066a6091017a13e1a266e01e1b071093a4b75a84f338cf979056621a5d2a455c23ebeb2deb74b5cace5c9c6e10620a5741af3d67d5f1b2b752134e9c9"]
            
            let parameters : [String : Any] = ["communities": [["id": "\(CommunityID)"]]] as [String : Any]
            
            if let url = URL(string: url) {
                ApiManager.shared().makeRequestAlamofire(route: url, method: .put, autherized: false, parameter: parameters, header: headers){ (response) in
                    SVProgressHUD.dismiss()
                    switch response{
                    case let .success(data):
                        self.serializeUpdatedCommunityDataa(data: data)
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
                                    self.UpdateUserCommunityData(CommunityID: CommunityID)
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
    
    
    func serializeUpdatedCommunityDataa(data: Data) {
        do{
            print("data is :: \(data.description)")
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            print("data in response :: \(json)")
            guard let UpdatedCommunityResponse: UpdateCommunityBase = Mapper<UpdateCommunityBase>().map(JSONObject: json) else {
                return
            }
            
            if UpdatedCommunityResponse.status == "OK" && UpdatedCommunityResponse.statusCode == 200 {
                
                ShowValidateAlerts(message : "Pruduct Purchased Successfully!", title: "Congradulations!")
                
            } else {
                
                ShowValidateAlerts(message : "Something went wrong", title: "Sorry!")
            }
            
            
            
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
            print("new Access token is :: \(newTokenResponse.access_token)")
            defaults.set(newTokenResponse.access_token, forKey: "Access_Token")
            print("new refresh token is :: \(newTokenResponse.refresh_token)")
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
    
    
}
