//
//  CPMyAccountViewController.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 4/1/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit
import GoogleSignIn
import CoreData
import Kingfisher

class CPMyAccountViewController: UIViewController {

    @IBOutlet weak var MenuButton: UIBarButtonItem!
    @IBOutlet weak var EditProfileButton: UIButton!
    @IBOutlet weak var ProfilePicture: UIImageView!
    @IBOutlet weak var ProfileName: UILabel!
    @IBOutlet weak var ProfileEmail: UILabel!
    @IBOutlet weak var GenderText: UILabel!
    @IBOutlet weak var BirthdayText: UILabel!
    @IBOutlet weak var AddressText: UILabel!
    @IBOutlet weak var ContactText: UILabel!
    @IBOutlet weak var JobTitleText: UILabel!
    @IBOutlet weak var FashionInterestsText: UILabel!
    @IBOutlet weak var FavouritSportsText: UILabel!
    
    let Transition = CPSlideInTransition()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var userdata = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillData()
        CreateProfilePic()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func MenuAction(_ sender: Any) {
        
        let x = appDelegate.state
        
        print("state is ::: \(x)")
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let MenuViewController : CPMenuViewController = storyboard.instantiateViewController(withIdentifier: "CPMenuViewController") as! CPMenuViewController
        
        let MenuViewController1 : CPLogedOutMenuViewController = storyboard.instantiateViewController(withIdentifier: "CPLogedOutMenuViewController") as! CPLogedOutMenuViewController
        
        if (x == "logedin") {
            
            
            MenuViewController.modalPresentationStyle = .overCurrentContext
            MenuViewController.transitioningDelegate = self
            present(MenuViewController, animated: true)
            
        } else if (x == "logedout") {
            
            
            MenuViewController1.modalPresentationStyle = .overCurrentContext
            MenuViewController1.transitioningDelegate = self
            present(MenuViewController1, animated: true)
            
        }
        
    }
    
    
    
    
    @IBAction func EditProfileButtonAction(_ sender: Any) {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "MyAccount", bundle: nil)
        let vc : CPEditAccountViewController = storyboard.instantiateViewController(withIdentifier: "CPEditAccountViewController") as! CPEditAccountViewController
        
        
        UIApplication.shared.keyWindow?.setRootViewController(vc, options: .init(direction: .toRight, style: .easeIn))
        
    }
    
    
    
    func fillData() {
       
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            
            //userdata.removeAll()
            print("User Has Already signed in using google")
            
            
            
            let fetchRequest : NSFetchRequest<User> = User.fetchRequest()

            do {

                let userdata = try PercistanceService.context.fetch(fetchRequest)
                self.userdata = userdata

            } catch {

                print("Error occured while fetching core data")

            }

            print("user data ::: \(userdata)")
            let img = userdata.last

            if (userdata.count != 0) {

                let url = URL(string: img!.profileimageurl!)!
                ProfilePicture.kf.setImage(with: url)
                ProfileName.text = img!.name!
                ProfileEmail.text = img?.email

            }

            
        } else if FBSDKAccessToken.current() != nil {
            
            print("user is already logged in using facebook")
            let url = URL(string: StructProfile.ProfilePicture.ProfilePicURL)!
            ProfilePicture.kf.setImage(with: url)
            ProfileName.text = StructProfile.ProfilePicture.name
            ProfileEmail.text = StructProfile.ProfilePicture.email
        }
        else {
            print("user is not logged in")
            
            ProfilePicture.image = UIImage(named: "user icon")
            ProfileName.text = ""
            ProfileEmail.text = ""
            
        }
        
        
    }
 
    
    func CreateProfilePic(){

        
        ProfilePicture.layer.borderWidth = 3.0
        ProfilePicture.layer.masksToBounds = false
        ProfilePicture.layer.borderColor = UIColor(named: "TextGray")?.cgColor
        ProfilePicture.layer.cornerRadius = ProfilePicture.frame.size.width / 2
        ProfilePicture.clipsToBounds = true
        

        
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

extension CPMyAccountViewController : UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        Transition.IsPresenting = true
        return Transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        Transition.IsPresenting = false
        return Transition
    }
    
}
