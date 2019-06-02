//
//  CPEventSubViewController.swift
//  Truverus
//
//  Created by User on 13/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit
import Kingfisher

class CPEventSubViewController: UIViewController {

    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var EventTitle: UILabel!
    @IBOutlet weak var EventAddress: UILabel!
    @IBOutlet weak var EventDate: UILabel!
    @IBOutlet weak var EventDescription: UILabel!
    @IBOutlet weak var EventStartTime: UILabel!
    @IBOutlet weak var EventEndTime: UILabel!
    
    var starttime : String!
    var endTime : String!
    
    
    let titles = ["NIKE SPECIAL EVENT","ADIDAS SPECIAL EVENT"]
    let StartTimes = ["9.00 AM","10.30 AM"]
    let EndDTimes = ["5.00 PM","11.00 PM"]
    let months = ["Feb","Mar"]
    let days = ["02nd","11th"]
    let brandimages = [#imageLiteral(resourceName: "nike logo large"),#imageLiteral(resourceName: "addidas photo")]
    let promosubDescriptions = ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse eu arcu in ligula ultrices placerat. Sed blandit diam vitae pretium vulputate. Nulla vel dignissim velit. Mauris quis arcu rutrum, bibendum ante eget, vehicula ante. Vivamus erat sapien.", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse eu arcu in ligula ultrices placerat. Sed blandit diam vitae pretium vulputate. Nulla vel dignissim velit. Mauris quis arcu rutrum, bibendum ante eget, vehicula ante. Vivamus erat sapien."]
    let addresses = ["Canada, Toronto City Centre", "California, City Centre"]
    let dates = ["02nd Feb 2019","11th Mar 2019"]
    
    var indexpath = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setdata()
        // Do any additional setup after loading the view.
    }
    
    func setdata() {
        
        if eventBase.eventarraybase[0].content!.count != 0 {
        
        print("indexpath is :: \(indexpath)")
        let imageID = eventBase.eventarraybase[0].content![indexpath].id
        let imageurl = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.EVENT_IMAGE_BY_ID + "\(imageID ?? "")") as String
        let imgUrl = URL(string: imageurl)
        
        if imgUrl != nil {
            
            Image.kf.setImage(with: imgUrl)
            
            
        } else {
            
            Image.image = UIImage(named: "noimage")
            
            }
            
            let start =  eventBase.eventarraybase[0].content![indexpath].startDateTime!
            let startDate = start.prefix(10)
        EventTitle.text = eventBase.eventarraybase[0].content![indexpath].name!
        EventAddress.text = "--"
        EventDate.text = String(startDate)
        EventDescription.text = eventBase.eventarraybase[0].content![indexpath].description!
        EventStartTime.text = starttime
        EventEndTime.text = endTime
            
            
        }else {
                print("no data found on event")
        }
        
    }
    
    
    @IBAction func BackButtonAction(_ sender: Any) {
        
        if let parent = self.parent as? CPEventsViewController {
            let transition = CATransition()
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            parent.view.layer.add(transition, forKey: nil)
            parent.handleBack()
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
