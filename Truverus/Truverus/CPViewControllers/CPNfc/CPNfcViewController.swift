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

    var viewModel: CPScanViewModel? = nil
    var session: NFCNDEFReaderSession?
    
    var dataSourceArray = [NFCTagData]()
    
    var tagValue : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSlideMenuButton()
        
        viewModel = CPScanViewModel.instance

        // Do any additional setup after loading the view.
    }
    

    @IBAction func ScanButtonAction(_ sender: Any) {
        
        session = NFCNDEFReaderSession.init(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        session?.begin()
        
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("The session was invalidated: \(error.localizedDescription)")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        // Parse the card's information
        
        DispatchQueue.main.async {
            CPHelper.showHud()
        }
        
        var result = ""
        for payload in messages[0].records {
            result += String.init(data: payload.payload.advanced(by: 3), encoding: .utf8)!
        }
        print("result :: \(result)")
        
        tagValue = result
        
        print("tag details result is :: \(tagValue)")
        
        
        
        CPHelper.showHud()
        ValidateTag()
            CPHelper.hideHud()
        
//        DispatchQueue.main.async {
//            CPHelper.showHud()
//        }
//
//        var result = ""
//        for payload in messages[0].records {
//            result += String.init(data: payload.payload.advanced(by: 3), encoding: .utf8)! // 1
//        }
//
//
//        DispatchQueue.main.async {
//            //self.messageLabel.text = result
//            print("result is :: \(result)")
//            if result != "" {
//                let controller = UIStoryboard.init(name: "CPHomeView", bundle: nil).instantiateViewController(withIdentifier: "CPHomeView") as! CPHomeViewController
//                //controller.scanResponse = response
//                self.navigationController?.pushViewController(controller, animated: true)
//            }
//
//        }
        
    }
        
        //IHProgressHUD.dismiss()
        
    //_ response : [String : Any]
    
    
    func goToGunineProductViewController() {
        let controller = UIStoryboard.init(name: "CPHomeView", bundle: nil).instantiateViewController(withIdentifier: "CPHomeView") as! CPHomeViewController
        //controller.scanResponse = response
        self.navigationController?.pushViewController(controller, animated: true)
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


extension CPNfcViewController{
    private func ValidateTag(){
        SVProgressHUD.show()
        
        let headers: [String: String] = [:]
        
        let url = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.AUTHENTICATE_PRODUCT + "authCode=\(tagValue ?? "")") as String
        
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
            
            print("data :: \(dataSourceArray[0].content?.title)")
            
            print("data array \(dataSourceArray)")
            
            print("message :: \(loginResponse.content?.message)")
            print("Product id :: \(loginResponse.content?.productId)")
            
            print("status is :: \(loginResponse.status)")
            
            goToGunineProductViewController()
            //            customerID = loginResponse.subscriberBean?.subscriberId
            //            self.rssSubscrib()
        }catch {
            print(error)
        }
    }
}
