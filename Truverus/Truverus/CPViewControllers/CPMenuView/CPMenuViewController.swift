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
        
        

        // Do any additional setup after loading the view.
    }
    
    
    func ValidateMenuHeaderType() {
        
        let x = appDelegate.state
        
        if (x == "logedin") {
            
            LoginArrow.isHidden = true
//            ProfilePicture.image = UIImage(named: "user icon")
//            ProfileName.text = "Login"
//            ProfileEmail.text = "Welcome to Truverus"
            
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
            
            let topViewController : UIViewController = self.navigationController!.topViewController!
            
            if (topViewController.classForCoder == CPHomeViewController.self) {
                
                foldbackMenu(btnCloseMenuOverlay)
            } else {

                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        
        let x = appDelegate.state
        
        if (x == "logedin") {
            
            if indexPath.row == 1{
                let homeStoryBoard : UIStoryboard = UIStoryboard(name: "CPHomeView", bundle: nil)
                let vc = homeStoryBoard.instantiateViewController(withIdentifier: "CPHomeView") as! CPHomeViewController
                
                self.navigationController?.pushViewController(vc, animated: true)
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
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                } else if FBSDKAccessToken.current() != nil{
                    print("User Has Not signed in")
                    let loginManager = FBSDKLoginManager()
                    loginManager.logOut()
                    appDelegate.state = "logedout"
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                } else {
                    self.present(alert2, animated: true, completion: nil)
                }
                
                
                
            }else {
                
                dismiss(animated: true)
                
            }
            
        }
        
       
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnCloseMenuOverlay(_ sender: Any) {
        
        
        foldbackMenu(btnCloseMenuOverlay)
        
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}



