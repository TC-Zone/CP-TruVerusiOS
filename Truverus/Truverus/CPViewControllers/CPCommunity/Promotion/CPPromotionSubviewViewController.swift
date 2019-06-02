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
    
    let titles = ["NIKE AIR MAX 270","NIKE WOMEN'S REVERSABLE"]
    
    let StartDates = ["02-Feb-2019","18-Feb-2019"]
    let EndDates = ["11-Feb-2019","26-Feb-2019"]
    let percentages = ["25%","50%"]
    let promosubimages = [#imageLiteral(resourceName: "PromoShoe"),#imageLiteral(resourceName: "nike jacket")]
    let promosubDescriptions = ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse eu arcu in ligula ultrices placerat. Sed blandit diam vitae pretium vulputate. Nulla vel dignissim velit. Mauris quis arcu rutrum, bibendum ante eget, vehicula ante. Vivamus erat sapien.", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse eu arcu in ligula ultrices placerat. Sed blandit diam vitae pretium vulputate. Nulla vel dignissim velit. Mauris quis arcu rutrum, bibendum ante eget, vehicula ante. Vivamus erat sapien."]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setdata()
        
        // Do any additional setup after loading the view.
    }
    
    
    func setdata() {
        
        print("indexpath is :: \(indexpath)")
        
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
