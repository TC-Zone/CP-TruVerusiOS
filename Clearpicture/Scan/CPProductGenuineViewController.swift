//
//  CPProductGenuineViewController.swift
//  Clearpicture
//
//  Created by Hasitha De Mel on 1/20/19.
//  Copyright © 2019 Hasitha. All rights reserved.
//

import UIKit

class CPProductGenuineViewController: UIViewController {

    @IBOutlet weak var btnDetails : UIButton!
    @IBOutlet weak var btnSurvey : UIButton!
    
    var scanResponse : [String : Any]?
    override func viewDidLoad() {
        super.viewDidLoad()
        CPHelper.roundCorners(_view: btnDetails)
        CPHelper.roundCorners(_view: btnSurvey)
    }
    

    @IBAction func startSurvey(sender: Any){
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CPEnterSurveyViewController") as! CPEnterSurveyViewController
        controller.viewmodel = CPEnterSurveyViewModel.instance
        controller.viewmodel!.surveyID = scanResponse!["serverId"] as? String
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
