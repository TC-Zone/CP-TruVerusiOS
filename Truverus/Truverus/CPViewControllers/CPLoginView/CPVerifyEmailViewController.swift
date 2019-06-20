//
//  CPVerifyEmailViewController.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 6/6/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SVProgressHUD

class CPVerifyEmailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var first: UITextField!
    @IBOutlet weak var second: UITextField!
    @IBOutlet weak var third: UITextField!
    @IBOutlet weak var fourth: UITextField!
    @IBOutlet weak var fifth: UITextField!
    @IBOutlet weak var sixth: UITextField!
    
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        inittextfields()
        settextDelegates()
        // Do any additional setup after loading the view.
    }
    
    func inittextfields() {
        let common = CPcommon()
        common.createverificationTextFieldBorder(TextField: first)
        common.createverificationTextFieldBorder(TextField: second)
        common.createverificationTextFieldBorder(TextField: third)
        common.createverificationTextFieldBorder(TextField: fourth)
        common.createverificationTextFieldBorder(TextField: fifth)
        common.createverificationTextFieldBorder(TextField: sixth)
    }
    
    func settextDelegates() {
        
        first.delegate = self
        second.delegate = self
        third.delegate = self
        fourth.delegate = self
        fifth.delegate = self
        sixth.delegate = self
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        first.resignFirstResponder()
        second.resignFirstResponder()
        third.resignFirstResponder()
        fourth.resignFirstResponder()
        fifth.resignFirstResponder()
        sixth.resignFirstResponder()
        
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !(string == "") {
            textField.text = string
            if textField == first {
                second.becomeFirstResponder()
            }
            else if textField == second {
                third.becomeFirstResponder()
            }
            else if textField == third {
                fourth.becomeFirstResponder()
            }
            else if textField == fourth {
                fifth.becomeFirstResponder()
            }
            else if textField == fifth {
                sixth.becomeFirstResponder()
            }
            else {
                textField.resignFirstResponder()
                makeVerification()
            }
            return false
        }
        
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                print("Backspace was pressed")
                if textField == sixth {
                    sixth.text = ""
                    fifth.becomeFirstResponder()
                }
                else if textField == fifth {
                    fifth.text = ""
                    fourth.becomeFirstResponder()
                }
                else if textField == fourth {
                    fourth.text = ""
                    third.becomeFirstResponder()
                }
                else if textField == third {
                    third.text = ""
                    second.becomeFirstResponder()
                }
                else if textField == second {
                    second.text = ""
                    first.becomeFirstResponder()
                }
                else {
                    textField.text = ""
                    textField.resignFirstResponder()
                }
                return false
            }
        }
        return true
    }
    
    
    func makeVerification() {
        
        let code = getNumber()
        
        getVerificationData(enteredCode: code)
        
    }
    
    
    func getNumber() -> String {
        let code = "\(first.text ?? "")\(second.text ?? "")\(third.text ?? "")\(fourth.text ?? "")\(fifth.text ?? "")\(sixth.text ?? "")"
        
        return code
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField.text?.count ?? 0) > 0 {
            
        }
        return true
    }
    
    @IBAction func verifyEmailAction(_ sender: Any) {
        
        makeVerification()
        
    }
    
    @IBAction func CancelAction(_ sender: Any) {
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

extension CPVerifyEmailViewController {
    
    private func getVerificationData(enteredCode : String) {
        SVProgressHUD.show()
        
        let savedCode = defaults.value(forKey: keys.RegisteredUserID)
        
        let headers: [String: String] = [:]
            
            let url = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.VERIFY_EMAIL_GETRESULT) as String
            
            print("url is :: \(url)")
            //        let parameters : [String : Any] = ["authCode=" : "89a9a3077550a1f6df9066a6091017a13e1a266e01e1b071093a4b75a84f338cf979056621a5d2a455c23ebeb2deb74b5cace5c9c6e10620a5741af3d67d5f1b2b752134e9c9"]
            
        let parameters : [String : Any] = [
            "id": "\(savedCode ?? "")",
            "verificationCode": enteredCode
        ]
        
        print("Parameters were :: \(parameters)")
        
            if let url = URL(string: url) {
                ApiManager.shared().makeRequestAlamofire(route: url, method: .post, autherized: false, parameter: parameters, header: headers){ (response) in
                    SVProgressHUD.dismiss()
                    switch response{
                    case let .success(data):
                        self.serializeVerificationData(data: data)
                        print("hereee")
                        print(response)
                    case .failure(let error):
                        print("\(error.errorCode)")
                        print("\(error.description)")
                        print("error status code :: \(error.statusCode)")
                        if error.statusCode == 400 {
                            let alert = UIAlertController(title: "Sorry!", message: "Invalid Code please try again", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                       
                    }
                }
            }
    }
    
    
    func serializeVerificationData(data: Data) {
        do{
            print("data is :: \(data.description)")
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            print("data in response :: \(json)")
            guard let verificationResponse: verifyemailData = Mapper<verifyemailData>().map(JSONObject: json) else {
                return
            }
            
            print("verify response was :: \(verificationResponse)")
            
            if verificationResponse.status == "OK" && verificationResponse.content?.user?.status == "ACTIVE" {
                
                let homeStoryBoard : UIStoryboard = UIStoryboard(name: "CPLogin", bundle: nil)
                let vc = homeStoryBoard.instantiateViewController(withIdentifier: "CPLoginView") as! CPLoginViewController
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                
                let alert = UIAlertController(title: "Sorry!", message: "something went wrong", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
            
            
        }catch {
            print(error)
        }
    }
    
    
}
