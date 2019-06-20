//
//  CPMenuViewController.swift
//  Truverus
//
//  Created by User on 30/4/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit
import Kingfisher
import Alamofire
import ObjectMapper
import SVProgressHUD

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}

class CPMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var MenuTable: UITableView!
    @IBOutlet weak var LoginArrow: UIImageView!
    @IBOutlet weak var ProfileEmail: UILabel!
    @IBOutlet weak var ProfileName: UILabel!
    @IBOutlet weak var ProfilePicture: UIImageView!
    @IBOutlet weak var btnCloseMenuOverlay: UIButton!
    var btnMenu : UIButton!
    var delegate : SlideMenuDelegate?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    let defaults = UserDefaults.standard
    
    let MenuItems = ["HOME","MY ACCOUNT","NFC SCAN","INBOX","COMMUNITY","SETTINGS","HELP","PRIVECY AND TERMS","LOG OUT"]
    let MenuItemIcons = [UIImage(named: "HomeMenuIcon"),UIImage(named: "AccountMenuIcon"),UIImage(named: "NFCMenuIcon"),UIImage(named: "InboxMenuIcon"),UIImage(named: "Feedback-1"),UIImage(named: "settings"),UIImage(named: "help-1"),UIImage(named: "data privacy"),UIImage(named: "log out-1")]
    
    let LoggedoutMenuItems = ["HOME","NFC SCAN","SETTINGS","HELP","PRIVECY AND TERMS"]
    let LoggedoutMenuItemIcons = [UIImage(named: "HomeMenuIcon"),UIImage(named: "NFCMenuIcon"),UIImage(named: "settings"),UIImage(named: "help-1"),UIImage(named: "data privacy")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MenuTable.dataSource = self
        MenuTable.delegate = self
        self.MenuTable.register(UINib(nibName: "CPShareAppTableViewCell", bundle: nil), forCellReuseIdentifier: "CPShareCell")
        ValidateMenuHeaderType()
        CreateProfilePic()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        //tap.delegate = self // This is not required
        LoginArrow.isUserInteractionEnabled = true
        LoginArrow.addGestureRecognizer(tap)
        
        let x = appDelegate.state
        
        if (x == "logedout") {
            
            ProfileName.isUserInteractionEnabled = true
            ProfileName.addGestureRecognizer(tap2)
            
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        print("hdsbcjdbh")
        
        let homeStoryBoard : UIStoryboard = UIStoryboard(name: "CPLogin", bundle: nil)
        let vc = homeStoryBoard.instantiateViewController(withIdentifier: "CPLoginView") as! CPLoginViewController

        validateMenuOption(vc: vc)
    }
    
    func ValidateMenuHeaderType() {
        
        let x = appDelegate.state
        
        if (x == "logedin") {
            
            LoginArrow.isHidden = true
            
        } else if (x == "logedout") {
            
            LoginArrow.isHidden = false
            ProfilePicture.image = UIImage(named: "user icon")
            ProfileName.text = "Login"
            ProfileEmail.text = "Welcome to Truverus"
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let x = appDelegate.state
        var count : Int = 0
        
        if (x == "logedin") {
            
            count = 10
            
        } else if (x == "logedout") {
            
            count = 6
            
        }
        
        return count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let x = appDelegate.state
        
        
        if let sharecell = tableView.dequeueReusableCell(withIdentifier: "CPShareCell") as? CPShareAppTableViewCell {
            
            if (x == "logedin") {
                
                if (indexPath.row == 9) {
                    
                    return sharecell
                }
                
            } else if (x == "logedout") {
                
                if (indexPath.row == 5) {
                    
                    return sharecell
                }
                
            }
            
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CPMenuCell") as? CPMenuTableViewCell {
            
            ValidateMenuHeaderType()
            if (x == "logedin") {
                
                if (indexPath.row == 5 || indexPath.row == 8){
                    cell.SeperatorView.isHidden = false
                    cell.MenuIcon.image = MenuItemIcons[indexPath.row]
                    cell.MenuTitle.text = MenuItems[indexPath.row]
                     
                }  else {
                    cell.SeperatorView.isHidden = true
                    cell.MenuIcon.image = MenuItemIcons[indexPath.row]
                    cell.MenuTitle.text = MenuItems[indexPath.row]
                    
                }
                
            } else if (x == "logedout") {
                
                if (indexPath.row == 2 || indexPath.row == 4){
                    cell.SeperatorView.isHidden = false
                    cell.MenuIcon.image = LoggedoutMenuItemIcons[indexPath.row]
                    cell.MenuTitle.text = LoggedoutMenuItems[indexPath.row]
                   
                }  else {
                    cell.SeperatorView.isHidden = true
                    cell.MenuIcon.image = LoggedoutMenuItemIcons[indexPath.row]
                    cell.MenuTitle.text = LoggedoutMenuItems[indexPath.row]
                    
                }
            }
            
            
            return cell
            
          
        } else {
            
            return CPMenuTableViewCell()
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (indexPath.row == 9) {
            
            return 75
            
        } else {
            return 42
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            
            let homeStoryBoard : UIStoryboard = UIStoryboard(name: "CPHomeView", bundle: nil)
            let vc = homeStoryBoard.instantiateViewController(withIdentifier: "CPHomeView") as! CPHomeViewController
            
            validateMenuOption(vc: vc)
            
        }
        
        let x = appDelegate.state
        
        if (x == "logedin") {
            
            if indexPath.row == 1{
                let homeStoryBoard : UIStoryboard = UIStoryboard(name: "MyAccount", bundle: nil)
                let vc = homeStoryBoard.instantiateViewController(withIdentifier: "CPMyAccountViewController") as! CPMyAccountViewController
                validateMenuOption(vc: vc)
            }
            
            if indexPath.row == 2 {
                
                let homeStoryBoard : UIStoryboard = UIStoryboard(name: "NFC", bundle: nil)
                let vc = homeStoryBoard.instantiateViewController(withIdentifier: "CPNFCView") as! CPNfcViewController
                validateMenuOption(vc: vc)
                
            }
            
            if indexPath.row == 3 {
                
                let homeStoryBoard : UIStoryboard = UIStoryboard(name: "Inbox", bundle: nil)
                let vc = homeStoryBoard.instantiateViewController(withIdentifier: "CPInboxViewController") as! CPInboxViewController
                validateMenuOption(vc: vc)
                
            }
            
            if indexPath.row == 4 {
                
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

//                let alert = UIAlertController(title: "Sorry!", message: "This menu option is temporarily disabled due to development purposes", preferredStyle: UIAlertController.Style.alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//                    switch action.style{
//                    case .default:
//                        print("default")
//
//                    case .cancel:
//                        print("cancel")
//
//                    case .destructive:
//                        print("destructive")
//
//                    @unknown default:
//                        fatalError()
//                    }}))
//
//                DispatchQueue.main.async {
//                    self.present(alert, animated: true, completion: nil)
//                }
                
                
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadComData"), object: nil)
                
            }
            
            if indexPath.row == 5 {
                
                let homeStoryBoard : UIStoryboard = UIStoryboard(name: "Settings", bundle: nil)
                let vc = homeStoryBoard.instantiateViewController(withIdentifier: "CPSettingsViewController") as! CPSettingsViewController
                validateMenuOption(vc: vc)
                
            }
            
            if (indexPath.row == 8) {
                
                let alert = UIAlertController(title: "Message", message: "You are succesfully loggd out", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                
                let alert2 = UIAlertController(title: "Message", message: "You are not loggd in", preferredStyle: UIAlertController.Style.alert)
                alert2.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                
                let homeStoryBoard : UIStoryboard = UIStoryboard(name: "CPHomeView", bundle: nil)
                let vc = homeStoryBoard.instantiateViewController(withIdentifier: "CPHomeView") as! CPHomeViewController
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                if GIDSignIn.sharedInstance().hasAuthInKeychain(){
                    print("User Has Already signed in")
                    GIDSignIn.sharedInstance().disconnect()
                    appDelegate.state = "logedout"
                    defaults.set(nil, forKey: keys.accesstoken)
                    defaults.set(nil, forKey: keys.RegisteredUserID)
                    StructProductRelatedData.purchaseAvailability = false
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                } else if FBSDKAccessToken.current() != nil{
                    print("User Has Not signed in")
                    let loginManager = FBSDKLoginManager()
                    loginManager.logOut()
                    appDelegate.state = "logedout"
                    defaults.set(nil, forKey: keys.accesstoken)
                    defaults.set(nil, forKey: keys.RegisteredUserID)
                    StructProductRelatedData.purchaseAvailability = false
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                } else if defaults.value(forKey: keys.RegisteredUserID) != nil {
                    
                    appDelegate.state = "logedout"
                    defaults.set(nil, forKey: keys.accesstoken)
                    defaults.set(nil, forKey: keys.RegisteredUserID)
                    defaults.set(nil, forKey: keys.RegisteredUserID)
                    StructProductRelatedData.purchaseAvailability = false 
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    self.present(alert2, animated: true, completion: nil)
                }
                
                
                
            }else {
                
                dismiss(animated: true)
                
            }
            
        } else if (x == "logedout") {
            
            
            if indexPath.row == 1{
                let homeStoryBoard : UIStoryboard = UIStoryboard(name: "NFC", bundle: nil)
                let vc = homeStoryBoard.instantiateViewController(withIdentifier: "CPNFCView") as! CPNfcViewController
                validateMenuOption(vc: vc)
            }
            if indexPath.row == 2{
                let homeStoryBoard : UIStoryboard = UIStoryboard(name: "Settings", bundle: nil)
                let vc = homeStoryBoard.instantiateViewController(withIdentifier: "CPSettingsViewController") as! CPSettingsViewController
                validateMenuOption(vc: vc)
            }
            
        }
        
       
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnCloseMenuOverlay(_ sender: Any) {
        
        
        foldbackMenu(btnCloseMenuOverlay!)
        
        
    }
    
    
    func validateMenuOption(vc : UIViewController) {
        
        
        let topViewController : UIViewController = self.navigationController!.topViewController!
        
        if (topViewController.classForCoder === vc.classForCoder) {
            
            foldbackMenu(btnCloseMenuOverlay!)
        } else {
            
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    func foldbackMenu(_ sender: Any) {
        
        UIView.animate(withDuration: 0.08) {
            self.btnCloseMenuOverlay.alpha = 0
        }
        btnMenu.tag = 0
        btnMenu.isHidden = false
        
        
        if(self.delegate != nil) {
            var index = Int32((sender as AnyObject).tag)
            if(sender as AnyObject === self.btnCloseMenuOverlay){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        self.btnMenu.isHidden = true
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
            
        }) { (finished) in
            self.view.removeFromSuperview()
            self.removeFromParent()
            self.btnMenu.isHidden = false
            self.btnMenu.isEnabled = true
        }
        
        
        
    }
    
    
    func CreateProfilePic(){
        
        if (StructProfile.ProfilePicture.ProfilePicURL != "") &&  StructProfile.ProfilePicture.ProfilePicURL.isEmpty != true {
            
            print("image url is in menu :: \(String(describing: StructProfile.ProfilePicture.ProfilePicURL))")
            
            let url = URL(string: StructProfile.ProfilePicture.ProfilePicURL)
            ProfilePicture.kf.setImage(with: url)
            
        } else {
            
            ProfilePicture.image = UIImage(named: "user icon")
            
        }
        
        ProfilePicture.layer.borderWidth = 3.0
        ProfilePicture.layer.masksToBounds = false
        ProfilePicture.layer.borderColor = UIColor.white.cgColor
        ProfilePicture.layer.cornerRadius = ProfilePicture.frame.size.width / 2
        ProfilePicture.clipsToBounds = true
        
        
        if (StructProfile.ProfilePicture.email != "" && StructProfile.ProfilePicture.name != "") {
            
            ProfileEmail.text = StructProfile.ProfilePicture.email
            ProfileName.text = StructProfile.ProfilePicture.name
            
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


extension CPMenuViewController {
    
    private func getPurchasedProducts(completion: @escaping (_ success: Bool) -> Void){
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
            
            print("bsjhxbjsbcsjbdb :: \(proCollectionResponse.status)")
            
            
            productCollectionBucket.communityList.removeAll()
            productCollectionBucket.featureCom.removeAll()
            
            if proCollectionResponse.status == "OK" {
                
                if proCollectionResponse.content != nil {
                    
                    let count = proCollectionResponse.content?.count ?? 0
                    
                    if count > 0 {
                        
                        productCollectionBucket.communityNamelist.removeAll()
                        productCollectionBucket.imageidlist.removeAll()
                        
                        for i in 0...(count - 1) {
                            
                            if proCollectionResponse.content?[i].productDetail?.product?.communityId != "" {
                                productCollectionBucket.communityList.append(proCollectionResponse.content?[i].productDetail?.product?.communityId ?? "")
                                
                                
                                
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
    
    
    private func getCommunityData(communityID : String, round : Int){
        SVProgressHUD.show()
        
        let token = defaults.value(forKey: keys.accesstoken)
        
        
        let tokenResult = validateToken(token: token)
        
        if tokenResult == true {
            
            if communityID != nil && communityID != "" {
                
                
                print("current access token is :: \(token)")
                
                let headers: [String: String] = ["Authorization": "Bearer "+(token as! String)]
                
                print("community recieved :: \(communityID)")
                
                let url = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.COMMUNITY_DATA_VIEW + "\(communityID ?? "")") as String
                
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
                
                
                let story = UIStoryboard.init(name: "CPCommunity", bundle: nil)
                let vc = story.instantiateViewController(withIdentifier: "AllCommunity") as! CPAllCommunityViewViewController
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.pushViewController(vc, animated: true)
                
                
            }
            
            
//            let story = UIStoryboard.init(name: "CPCommunity", bundle: nil)
//            let vc = story.instantiateViewController(withIdentifier: "CPCommunityMainViewController") as! CPCommunityMainViewController
//            vc.community = community
//            self.dismiss(animated: true, completion: nil)
//            self.navigationController?.pushViewController(vc, animated: true)
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadComData"), object: nil)
            
            
            
            
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
    
}



