//
//  CPAllCommunityViewViewController.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 6/18/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SVProgressHUD

class CPAllCommunityViewViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var CommunityArray = [CommunityData]()

    @IBOutlet weak var AllCommunitiesCollectionview: UICollectionView!
    
    var imagelist = [String]()
    var nameList = [String]()
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AllCommunitiesCollectionview.dataSource = self
        AllCommunitiesCollectionview.delegate = self
        addSlideMenuButton()
        communityStartUp()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadProducts), name: NSNotification.Name(rawValue: "loadProducts"), object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AllCommunitiesCollectionview.reloadData()
    }
    
    
    @objc func loadProducts () {
        print("fuck fuck fuck")
        let _ = getPurchasedProducts { (Bool) in
            print("succeeeded purchased data collecting..resuming..")
        }
        
    }
    
    func communityStartUp() {
        
        
        if defaults.value(forKey: keys.RegisteredUserID) != nil {
            
            getPurchasedProducts { (success) in
                // load community main
                
                let count = productCollectionBucket.communityList.count
                
                if count > 0 {
                    
                    productCollectionBucket.communityNamelist.removeAll()
                    productCollectionBucket.imageidlist.removeAll()
                    
                    for i in 0...(count - 1) {
                        
                        if productCollectionBucket.communityList[i] != "" {
                            
                            
                            self.getCommunityData(communityID: "\(productCollectionBucket.communityList[i])", round: i)
                            
                        } else {
                            
                            print("com id was nil")
                            
                        }
                        
                    }
                    
                    
                }
                
            }
            
            
            
        } else {
            
            print("user id was nil")
            
        }
        
       
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if productCollectionBucket.imageidlist.isEmpty == false {
            
            if productCollectionBucket.imageidlist.count > 0 {
                return productCollectionBucket.imageidlist.count
            } else {
                return 0
            }
            
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllComCell", for: indexPath) as! CPAllCommunityCollectionViewCell
        
        if productCollectionBucket.imageidlist.isEmpty == false || productCollectionBucket.communityNamelist.isEmpty == false {
            
            let imgUrl = URL(string: productCollectionBucket.imageidlist[indexPath.row])
            
            if imgUrl != nil {
                
                cell.ColImage.kf.setImage(with: imgUrl)
                
            } else {
                
                cell.ColImage.image = UIImage(named: "noimage")
                
            }
            
            cell.ColName.text = productCollectionBucket.communityNamelist[indexPath.row]
            
            
        } else {
            print("no data found for feedback \(indexPath.row)")
        }
        cell.ColImage.layer.borderWidth = 2.0
        cell.ColImage.layer.masksToBounds = false
        cell.ColImage.layer.borderColor = UIColor(named: "TextAreaGray")?.cgColor
        cell.ColImage.layer.cornerRadius = cell.ColImage.frame.size.width / 2
        cell.ColImage.clipsToBounds = true
        
        
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: (cell.contentView.layer.cornerRadius)).cgPath
        cell.layer.backgroundColor = UIColor.white.cgColor
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! CPAllCommunityCollectionViewCell
        if collectionView == AllCommunitiesCollectionview {
            
            if productCollectionBucket.featureCom.isEmpty == false   {
                
                let txt = cell.ColName.text
                
                
                let res = productCollectionBucket.featureCom.filter { $0.ComName ==  txt}
                
                if res.count > 0 {
                    print("got for filter \(indexPath.row) :: \(res[0].comID)")
                    
                    getCommunityData(CommunityID: "\(res[0].comID)")
                    
                } else {
                    
                    print("empty com list item found")
                    
                }
                
                
                
                
                
            } else {
                
                print("list was empty")
            }
            
            
            
        }
        else {
        }
        
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


extension CPAllCommunityViewViewController {
    
    private func getCommunityData(CommunityID : String){
        showProgressHud()
        
        let token = defaults.value(forKey: keys.accesstoken)
        
        
        let tokenResult = validateToken(token: token)
        
        if tokenResult == true {
            
            if CommunityID != nil && CommunityID != "" {
                
                
                print("current access token is :: \(token)")
                
                let headers: [String: String] = ["Authorization": "Bearer "+(token as! String)]
                
                print("community recieved :: \(CommunityID)")
                
                let url = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.COMMUNITY_DATA_VIEW + "\(CommunityID ?? "")") as String
                
                print("url is :: \(url)")
                //        let parameters : [String : Any] = ["authCode=" : "89a9a3077550a1f6df9066a6091017a13e1a266e01e1b071093a4b75a84f338cf979056621a5d2a455c23ebeb2deb74b5cace5c9c6e10620a5741af3d67d5f1b2b752134e9c9"]
                
                let parameters : [String : Any] = [:]
                
                if let url = URL(string: url) {
                    ApiManager.shared().makeRequestAlamofire(route: url, method: .get, autherized: false, parameter: parameters, header: headers){ (response) in
                        SVProgressHUD.dismiss()
                        switch response{
                        case let .success(data):
                            self.serializeCommunityDataResponse(data: data, com: CommunityID)
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
                                        self.getCommunityData(CommunityID: CommunityID)
                                        print(response)
                                    case .failure(let error):
                                        print("error in retrieving new access token :: \(error)")
                                    }
                                })
                            }
                        }
                    }
                } else {
                    
                    print("community id was nil")
                    
                }
                
            } else {
                
                
                
            }
            
        }
        
    }
    
    func serializeCommunityDataResponse(data: Data, com : String) {
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            print("data in response :: \(json)")
            guard let CommunityResponse: CommunityData = Mapper<CommunityData>().map(JSONObject: json) else {
                return
            }
            self.CommunityArray = [CommunityResponse]
            communityBase.communityArrayBase = CommunityArray
            print("data array count :: \(CommunityArray.count)")
            print("status of community response :: \(CommunityResponse.status)")
            print("status of community description :: \(CommunityResponse.content?.description)")
            print("status of community name :: \(CommunityResponse.content?.name)")
            print("status of community id :: \(CommunityResponse.content?.id)")
            print("status of community status :: \(CommunityResponse.content?.status)")
            print("status of community client id :: \(CommunityResponse.content?.client?.id)")
            print("status of community client name :: \(CommunityResponse.content?.client?.name)")
            
            let story = UIStoryboard.init(name: "CPCommunity", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "CPCommunityMainViewController") as! CPCommunityMainViewController
            vc.community = com
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.pushViewController(vc, animated: true)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadComData"), object: nil)
            
            
            
            
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
    
    
    
    
    
    private func getCommunityData(communityID : String, round : Int){
        showProgressHud()
        
        let token = defaults.value(forKey: keys.accesstoken)
        
        
        let tokenResult = validateToken(token: token)
        
        if tokenResult == true {
            
            if communityID != "" {
                
                
                print("current access token is :: \(token ?? "")")
                
                let headers: [String: String] = ["Authorization": "Bearer "+(token as! String)]
                
                print("community recieved :: \(communityID)")
                
                let url = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.COMMUNITY_DATA_VIEW + "\(communityID )") as String
                
                print("url is :: \(url)")
                //        let parameters : [String : Any] = ["authCode=" : "89a9a3077550a1f6df9066a6091017a13e1a266e01e1b071093a4b75a84f338cf979056621a5d2a455c23ebeb2deb74b5cace5c9c6e10620a5741af3d67d5f1b2b752134e9c9"]
                
                let parameters : [String : Any] = [:]
                
                if let url = URL(string: url) {
                    ApiManager.shared().makeRequestAlamofire(route: url, method: .get, autherized: false, parameter: parameters, header: headers){ (response) in
                        SVProgressHUD.dismiss()
                        switch response{
                        case let .success(data):
                            self.serializeCommunityDataResponse(data: data, round: round)
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
                                        self.getCommunityData(communityID: communityID, round: round)
                                        print(response)
                                    case .failure(let error):
                                        print("error in retrieving new access token :: \(error)")
                                    }
                                })
                            }
                        }
                    }
                } else {
                    
                    print("community id was nil")
                    
                }
                
            } else {
                
                
                
            }
            
        }
        
    }
    
    func serializeCommunityDataResponse(data: Data, round : Int) {
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            print("data in response :: \(json)")
            guard let CommunityResponse: CommunityData = Mapper<CommunityData>().map(JSONObject: json) else {
                return
            }
            
            
            
            print("status of community response :: \(CommunityResponse.status)")
            print("status of community description :: \(CommunityResponse.content?.description)")
            print("status of community name :: \(CommunityResponse.content?.name)")
            print("status of community id :: \(CommunityResponse.content?.id)")
            print("status of community status :: \(CommunityResponse.content?.status)")
            print("status of community client id :: \(CommunityResponse.content?.client?.id)")
            print("status of community client name :: \(CommunityResponse.content?.client?.name)")
            
            productCollectionBucket.featureCom.append(comListFeatures(comID: CommunityResponse.content?.id ?? "", ComName: CommunityResponse.content?.name ?? ""))
            
            let imageurl = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.CLIENT_IMAGE_BY_ID + "\(CommunityResponse.content?.client?.id ?? "")") as String
            
            productCollectionBucket.communityNamelist.append(CommunityResponse.content?.name ?? "")
            productCollectionBucket.imageidlist.append(imageurl)
            
            print("imageidlist is :: \(productCollectionBucket.imageidlist)")
            print("com names is :: \(productCollectionBucket.communityNamelist)")
            
            print("round is :: \(round)")
            print("bucket is :: \(productCollectionBucket.communityList.count)")
            
            if round == ((productCollectionBucket.communityList.count) - 1) {
               
                AllCommunitiesCollectionview.reloadData()
                
            }
   
            
            
        }catch {
            print(error)
        }
    }
    
    
    
    
    /////////////
    
    private func getPurchasedProducts(completion: @escaping (_ success: Bool) -> Void){
        
        showProgressHud()
        
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
                        completion(true)
                        print("hereee")
                        print(response)
                    case .failure(let error):
                        print("fail errorr :::::: \(error.errorCode)")
                        completion(false)
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
            
            
            
            productCollectionBucket.communityList.removeAll()
            productCollectionBucket.featureCom.removeAll()
            
            if proCollectionResponse.status == "OK" {
                
                if proCollectionResponse.content != nil {
                    
                    let count = proCollectionResponse.content?.count ?? 0
                    
                    if count > 0 {
                        
                        productCollectionBucket.communityNamelist.removeAll()
                        productCollectionBucket.imageidlist.removeAll()
                        comlistforfeedback.comlistforfeedbackdata.removeAll()
                        
                        for i in 0...(count - 1) {
                            
                            if proCollectionResponse.content?[i].productDetail?.product?.communityId != "" {
                                
                                
                                if productCollectionBucket.communityList.contains(proCollectionResponse.content?[i].productDetail?.product?.communityId ?? "") {
                                    
                                    
                                } else {
                                    
                                    productCollectionBucket.communityList.append(proCollectionResponse.content?[i].productDetail?.product?.communityId ?? "")
                                    
                                    
                                    
                                }
                                
                                comlistforfeedback.comlistforfeedbackdata.append(proCollectionResponse.content?[i].productDetail?.product?.communityId ?? "")
                                
                                
                            } else {
                                
                                print("com id was nil")
                                
                            }
                            
                        }
                        
                        
                    }
                    
                    print("community cpntent is empty")
                    print("community array is \(productCollectionBucket.communityList)")
                    
                }
                
            }
            
            
            
        }catch {
            print(error)
        }
    }
    
 
}



