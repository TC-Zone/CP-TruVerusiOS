//
//  CPNfcViewController.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 3/29/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit
import CoreNFC

class CPNfcViewController: UIViewController, NFCNDEFReaderSessionDelegate {

    var viewModel: CPScanViewModel? = nil
    
    @IBOutlet weak var btnScan: UIButton!
    var nfcSession: NFCNDEFReaderSession?
    
    let Transition = CPSlideInTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func MenuButtonAction(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let x = appDelegate.state
        
        print("state is ::: \(x)")
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let MenuViewController : CPMenuViewController = storyboard.instantiateViewController(withIdentifier: "CPMenuViewController") as! CPMenuViewController
        
        let MenuViewController1 : CPLogedOutMenuViewController = storyboard.instantiateViewController(withIdentifier: "CPLogedOutMenuViewController") as! CPLogedOutMenuViewController
        
        if (x == "logedin") {
            
            
            MenuViewController.modalPresentationStyle = .overCurrentContext
            MenuViewController.transitioningDelegate = self
            present(MenuViewController, animated: true)
            
        } else if (x == "logedout") {
            
            
            MenuViewController1.modalPresentationStyle = .overCurrentContext
            MenuViewController1.transitioningDelegate = self
            present(MenuViewController1, animated: true)
            
        }
        
    }
    
    @IBAction func scanPressed(_ sender: Any) {
        nfcSession = NFCNDEFReaderSession.init(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        nfcSession?.begin()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("The session was invalidated: \(error)")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        
        DispatchQueue.main.async {
            CPHelper.showHud()
        }
        
        var result = ""
        for payload in messages[0].records {
            result += String.init(data: payload.payload.advanced(by: 3), encoding: .utf8)!
        }
        print(result)
        result = "fe431407d3d843d0ac58a050372165f9360c37f00cb3b8e17783bcde72fff8c07f67d5747055b0854f25970793f7639b71694f5397a6f2c7f0042dc1fdaed403cf7e9b5c1a19"
        
        CPHelper.showHud()
        viewModel?.scanTag(result, completion: { (status, response) in
            CPHelper.hideHud()
            if status{
                self.goToGunineProductViewController(response!)
            }else{
                let alert = UIAlertController(title: "Sorry", message: "Your authentication code is invalid", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
        
    }
    
    func goToGunineProductViewController(_ response : [String : Any]) {
        let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CPHomeScreenViewController") as! CPHomeScreenViewController
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

extension CPNfcViewController : UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        Transition.IsPresenting = true
        return Transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        Transition.IsPresenting = false
        return Transition
    }
    
}
