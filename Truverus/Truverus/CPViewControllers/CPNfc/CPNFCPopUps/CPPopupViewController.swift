//
//  CPPopupViewController.swift
//  Truverus
//
//  Created by User on 21/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import ObjectMapper

class CPPopupViewController: UIViewController {
    
    @IBOutlet weak var LayerView: UIView!
    @IBOutlet weak var PopupView: UIView!
    @IBOutlet weak var producttitle: UILabel!
    @IBOutlet weak var Message: UILabel!
    @IBOutlet weak var Image: UIImageView!
    
    @IBOutlet weak var popupButton: UIButton!
    
    var alert : String!
    var nfcArray = [NFCTagData]()
    
    var productDatasourceArray = [productData]()
    var imageIDArray = [String]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        initPopUpView()
        
        getPurchasedProducts()
        
        // Do any additional setup after loading the view.
    }
    
    
    enum alertType {
        case success
        case failure
        case wrong
    }
    
    
    func showAlert(alertType : alertType){
        
        switch alertType {
        case .success:
            Image.image = UIImage(named: "Ok")
            producttitle.text = "Congragulations!"
            Message.text = "Your product is genuine"
            popupButton.setTitle("Product View", for: .normal)
            print("success is accessed")
            alert = "success"
        case .failure:
            Image.image = UIImage(named: "Sad Mood")
            producttitle.text = "Sorry!"
            Message.text = "Authentication failed due to invalid code"
            popupButton.setTitle("OK", for: .normal)
            alert = "failure"
        case .wrong:
            Image.image = UIImage(named: "Sad Mood")
            producttitle.text = "Sorry!"
            Message.text = "Something went wrong"
            popupButton.setTitle("OK", for: .normal)
            alert = "wrong"
        }
        
    }
    
    @IBAction func popupButtonAction(_ sender: Any) {
        
        
        if alert == "success" {
            print("success is called")
            
            if let parent = self.parent as? CPNfcViewController {
                
                parent.dismissPopUpView()
                
            }
            getProductdata()
            
        } else if alert == "failure" {
            print("failure is called")
            if let parent = self.parent as? CPNfcViewController {
                
                parent.dismissPopUpView()
            }
            
        } else if alert == "wrong" {
            print("wrong is called")
            if let parent = self.parent as? CPNfcViewController {
                
                parent.dismissPopUpView()
            }
        }
        
    }

    
    
    func initPopUpView() {
        
        PopupView.layer.cornerRadius = 20
        PopupView.layer.borderColor = UIColor.black.cgColor
        PopupView.layer.borderWidth = 1
        
    }


}


extension CPPopupViewController {
    
    private func getProductdata(){
        SVProgressHUD.show()
        
        let headers: [String: String] = [:]
        
        let url = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.PRODUCT_DETAILS_VIEW + "\(nfcArray[0].content?.productId ?? "")") as String
        
        print("url is :: \(url)")
        //        let parameters : [String : Any] = ["authCode=" : "89a9a3077550a1f6df9066a6091017a13e1a266e01e1b071093a4b75a84f338cf979056621a5d2a455c23ebeb2deb74b5cace5c9c6e10620a5741af3d67d5f1b2b752134e9c9"]
        
        let parameters : [String : Any] = [:]
        
        if let url = URL(string: url) {
            ApiManager.shared().makeRequestAlamofire(route: url, method: .get, autherized: true, parameter: parameters, header: headers){ (response) in
                SVProgressHUD.dismiss()
                switch response{
                case let .success(data):
                    self.serializeProductDataResponse(data: data)
                    print("hereee")
                    print(response)
                case .failure(_):
                    print("fail")
                }
            }
        }
    }
    
    func serializeProductDataResponse(data: Data) {
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            print("data in response :: \(json)")
            guard let productResponse: productData = Mapper<productData>().map(JSONObject: json) else {
                return
            }
            self.productDatasourceArray = [productResponse]
            
            
            //let imageObjects = productDatasourceArray[0].content?.imageObjects
            print("data array count :: \(productDatasourceArray.count)")
            
            
            
            let imageObjects = productDatasourceArray[0].content?.imageObjects
            
            var tempImgArray = [String]()
            print("image 01 :: \(imageObjects![0].id ?? "default")")
            
            if imageObjects!.count > 4 {
                
                for i in 0...3{
                    
                    //print("image \(i) id :: \(imageObjects![i].id)")
                    let imageID = imageObjects![i].id
                    let imageurl = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.PRODUCT_IMAGES_BY_ID + "\(imageID ?? "")") as String
                    tempImgArray.append(imageurl)
                    
                }
                
            } else {
                 print("image cont :: \(Int(imageObjects!.count))")
               
                for index in (0...Int(imageObjects!.count) - 1) {
                    print("image \(index) id :: \(imageObjects![index].id ?? "")")
                    let imageID = imageObjects![index].id
                    let imageurl = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.PRODUCT_IMAGES_BY_ID + "\(imageID ?? "")") as String
                    tempImgArray.append(imageurl)
                }
                
                
            }
            
            print("image url list new :: \(tempImgArray)")
            
            productStruct.productObj.productTitle = (productResponse.content?.name)!
            productStruct.productObj.ProductDescription = (productResponse.content?.description)!
            productStruct.productObj.youtubeId = (productResponse.content?.videoUrl)!
            productStruct.productObj.ImagesList = (tempImgArray)
            productStruct.productObj.CommunityID = (productResponse.content?.communityId)!
            
            
            let story = UIStoryboard.init(name: "CPHomeView", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "CPHomeView") as! CPHomeViewController
        
            self.navigationController?.pushViewController(vc, animated: true)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
            
            
        }catch {
            print(error)
        }
    }
    
    private func getPurchasedProducts(){
        SVProgressHUD.show()
        
        let headers: [String: String] = [:]
        let userId = defaults.value(forKey: keys.RegisteredUserID)
        
        
        if userId != nil {
            
            let url = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.PURCHASED_PRODUCTS_BY_USER_ID + "\(userId ?? "")") as String
            
            print("url is :: \(url)")
            
            let parameters : [String : Any] = [:]
            
            if let url = URL(string: url) {
                ApiManager.shared().makeRequestAlamofire(route: url, method: .get, autherized: true, parameter: parameters, header: headers){ (response) in
                    SVProgressHUD.dismiss()
                    switch response{
                    case let .success(data):
                        self.serializeproResponse(data: data)
                        print("hereee")
                        print(response)
                    case .failure(let error):
                        print("fail errorr :::::: \(error.errorCode)")
                    }
                }
            }
            
        } else {
            
            SVProgressHUD.dismiss()
            
        }
        
        
    }
    
    func serializeproResponse(data: Data) {
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            print("data in response :: \(json)")
            guard let proCollectionResponse: ProductCollectionBase = Mapper<ProductCollectionBase>().map(JSONObject: json) else {
                return
            }
            
            print("bsjhxbjsbcsjbdb :: \(proCollectionResponse.status)")
            
            productCollectionBucket.productListBucket = [proCollectionResponse]
            //productsList = [proCollectionResponse]
            
            
            
            
            
        }catch {
            print(error)
        }
    }
   
    
}
