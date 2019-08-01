//
//  CPcommonService.swift
//  Truverus
//
//  Created by Trumpcode on 2019-07-23.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import SVProgressHUD

class CPcommonService {
    
    var communitiesArray : [String?] = []
    var productsArray : [String?] = []
    let defaults = UserDefaults.standard
    
    func showProgressHud() {
        
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setForegroundColor(UIColor.black)           //Ring Color
        SVProgressHUD.setBackgroundColor(UIColor.clear)        //HUD Color
        SVProgressHUD.setBackgroundLayerColor(UIColor.black.withAlphaComponent(0.5))
        SVProgressHUD.show()
        
    }
    
    func ValidatePurchaseData(){
        showProgressHud()
        
        let headers: [String: String] = [:]
        
        let userid = defaults.value(forKey: keys.RegisteredUserID)
        
        
        if userid != nil {
            
            //Correct line for nfc reding
            let url = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.GET_PURCHASED_ITEMS + "\(userid ?? "")") as String
            
            
            print("url is :: \(url)")
            
            let parameters : [String : Any] = [:]
            
            if let url = URL(string: url) {
                ApiManager.shared().makeRequestAlamofire(route: url, method: .get, autherized: true, parameter: parameters, header: headers){ (response) in
                    SVProgressHUD.dismiss()
                    switch response{
                    case let .success(data):
                        self.serializePurchaseDataResponse(data: data)
                        print("hereee")
                        print(response)
                    case .failure(_):
                        print("fail")
                    }
                }
            }
            
        } else {
            
            SVProgressHUD.dismiss()
            
        }
        
    }
    
    func serializePurchaseDataResponse(data: Data) {
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            print("data in response jhdbhjvvbj :: \(json)")
            guard let purchaseResponse: availablePurchasesBase = Mapper<availablePurchasesBase>().map(JSONObject: json) else {
                return
            }
            
            print("i was invoked yessss")
            
            print("product purchase availability :: \(purchaseResponse.status ?? "")")
            if purchaseResponse.status == "OK" && purchaseResponse.statusCode == 200 {
                
                let communitycount = purchaseResponse.content?.count
                communitiesArray.removeAll()
                productsArray.removeAll()
                if communitycount ?? 0 > 0 && communitycount != nil {
                    
                    for i in 0...(communitycount! - 1) {
                        
                        communitiesArray.append("\(purchaseResponse.content?[i].productDetail?.product?.communityId ?? "")")
                        productsArray.append("\(purchaseResponse.content?[i].productDetail?.product?.id ?? "")")
                        
                    }
                    
                    print("communities array is :: \(communitiesArray)")
                    print("product lis array is :: \(productsArray)")
                    print("current product is :: \(productStruct.productObj.productID)")
                    
                    if productsArray.contains("\(productStruct.productObj.productID)") {
                        
                        StructProductRelatedData.purchaseAvailability = true
                        
                    } else {
                        
                        StructProductRelatedData.purchaseAvailability = false
                        
                    }
                    
                    
                    
                } else {
                    
                    StructProductRelatedData.purchaseAvailability = false
                    
                }
                
                
                
            } else {
                
                
                StructProductRelatedData.purchaseAvailability = false
                
            }
            
            
        }catch {
            print(error)
        }
    }
    
}

