//
//  CPPromotionsViewController.swift
//  Truverus
//
//  Created by User on 13/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit
import Kingfisher

class CPPromotionsViewController: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource {
    
    @IBOutlet weak var PromotionCollectionView: UICollectionView!
    
    
    @IBOutlet weak var PromotionsSubViewContainer: UIView!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PromotionCollectionView.dataSource = self
        PromotionCollectionView.delegate = self
        PromotionsSubViewContainer.alpha = 0
        
        let layout = self.PromotionCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 3, right: 0)
        layout.minimumInteritemSpacing = 1
        
        // Do any additional setup after loading the view.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if promotionBase.promoarraybase.isEmpty == false {
            if promotionBase.promoarraybase[0].content!.count != 0 {
                return promotionBase.promoarraybase[0].content!.count
            } else {
                return 0
            }
            
        } else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = PromotionCollectionView.dequeueReusableCell(withReuseIdentifier: "PromotionCell", for: indexPath) as! CPPromotionCollectionViewCell
        
        if promotionBase.promoarraybase[0].content!.count != 0 {
        
        let imageID = promotionBase.promoarraybase[0].content![indexPath.item].id
        let imageurl = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.PROMOTION_IMAGE_BY_ID + "\(imageID ?? "")") as String
        let imgUrl = URL(string: imageurl)
        
        if imgUrl != nil {
            
            cell.Image.kf.setImage(with: imgUrl)
            
        } else {
           
            cell.Image.image = UIImage(named: "noimage")
            
        }
        
        cell.ProductTitle.text = promotionBase.promoarraybase[0].content![indexPath.item].name
        cell.StartDate.text = promotionBase.promoarraybase[0].content![indexPath.item].startDate
        cell.EndDate.text = promotionBase.promoarraybase[0].content![indexPath.item].endDate
        cell.Percentage.text = promotionBase.promoarraybase[0].content![indexPath.item].percentage! + "%"
        
            
        } else {
            
            print("No promotions Recieved")
            
        }
        
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: (cell.contentView.layer.cornerRadius)).cgPath
        cell.layer.backgroundColor = UIColor.white.cgColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if collectionView == PromotionCollectionView {
            
            let vc  = self.children[0] as! CPPromotionSubviewViewController
            vc.indexpath = indexPath.row
            vc.viewWillAppear(true)
            vc.setdata()
            
            animateTransition()
            
        }
        else {
        }
        
    }
    
    func animateTransition() {
        
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.layer.add(transition, forKey: nil)
        self.view.bringSubviewToFront(self.PromotionsSubViewContainer)
        PromotionsSubViewContainer.alpha = 1
        
        
        
        
    }
    
    func handleBack() {
        
        self.view.sendSubviewToBack(self.PromotionsSubViewContainer)
        self.PromotionsSubViewContainer.alpha = 0
        
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
