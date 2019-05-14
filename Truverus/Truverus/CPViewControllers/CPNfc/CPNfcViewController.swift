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

class CPNfcViewController: BaseViewController, NFCNDEFReaderSessionDelegate  {

    
    var session: NFCNDEFReaderSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSlideMenuButton()
        
        

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
        var result = ""
        for payload in messages[0].records {
            result += String.init(data: payload.payload.advanced(by: 3), encoding: .utf8)! // 1
        }
        
       
        DispatchQueue.main.async {
            //self.messageLabel.text = result
            print("result is :: \(result)")
            if result != "" {
                let controller = UIStoryboard.init(name: "CPHomeView", bundle: nil).instantiateViewController(withIdentifier: "CPHomeView") as! CPHomeViewController
                //controller.scanResponse = response
                self.navigationController?.pushViewController(controller, animated: true)
            }
            
        }
        
    }
        
        //IHProgressHUD.dismiss()
        
    
    
    
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
