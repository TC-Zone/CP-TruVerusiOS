//
//  CPTransferViewController.swift
//  Truverus
//
//  Created by User on 9/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SVProgressHUD

class CPTransferViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var SearchTextField: UITextField!
    @IBOutlet weak var SearchTable: UITableView!
    
    var names : [String] = Array()
    var tempNames : [String] = Array()
    
    let defaults = UserDefaults.standard
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createShapes(textss: SearchTextField, tabl: SearchTable)
        SearchTable.delegate = self
        SearchTable.dataSource = self
        
        SearchTable.isHidden = true
        
        SearchTextField.delegate = self
        
        names.append("John doe")
        names.append("John cena")
        names.append("John logi bared")
        names.append("John wick")
        names.append("gon thilina")
        names.append("chicken run shashii")
        
        for name in names {
            
            tempNames.append(name)
            
        }
        
        SearchTextField.addTarget(self, action: #selector(searchRecords(_ :)), for: .editingChanged)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector(("diismissKeyboard")))
        
        
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    
    @objc func diismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        self.SearchTable.isHidden = true
        SearchTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        SearchTextField.resignFirstResponder()
        return true
    }
    
    
    
    
    @objc func searchRecords(_ textField : UITextField){
        
        self.names.removeAll()
        if textField.text?.count != 0 {
            
            self.SearchTable.isHidden = false
            
            for name in tempNames {
                
                if let nameToSearch = textField.text {
                    
                    let range = name.lowercased().range(of: nameToSearch, options: .caseInsensitive, range: nil, locale: nil)
                    
                    if range != nil {
                        self.names.append(name)
                    }
                    
                }
            }
            
        } else {
            
            for name in tempNames {
                
                names.append(name)
                
            }
            
        }
        
        SearchTable.reloadData()
        
    }
    
    func createShapes(textss : UITextField, tabl : UITableView) {
        
        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        textss.leftView = leftView
        textss.leftViewMode = .always
        
        textss.clipsToBounds = true
        textss.layer.cornerRadius = 20
        textss.layer.borderWidth = 2
        textss.layer.borderColor = UIColor(named: "SearchColor")?.cgColor
        textss.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        tabl.clipsToBounds = true
        tabl.layer.cornerRadius = 20
        tabl.layer.borderWidth = 2
        tabl.layer.borderColor = UIColor(named: "SearchColor")?.cgColor
        tabl.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "names")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "names")
        }
        cell?.textLabel?.text = names[indexPath.row]
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currentCell = tableView.cellForRow(at: indexPath)
        self.SearchTextField.text = currentCell!.textLabel?.text
        
        self.SearchTable.isHidden = true
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                print("Backspace was pressed")
                if SearchTextField.text?.count == 1 {
                    self.SearchTable.isHidden = true
                }
            }
        }
        return true
    }
    
    func ShowValidateAlerts(message : String, title : String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    

    @IBAction func TransferButton(_ sender: Any) {
        
        let name = SearchTextField.text!
        
        if name != "" {
            
            
            
            getUserFCMData()
            
            
            
        } else {
            
            
            
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

extension CPTransferViewController {
    
    
    private func getUserFCMData(){
        showProgressHud()
        
        let token = defaults.value(forKey: keys.accesstoken)
        
        
        let tokenResult = validateToken(token: token)
        
        if tokenResult == true {
            
                
                print("current access token is :: \(token)")
                
                let headers: [String: String] = ["Authorization": "Bearer "+(token as! String)]
            
            
            let para = SearchTextField.text
            
            let url = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.GET_USER_FCMDATA_BY_NAME + "\(para ?? "")") as String
            
            let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            print("url converted is :: \(urlString)")
                
                print("url is :: \(url)")
            
                
                let parameters : [String : Any] = [:]
            
                
            if let url = URL(string: urlString!) {
                    ApiManager.shared().makeRequestAlamofire(route: url, method: .get, autherized: false, parameter: parameters, header: headers){ (response) in
                        SVProgressHUD.dismiss()
                        switch response{
                        case let .success(data):
                            self.serializeUserFCMdata(data: data)
                            print("hereee")
                            print(response)
                        case .failure(let error):
                            print("\(error.errorCode)")
                            print("\(error.description)")
                            print("error status code :: \(error.statusCode)")
                            if error.statusCode == 401 { // MARK -: Means access token is expired
                                ApiManager.shared().RetrieveNewAccessToken(callback: { (response) in
                                    switch response {
                                    case let .success(data):
                                        self.serializeNewAccessToken(data: data)
                                        self.getUserFCMData()
                                        print(response)
                                    case .failure(let error):
                                        print("error in retrieving new access token :: \(error)")
                                    }
                                })
                            }
                        }
                    }
                
                
            } else {
                
                
                
            }
            
        }
        
    }
    
    
    func serializeUserFCMdata(data: Data) {
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            print("data in response :: \(json)")
            guard let userFCMdata: userFCMtempserviceModle = Mapper<userFCMtempserviceModle>().map(JSONObject: json) else {
                return
            }
            
            if userFCMdata.content?.count != 0 {
                
                if userFCMdata.content![0].registerToken != "" &&  userFCMdata.content![0].id != "" && productStructforcommunity.productcollectionObj.productID != ""{
                    
                    
                    SendProductTransferRequesst(recipientId: userFCMdata.content![0].id!, product: soldItemData.soldProductNumber, registerToken: userFCMdata.content![0].registerToken!, recipient: SearchTextField.text!)
                    
                    print("product id :: \(productStructforcommunity.productcollectionObj.productID)")
                    print("sold product id : \( soldItemData.soldProductNumber)")
                    print("recipient registertoken :: \(userFCMdata.content![0].registerToken)")
                    print("recipient id :: \(userFCMdata.content![0].id)")
                    
                    ShowValidateAlerts(message: "Transfer request has been sent to \(SearchTextField.text ?? "the recipient") succeffully", title: "Congratulations!")
                    
                    
                    
                } else {
                    print("couldn't resolve all necessery parameters needed")
                    ShowValidateAlerts(message: "Something went wrong", title: "Sorry!")
                }
                
            } else {
                print("no content found on this person")
                ShowValidateAlerts(message: "Couldn't find the recipient", title: "Sorry!")
            }
            
            
            
        }catch {
            print(error)
        }
    }
    
    
    func serializeNewAccessToken(data: Data) {
        do{
            print("data is :: \(data.description)")
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            print("data in response :: \(json)")
            guard let newTokenResponse: RefreshAccessTokenData = Mapper<RefreshAccessTokenData>().map(JSONObject: json) else {
                return
            }
            print("new Access token is :: \(newTokenResponse.access_token)")
            defaults.set(newTokenResponse.access_token, forKey: "Access_Token")
            print("new refresh token is :: \(newTokenResponse.refresh_token)")
            defaults.set(newTokenResponse.refresh_token, forKey: "Refresh_Token")
            print("User defaults updated!!")
            
        }catch {
            print(error)
        }
        
    }
    
    private func validateToken(token : Any?) -> Bool {
        
        if token == nil {
            // Create the alert controller
            let alertController = UIAlertController(title: "Sorry!", message: "You are not loggedIn to view community", preferredStyle: .alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "Login", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
                let homeStoryBoard : UIStoryboard = UIStoryboard(name: "CPLogin", bundle: nil)
                let vc = homeStoryBoard.instantiateViewController(withIdentifier: "CPLoginView") as! CPLoginViewController
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
                NSLog("Cancel Pressed")
            }
            
            // Add the actions
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
            
            return false
        } else {
            return true
        }
        
    }
    
    
    
    
    private func SendProductTransferRequesst(recipientId : String, product : String, registerToken : String, recipient : String){
        SVProgressHUD.show()
        
        let headers: [String: String] = [:]
        
        let url = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.SEND_TRANSFER_REQUEST) as String
        
        let defaults = UserDefaults.standard
        
        let userid = defaults.value(forKey: keys.mobileUserId)
        print("user id of sender :: \(userid ?? "not found")")
        print("user name of sender :: \(StructProfile.ProfilePicture.name)")
        
        if userid != nil && StructProfile.ProfilePicture.name != "" {
            
            print("url is :: \(url)")
//            let parameterss : [String :Any] = ["code" : CPSocialSignInHelper.idToken as Any, "authProvider" : "facebook", "registerToken" : StructProfile.ProfilePicture.FCMToken]
            
            let parameters = [
                "sender": "\(userid!)",
                "recipient": "\(recipientId)",
                "soldProduct": ["id": "\(product)"],
                "transferNotifyRequest": [
                    "senderName": "\(StructProfile.ProfilePicture.name)",
                    "recipientName": "\(recipient)",
                    "registerToken": "\(registerToken)"
                ]
                ] as [String : Any]
            
            if let url = URL(string: url) {
                ApiManager.shared().makeRequestAlamofire(route: url, method: .post, autherized: true, parameter: parameters, header: headers){ (response) in
                    SVProgressHUD.dismiss()
                    switch response{
                    case let .success(data):
                        self.serializeSendProductTransferResponse(data: data)
                        print("hereee")
                        print(response)
                    case .failure(_):
                        print("fail")
                    }
                }
            } else {
                print("couldn't find all the parameters needed")
            }
            
            
        }
        
        
        
    }
    
    func serializeSendProductTransferResponse(data: Data) {
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            print("data in response :: \(json)")
//            guard let loginResponse: googleUserResponse = Mapper<googleUserResponse>().map(JSONObject: json) else {
//                return
//            }
            
            
        }catch {
            print(error)
        }
    }


    
    
    
    
}


struct soldItemData {
    static var soldProductNumber = String()
}

