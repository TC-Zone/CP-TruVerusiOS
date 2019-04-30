//
//  CPMenuViewController.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 3/11/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import Kingfisher
import CoreData
import UIKit.UIGestureRecognizerSubclass

enum MenuType : Int {
    case logo
    case home
    case account
    case nfc
    case inbox
    case community
    case settings
    case help
    case privacy
    case logout
}

class CPMenuViewController: UITableViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var Email: UILabel!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var ProfilePicImage: UIImageView!
    @IBOutlet weak var FirstCell: UITableViewCell!
    @IBOutlet weak var LastCell: UITableViewCell!
    
    @IBOutlet var Table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CreateProfilePic()
        FirstCell.selectionStyle = UITableViewCell.SelectionStyle.none
        LastCell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        self.view.isUserInteractionEnabled = true
        self.Table.isUserInteractionEnabled = true
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        leftSwipe.direction = .left
        
        view.addGestureRecognizer(rightSwipe)
        view.addGestureRecognizer(leftSwipe)
        
        
        //self..addGestureRecognizer(tap)
//        if let window = UIApplication.shared.keyWindow {
//            
//            let blackView = UIView()
//            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
//            
//            window.addSubview(blackView)
//            blackView.frame = window.frame
//            blackView.alpha = 0
//            
//            
//            UIView.animate(withDuration: 0.5) {
//                blackView.alpha = 1
//            }
//            
//        }

        
        //view.addGestureRecognizer(tapp)
        
    }
    
 
    @objc func handleTap(sender: UITapGestureRecognizer? = nil)
    {
        print("hgvsbdchdbvjhdjvkjdfvn")
    }
    
    @objc func handleSwipe (sender : UISwipeGestureRecognizer) {
        
        if sender.state == .ended {
            
            switch sender.direction{
            case .right : print("swiped right")
            
            case .left : self.dismiss(animated: true, completion: nil)
                print("swiped left")
                
            default:
                break
            }
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let menutype = MenuType(rawValue: indexPath.row) else { return }
        
        
        if indexPath.row == 0 || indexPath.row == 10 {
            
        } else if (indexPath.row == 2) {
            
            back(storyboardName: "MyAccount", classname: "CPMyAccountViewController", ClassIdentifierName: "CPMyAccountViewController")
            
        }else if (indexPath.row == 0){
            
            
            //set this to edit profile view
            back(storyboardName: "Login", classname: "CPSignInViewController", ClassIdentifierName: "CPSignInViewController")
            
            
        }else if(indexPath.row == 1) {
          
            back(storyboardName: "Main", classname: "CPHomeScreenViewController", ClassIdentifierName: "CPHomeScreenViewController")
            
        } else if(indexPath.row == 3){
            
            back(storyboardName: "NFC", classname: "CPNfcViewController", ClassIdentifierName: "CPNfcViewController")
            
        } else if (indexPath.row == 4) {
            
            back(storyboardName: "Inbox", classname: "CPInboxViewController", ClassIdentifierName: "CPInboxViewController")
//            back(storyboardName: "NFC", classname: "CPNfcViewController", ClassIdentifierName: "CPNfcViewController")
            
        } else if (indexPath.row == 5) { 
            
            back(storyboardName: "CPCommunity", classname: "CPCommunityHomeViewController", ClassIdentifierName: "CPCommunityHomeViewController")
            
        } else if (indexPath.row == 6) {
            
            back(storyboardName: "Settings", classname: "CPSettingsViewController", ClassIdentifierName: "CPSettingsViewController")
            
        } else if (indexPath.row == 8) {
            
            
            back(storyboardName: "NFC", classname: "CPNfcViewController", ClassIdentifierName: "CPNfcViewController")
                        //dismiss(animated: true)
            
            
        } else if (indexPath.row == 9) {
            
            let alert = UIAlertController(title: "Message", message: "You are succesfully loggd out", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            
            let alert2 = UIAlertController(title: "Message", message: "You are not loggd in", preferredStyle: UIAlertController.Style.alert)
            alert2.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
          
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            if GIDSignIn.sharedInstance().hasAuthInKeychain(){
                print("User Has Already signed in")
                GIDSignIn.sharedInstance().disconnect()
                appDelegate.state = "logedout"
                back(storyboardName: "NFC", classname: "CPNfcViewController", ClassIdentifierName: "CPNfcViewController")
                
            } else if FBSDKAccessToken.current() != nil{
                print("User Has Not signed in")
                let loginManager = FBSDKLoginManager()
                loginManager.logOut()
                appDelegate.state = "logedout"
                back(storyboardName: "NFC", classname: "CPNfcViewController", ClassIdentifierName: "CPNfcViewController")

            } else {
                self.present(alert2, animated: true, completion: nil)
            }
            
            
            
        }else {
            
            dismiss(animated: true)
            
        }
        
        print("Dismissing : \(menutype)")
        
    }
  
    
    func CreateProfilePic(){
        
        if (StructProfile.ProfilePicture.ProfilePicURL != "") {
            
            print("image url is in menu :: \(String(describing: StructProfile.ProfilePicture.ProfilePicURL))")

            let url = URL(string: StructProfile.ProfilePicture.ProfilePicURL)!
            ProfilePicImage.kf.setImage(with: url)
        
        } else {

        ProfilePicImage.image = UIImage(named: "user icon")

        }

        ProfilePicImage.layer.borderWidth = 3.0
        ProfilePicImage.layer.masksToBounds = false
        ProfilePicImage.layer.borderColor = UIColor.white.cgColor
        ProfilePicImage.layer.cornerRadius = ProfilePicImage.frame.size.width / 2
        ProfilePicImage.clipsToBounds = true
        
        
        if (StructProfile.ProfilePicture.email != "" && StructProfile.ProfilePicture.name != "") {
            
            Email.text = StructProfile.ProfilePicture.email
            UserName.text = StructProfile.ProfilePicture.name
            
        }

   }
  
    func back(storyboardName : String, classname : String, ClassIdentifierName: String){
        
       // var navigationController : UINavigationController!

        
        if (classname == "CPNfcViewController"){
            
            let storyboard : UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
            let nfc : CPNfcViewController = storyboard.instantiateViewController(withIdentifier: ClassIdentifierName) as! CPNfcViewController
          //  navigationController = UINavigationController(rootViewController: nfc)
            
             launch(sender: nfc)
            
            
        } else if (classname == "CPInboxViewController") {
            
            let storyboard : UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
            let Inbox : CPInboxViewController = storyboard.instantiateViewController(withIdentifier: ClassIdentifierName) as! CPInboxViewController
            
            launch(sender: Inbox)
            
            
        } else if (classname == "CPHomeScreenViewController") {
            
            let storyboard : UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
            let vc : CPHomeScreenViewController = storyboard.instantiateViewController(withIdentifier: ClassIdentifierName) as! CPHomeScreenViewController
            
            launch(sender: vc)
            
            
        } else if (classname == "CPMyAccountViewController") {
            
            let storyboard : UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
            let Acc : CPMyAccountViewController = storyboard.instantiateViewController(withIdentifier: ClassIdentifierName) as! CPMyAccountViewController
            
            launch(sender: Acc)
            
            //navigationController = UINavigationController(rootViewController: Acc)
          
        } else if (classname == "CPCommunityHomeViewController") {
            
            let storyboard : UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
            let Acc : CPCommunityHomeViewController = storyboard.instantiateViewController(withIdentifier: ClassIdentifierName) as! CPCommunityHomeViewController
            
            launch(sender: Acc)
            
        } else if (classname == "CPSettingsViewController") {
            
            let storyboard : UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
            let setting : CPSettingsViewController = storyboard.instantiateViewController(withIdentifier: ClassIdentifierName) as! CPSettingsViewController
            
            launch(sender: setting)
            
        }
        
        
        
//            navigationController.navigationBar.barTintColor = UIColor.black
//            navigationController.navigationBar.barStyle = .black
//            navigationController.navigationBar.isTranslucent = false
//            navigationController.navigationBar.backgroundColor = UIColor.black
//            navigationController.view.backgroundColor = UIColor.black
//        
//        
//        
//            //self.present(navigationController, animated: true, completion: nil)
//        
//        UIApplication.shared.keyWindow?.setRootViewController(navigationController, options: .init(direction: .toRight, style: .easeIn))
        

    }
    
    func launch(sender : UIViewController){
        
        UIApplication.shared.keyWindow?.setRootViewController(sender, options: .init(direction: .toRight, style: .easeIn))
        
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


extension UIApplication{
    class func getPresentedViewController() -> UIViewController? {
        var presentViewController = UIApplication.shared.keyWindow?.rootViewController
        while let pVC = presentViewController?.presentedViewController
        {
            presentViewController = pVC
        }
        
        return presentViewController
    }
}


