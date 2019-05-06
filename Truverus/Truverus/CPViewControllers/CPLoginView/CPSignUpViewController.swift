//
//  CPSignUpViewController.swift
//  Truverus
//
//  Created by User on 30/4/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPSignUpViewController: BaseViewController {

    @IBOutlet weak var FirstNameTextField: UITextField!
    @IBOutlet weak var LastNameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var ReEnterPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addSlideMenuButton()
        InitTextFields()
        // Do any additional setup after loading the view.
    }
    
    func InitTextFields(){
        
        let common = CPcommon()
        common.CreateTextFields(TextField: FirstNameTextField, img: UIImage(named: "name_edit")!)
        common.CreateTextFields(TextField: LastNameTextField, img: UIImage(named: "name_edit")!)
        common.CreateTextFields(TextField: EmailTextField, img: UIImage(named: "email")!)
        common.CreateTextFields(TextField: PasswordTextField, img: UIImage(named: "passwordtextfield")!)
        common.CreateTextFields(TextField: ReEnterPasswordTextField, img: UIImage(named: "passwordtextfield")!)
        
    }
    
    @IBAction func CreateAccountButtonAction(_ sender: Any) {
    }
    
    @IBAction func GoogleSignInButtonAction(_ sender: Any) {
    }
    
    @IBAction func FacebookSignInButtonAction(_ sender: Any) {
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
