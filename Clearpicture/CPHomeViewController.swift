
//
//  CPHomeViewController.swift
//  Clearpicture
//
//  Created by Hasitha De Mel on 1/16/19.
//  Copyright © 2019 Hasitha. All rights reserved.
//

import UIKit

class CPHomeViewController: UIViewController {

    @IBOutlet weak var view1 : UIView!
    @IBOutlet weak var view2 : UIView!
    @IBOutlet weak var view3 : UIView!
    @IBOutlet weak var view4 : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CPHelper.roundCorners(_view: view1)
        CPHelper.roundCorners(_view: view2)
        CPHelper.roundCorners(_view: view3)
        CPHelper.roundCorners(_view: view4)
    }
    
    @IBAction func createAccount(_ sender: Any) {
    }
    
    @IBAction func nfcScan(_ sender: Any) {
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CPScanViewController") as! CPScanViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func evoteClicked(_ sender: Any) {
    }
    @IBAction func surveryClicked(_ sender: Any) {
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
