//
//  CPNoCollectionViewController.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 3/25/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPNoCollectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func SignInButtonAction(_ sender: Any) {
        

        let alert2 = UIAlertController(title: "Message", message: "You are already logged in", preferredStyle: UIAlertController.Style.alert)
        alert2.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let x = appDelegate.state
        
        print("state is ::: \(x)")
        
        if (x == "logedin") {
            
            self.present(alert2, animated: true, completion: nil)
            
        } else if (x == "logedout") {
            
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "CPSignInViewController") as! CPSignInViewController
                    UIApplication.shared.keyWindow?.setRootViewController(newViewController, options: .init(direction: .toLeft, style: .easeIn))
            
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
