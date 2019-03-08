//
//  CPInitialViewController.swift
//  ClearPicture
//
//  Created by pasan vimukthi wijesuriya on 3/4/19.
//  Copyright © 2019 Trumpcode. All rights reserved.
//

import UIKit
import GoogleSignIn

class CPInitialViewController: UIViewController {

    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var MidViewCard: UIView!
    @IBOutlet weak var ProductViewButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MidViewCard.setUiViewShadows(view: MidViewCard)
        ScrollView.validateScrolling(view: ScrollView)

        initializeFirstView()
        
        // Do any additional setup after loading the view.
    }
    
    func initializeFirstView() {
        if GIDSignIn.sharedInstance().hasAuthInKeychain(){
            
            print("signed in")
            tabBarController?.selectedIndex = 1
            
        } else{
            print("not signed in")
        }
    }
    
    @IBAction func ProductButton(_ sender: Any) {

        tabBarController?.selectedIndex = 1
        
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
