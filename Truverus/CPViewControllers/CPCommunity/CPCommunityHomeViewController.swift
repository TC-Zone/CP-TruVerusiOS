//
//  CPCommunityHomeViewController.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 4/8/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPCommunityHomeViewController: UIViewController {
    @IBOutlet weak var SegmentControl: CPCustomSegmentedControll!
    
    @IBOutlet weak var EventsContainer: UIView!
    @IBOutlet weak var FeedbackContainer: UIView!
    @IBOutlet weak var PromotionsContainer: UIView!
    @IBOutlet weak var FeedbackSubviewContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        FeedbackContainer.alpha = 1
        PromotionsContainer.alpha = 0
        EventsContainer.alpha = 0
        // Do any additional setup after loading the view.
    }
    

    @IBAction func SegmentValueChanged(_ sender: CPCustomSegmentedControll) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            print("feedback")
            FeedbackContainer.alpha = 1
            PromotionsContainer.alpha = 0
            EventsContainer.alpha = 0
            
        case 1:
            print("promotions")
            PromotionsContainer.alpha = 1
            FeedbackContainer.alpha = 0
            EventsContainer.alpha = 0
            
        case 2:
            print("events")
            EventsContainer.alpha = 1
            PromotionsContainer.alpha = 0
            FeedbackContainer.alpha = 0
            
        default:
            print("nothing in switch")
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
