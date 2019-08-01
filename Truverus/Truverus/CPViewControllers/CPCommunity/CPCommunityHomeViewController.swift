//
//  CPCommunityHomeViewController.swift
//  Truverus
//
//  Created by User on 13/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPCommunityHomeViewController: UIViewController {
    
    @IBOutlet weak var SegmentControl: CPCustomSegmentedControll!
    
    @IBOutlet weak var EventsContainer: UIView!
    @IBOutlet weak var FeedbackContainer: UIView!
    @IBOutlet weak var PromotionsContainer: UIView!
    
    var EventsObject = [EventsData]()
    var PromoObject = [PromotionsData]()
    
    var callingFrom : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        FeedbackContainer.alpha = 1
        PromotionsContainer.alpha = 0
        EventsContainer.alpha = 0
        
        if callingFrom == "Eve" {
            
            SegmentControl.buttonTapped(button: SegmentControl.buttons.last!)
            
            FeedbackContainer.alpha = 0
            PromotionsContainer.alpha = 1
            EventsContainer.alpha = 0
            
        } else if callingFrom == "Promo" {
            
            SegmentControl.buttonTapped(button: SegmentControl.buttons[1])
            
            FeedbackContainer.alpha = 0
            PromotionsContainer.alpha = 0
            EventsContainer.alpha = 1
            
        } else if callingFrom == "Feed" {
            
            SegmentControl.buttonTapped(button: SegmentControl.buttons.first!)
            
            FeedbackContainer.alpha = 1
            PromotionsContainer.alpha = 0
            EventsContainer.alpha = 0
            
        }
        
        
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


}
