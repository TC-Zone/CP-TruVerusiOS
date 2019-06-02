//
//  CPSignUpViewController.swift
//  Truverus
//
//  Created by User on 30/4/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPSignUpViewController: BaseViewController, UITextFieldDelegate{

    @IBOutlet weak var FirstNameTextField: UITextField!
    @IBOutlet weak var LastNameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var ReEnterPasswordTextField: UITextField!
    @IBOutlet weak var ScrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //addSlideMenuButton()
        InitTextFields()
        settextDelegates()
        ScrollView.validateScrolling(view: ScrollView)
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
    
    func settextDelegates() {
        
        EmailTextField.delegate = self
        PasswordTextField.delegate = self
        FirstNameTextField.delegate = self
        LastNameTextField.delegate = self
        ReEnterPasswordTextField.delegate = self
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        EmailTextField.resignFirstResponder()
        PasswordTextField.resignFirstResponder()
        FirstNameTextField.resignFirstResponder()
        LastNameTextField.resignFirstResponder()
        ReEnterPasswordTextField.resignFirstResponder()
        
        return true
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
