//
//  CPPromotionSubviewViewController.swift
//  Truverus
//
//  Created by User on 13/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPPromotionSubviewViewController: UIViewController {

    @IBOutlet weak var Image: UIImageView!
    
    @IBOutlet weak var Percentage: UILabel!
    @IBOutlet weak var promoTitle: UILabel!
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var StartDate: UILabel!
    @IBOutlet weak var EndDate: UILabel!
    
    var indexpath = Int()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setdata()
        
        // Do any additional setup after loading the view.
    }
    
    
    func setdata() {
        
        print("indexpath is :: \(indexpath)")
        
        if promotionBase.promoarraybase.isEmpty == false {
            
            if promotionBase.promoarraybase[0].content!.count != 0 {
                
                let imageID = promotionBase.promoarraybase[0].content![indexpath].id
                let imageurl = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.PROMOTION_IMAGE_BY_ID + "\(imageID ?? "")") as String
                let imgUrl = URL(string: imageurl)
                
                if imgUrl != nil {
                    
                    Image.kf.setImage(with: imgUrl)
                    
                } else {
                    
                    Image.image = UIImage(named: "noimage")
                    
                }
                
                promoTitle.text = promotionBase.promoarraybase[0].content![indexpath].name
                Description.text = promotionBase.promoarraybase[0].content![indexpath].description
                StartDate.text = promotionBase.promoarraybase[0].content![indexpath].startDate
                EndDate.text = promotionBase.promoarraybase[0].content![indexpath].endDate
                Percentage.text = "\(promotionBase.promoarraybase[0].content![indexpath].percentage ?? "")%"
                
            } else {
                
                print("No promotions Recieved")
                
            }
            
        } else {
            
            print("No promotions Recieved")
            
        }
        
        
        
        
    }
    
    
    @IBAction func BackButtonAction(_ sender: Any) {
        
        if let parent = self.parent as? CPPromotionsViewController {
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
