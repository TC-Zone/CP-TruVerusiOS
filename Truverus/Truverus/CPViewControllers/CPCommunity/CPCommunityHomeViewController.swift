//
//  CPCommunityHomeViewController.swift
//  Truverus
//
//  Created by User on 13/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPCommunityHomeViewController: BaseViewController {
    
    @IBOutlet weak var SegmentControl: CPCustomSegmentedControll!
    
    @IBOutlet weak var EventsContainer: UIView!
    @IBOutlet weak var FeedbackContainer: UIView!
    @IBOutlet weak var PromotionsContainer: UIView!
    
    var EventsObject = [EventsData]()
    var PromoObject = [PromotionsData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSlideMenuButton()
        addSlideSearchButton()
        
        FeedbackContainer.alpha = 1
        PromotionsContainer.alpha = 0
        EventsContainer.alpha = 0
        
//        print("recieved promo id :: \(PromoObject[0].content![0].id)")
//        print("recieved event id :: \(EventsObject[0].content![0].id)")
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
