//
//  CPSettingsViewController.swift
//  Truverus
//
//  Created by User on 25/4/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPSettingsViewController: UIViewController {

    @IBOutlet weak var AppSettingsButton: UIButton!
    @IBOutlet weak var ChangeLanguaageButton: UIButton!
    @IBOutlet weak var ManageLocationButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func AppSettingsButton(_ sender: Any) {
    }
    
    @IBAction func ChangeLanguageButton(_ sender: Any) {
    }
    
     @IBAction func ManageLocationButton(_ sender: Any) {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Settings", bundle: nil)
        let vc : CPMapViewViewController = storyboard.instantiateViewController(withIdentifier: "CPMapViewViewController") as! CPMapViewViewController
        
        UIApplication.shared.keyWindow?.setRootViewController(vc, options: .init(direction: .toRight, style: .easeIn))
        
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
