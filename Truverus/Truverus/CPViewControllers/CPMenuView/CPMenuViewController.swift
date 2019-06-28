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
                
                let story = UIStoryboard.init(name: "CPCommunity", bundle: nil)
                let vc = story.instantiateViewController(withIdentifier: "AllCommunity") as! CPAllCommunityViewViewController
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.pushViewController(vc, animated: true)
  
                
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
                    cleanProductStruct()
                    StructProductRelatedData.purchaseAvailability = false
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                } else if FBSDKAccessToken.current() != nil{
                    print("User Has Not signed in")
                    let loginManager = FBSDKLoginManager()
                    loginManager.logOut()
                    appDelegate.state = "logedout"
                    defaults.set(nil, forKey: keys.accesstoken)
                    defaults.set(nil, forKey: keys.RegisteredUserID)
                    cleanProductStruct()
                    StructProductRelatedData.purchaseAvailability = false
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                } else if defaults.value(forKey: keys.RegisteredUserID) != nil {
                    
                    appDelegate.state = "logedout"
                    defaults.set(nil, forKey: keys.accesstoken)
                    defaults.set(nil, forKey: keys.RegisteredUserID)
                    defaults.set(nil, forKey: keys.RegisteredUserID)
                    cleanProductStruct()
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
    
    func cleanProductStruct() {
        
        productStruct.productObj.productTitle = ""
        productStruct.productObj.ProductDescription = ""
        productStruct.productObj.youtubeId = ""
        productStruct.productObj.ImagesList = []
        productStruct.productObj.CommunityID = ""
        productStruct.productObj.productID = ""
        
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


}



