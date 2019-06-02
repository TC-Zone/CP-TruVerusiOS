//
//  CPNfcViewController.swift
//  Truverus
//
//  Created by User on 10/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit
import CoreNFC
import SVProgressHUD
import ObjectMapper

class CPNfcViewController: BaseViewController, NFCNDEFReaderSessionDelegate  {

    @IBOutlet weak var PopupContainer: UIView!
    
    
    var session: NFCNDEFReaderSession?
    
    var dataSourceArray = [NFCTagData]()
    
    var tagValue : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PopupContainer.alpha = 0
        addSlideMenuButton()
        
 
    }
    
 
    

    @IBAction func ScanButtonAction(_ sender: Any) {
        ValidateTag()
//        session = NFCNDEFReaderSession.init(delegate: self, queue: nil, invalidateAfterFirstRead: true)
//        session?.begin()
//
    }
    
    func popIn(yourView : UIView){
        
        
        yourView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animateKeyframes(withDuration: 0.2, delay: 0.0, options: UIView.KeyframeAnimationOptions.calculationModeDiscrete, animations: {
            
            yourView.alpha = 1
            self.view.bringSubviewToFront(self.PopupContainer)
            yourView.transform = .identity
        }, completion: nil)
        
        
    }
    
    func handleBack() {
        
        self.view.sendSubviewToBack(self.PopupContainer)
        
    }
    
    func popOut(yourView: UIView) {
        yourView.transform = .identity
        UIView.animateKeyframes(withDuration: 0.2, delay: 0.0, options: UIView.KeyframeAnimationOptions.calculationModeDiscrete, animations: {
            yourView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }, completion:{(_ finish : Bool) in
            yourView.alpha = 0
            self.view.sendSubviewToBack(self.PopupContainer)
        }
        )
    }
    
    func dismissPopUpView() {
        popOut(yourView: PopupContainer)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("The session was invalidated: \(error.localizedDescription)")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        // Parse the card's information
        
        var result = ""
        
        for payload in messages[0].records {
            result += String.init(data: payload.payload.advanced(by: 3), encoding: .utf8)!
        }
        print("result :: \(result)")
        
        tagValue = result
        
        ValidateTag()

        
    }


}


extension CPNfcViewController{
    private func ValidateTag(){
        SVProgressHUD.show()
        
        let headers: [String: String] = [:]
        
        //Correct line for nfc reding
//        let url = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.AUTHENTICATE_PRODUCT + "authCode=\(tagValue ?? "")") as String
        
        let url = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.AUTHENTICATE_PRODUCT + "authCode=1ce86a0c55ab4ed1e1071eb041cad13e5ed011f4248a27aa44b39883bb76ce37be8daf1b41bfeb29121f825313289095c2bbc41ed5fdac323bb91913b34e884df15b8c28b0d0" ) as String
        
        print("url is :: \(url)")
//        let parameters : [String : Any] = ["authCode=" : "89a9a3077550a1f6df9066a6091017a13e1a266e01e1b071093a4b75a84f338cf979056621a5d2a455c23ebeb2deb74b5cace5c9c6e10620a5741af3d67d5f1b2b752134e9c9"]
        
        let parameters : [String : Any] = [:]
        
        if let url = URL(string: url) {
            ApiManager.shared().makeRequestAlamofire(route: url, method: .get, autherized: true, parameter: parameters, header: headers){ (response) in
                SVProgressHUD.dismiss()
                switch response{
                case let .success(data):
                    self.serializeTagDataResponse(data: data)
                    print("hereee")
                    print(response)
                case .failure(_):
                    print("fail")
                }
            }
        }
    }
    
    func serializeTagDataResponse(data: Data) {
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            print("data in response :: \(json)")
            guard let loginResponse: NFCTagData = Mapper<NFCTagData>().map(JSONObject: json) else {
                return
            }
            self.dataSourceArray = [loginResponse]
            
            let message = loginResponse.content?.message
            
            let vc  = self.children[0] as! CPPopupViewController
            
            if message == "You Product is Genuine." {
                
                popIn(yourView: PopupContainer)
                
                vc.showAlert(alertType: .success)
                vc.nfcArray = dataSourceArray
                
                
                
            } else if message == "You authentication code is invalid." {
                
                popIn(yourView: PopupContainer)
                vc.showAlert(alertType: .failure)
                
                
            } else {
                
                popIn(yourView: PopupContainer)
                vc.showAlert(alertType: .wrong)
                
                
            }
            
        }catch {
            print(error)
        }
    }
    
}


