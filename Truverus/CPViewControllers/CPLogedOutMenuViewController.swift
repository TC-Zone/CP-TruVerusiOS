//
//  CPLogedOutMenuViewController.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 3/22/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

enum menutype : Int {
    case login
    case home
    case nfc
    case settings
    case help
    case privacy
}

class CPLogedOutMenuViewController: UITableViewController {

    @IBOutlet weak var lastcell: UITableViewCell!
    @IBOutlet weak var imageview: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CreateProfilePic()
        lastcell.selectionStyle = UITableViewCell.SelectionStyle.none
        //tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        // Do any additional setup after loading the view.
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let menu = menutype(rawValue: indexPath.row) else { return }
        
        let alert2 = UIAlertController(title: "Message", message: "You are not loggd in", preferredStyle: UIAlertController.Style.alert)
        alert2.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        
        if indexPath.row == 6 {
            
        }else if (indexPath.row == 0){
            
            
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let x = appDelegate.state
            
            print("state is ::: \(x)")
            
            if (x == "logedin") {
                
                self.present(alert2, animated: true, completion: nil)
                
            } else if (x == "logedout") {
                
                back(storyboardName: "Login", classname: "CPSignInViewController", ClassIdentifierName: "CPSignInViewController")
                
            }

            
        }else if (indexPath.row == 1) {
            
            back(storyboardName: "Main", classname: "CPHomeScreenViewController", ClassIdentifierName: "CPHomeScreenViewController")
            
        }else if (indexPath.row == 2) {
            
            back(storyboardName: "NFC", classname: "CPNfcViewController", ClassIdentifierName: "CPNfcViewController")
            
        }else {
            
            dismiss(animated: true)
            
        }
        
        print("Dismissing : \(menu)")
        
    }
    
    func CreateProfilePic(){
        
        imageview.layer.borderWidth = 3.0
        imageview.layer.masksToBounds = false
        imageview.layer.borderColor = UIColor.white.cgColor
        imageview.layer.cornerRadius = imageview.frame.size.width / 2
        imageview.clipsToBounds = true
        
    }
    
    func back(storyboardName : String, classname : String, ClassIdentifierName: String){
        
        var navigationController : UINavigationController!
        
        
        if (classname == "CPNfcViewController"){
            
            let storyboard : UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
            let nfc : CPNfcViewController = storyboard.instantiateViewController(withIdentifier: ClassIdentifierName) as! CPNfcViewController
            navigationController = UINavigationController(rootViewController: nfc)
            navigationController.navigationBar.barTintColor = UIColor.black
            navigationController.navigationBar.barStyle = .black
            navigationController.navigationBar.isTranslucent = false
            navigationController.navigationBar.backgroundColor = UIColor.black
            navigationController.view.backgroundColor = UIColor.black
            UIApplication.shared.keyWindow?.setRootViewController(navigationController, options: .init(direction: .toRight, style: .easeIn))
            
            
        } else if (classname == "CPHomeScreenViewController") {
            
            let storyboard : UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
            let vc : CPHomeScreenViewController = storyboard.instantiateViewController(withIdentifier: ClassIdentifierName) as! CPHomeScreenViewController
            navigationController = UINavigationController(rootViewController: vc)
            navigationController.navigationBar.barTintColor = UIColor.black
            navigationController.navigationBar.barStyle = .black
            navigationController.navigationBar.isTranslucent = false
            navigationController.navigationBar.backgroundColor = UIColor.black
            navigationController.view.backgroundColor = UIColor.black
            UIApplication.shared.keyWindow?.setRootViewController(navigationController, options: .init(direction: .toRight, style: .easeIn))
            
        } else if (classname == "CPSignInViewController") {
            
            let storyboard : UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
            let v : CPSignInViewController = storyboard.instantiateViewController(withIdentifier: ClassIdentifierName) as! CPSignInViewController
            UIApplication.shared.keyWindow?.setRootViewController(v, options: .init(direction: .toRight, style: .easeIn))
            
            
        }
        
        
        
        
        
        
        
        
    }
    
    
}
