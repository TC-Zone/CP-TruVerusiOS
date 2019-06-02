//
//  CPNoProductViewController.swift
//  Truverus
//
//  Created by User on 24/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPNoProductViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func nfcButton(_ sender: Any) {
        
        let homeStoryBoard : UIStoryboard = UIStoryboard(name: "NFC", bundle: nil)
        let vc = homeStoryBoard.instantiateViewController(withIdentifier: "CPNFCView") as! CPNfcViewController
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
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
