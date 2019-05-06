//
//  CPLoginViewController.swift
//  Truverus
//
//  Created by User on 30/4/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPLoginViewController: UIViewController {

    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var CheckBox: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        InitTextFields()
        // Do any additional setup after loading the view.
    }
    
    func InitTextFields(){
        
        let common = CPcommon()
        common.CreateTextFields(TextField: EmailTextField, img: UIImage(named: "email")!)
        common.CreateTextFields(TextField: PasswordTextField, img: UIImage(named: "passwordtextfield")!)
        
    }
    
    
    

    
    @IBAction func CheckBoxAction(_ sender: Any) {
        
        if (CheckBox.imageView?.image == UIImage(named: "uncheck")) {
            CheckBox.setImage(UIImage(named: "checkbox"), for: .normal)
        } else {
            CheckBox.setImage(UIImage(named: "uncheck"), for: .normal)
        }
        
    }
    
    @IBAction func ForgotPasswordButtonAction(_ sender: Any) {
    }
    
    @IBAction func FacebookSignInButtonAction(_ sender: Any) {
    }
    
    @IBAction func GoogleSignInButtonAction(_ sender: Any) {
    }
    
    @IBAction func SignInButtonAction(_ sender: Any) {
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
