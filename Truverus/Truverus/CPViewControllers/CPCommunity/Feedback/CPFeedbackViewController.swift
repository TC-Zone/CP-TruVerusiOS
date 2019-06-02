//
//  CPFeedbackViewController.swift
//  Truverus
//
//  Created by User on 13/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import Kingfisher
import SVProgressHUD

class CPFeedbackViewController: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource{
    
    
    @IBOutlet weak var FeedbackSubviewContainer: UIView!
    @IBOutlet weak var FeedbackCollectionView: UICollectionView!
    
    let descriptions = ["Nike Air Max 270","Nike Women's Reversible"]
    let images = [#imageLiteral(resourceName: "nikeshoe"),#imageLiteral(resourceName: "blackjer")]
    let Brandimages = [#imageLiteral(resourceName: "nike logo"),#imageLiteral(resourceName: "adidas logo")]
    let communities = ["NIKE COMMUNITY","ADDIDAS COMMUNITY"]
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        FeedbackCollectionView.dataSource = self
        FeedbackCollectionView.delegate = self
        FeedbackSubviewContainer.alpha = 0
        
        
        let layout = self.FeedbackCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 3, right: 0)
        layout.minimumInteritemSpacing = 1
        
        // Do any additional setup after loading the view.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if feedbacksbase.feedbackarraybase[0].content!.count != 0 {
            return feedbacksbase.feedbackarraybase[0].content!.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = FeedbackCollectionView.dequeueReusableCell(withReuseIdentifier: "feedbackCell", for: indexPath) as! CPFeedbackCollectionViewCell
        
        if communityBase.communityArrayBase[0].content?.id != nil || feedbacksbase.feedbackarraybase[0].content![indexPath.row].name != nil {
        
            let imageID = communityBase.communityArrayBase[0].content?.client?.id
            let imageurl = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.CLIENT_IMAGE_BY_ID + "\(imageID ?? "")") as String
            let imgUrl = URL(string: imageurl)
            
            if imgUrl != nil {
                
                cell.BrandImage.kf.setImage(with: imgUrl)
                
            } else {
                
                cell.BrandImage.image = UIImage(named: "noimage")
                
            }
            
        //cell.ProductImage.image = images[indexPath.item]
        cell.FeedbackTitle.text = communityBase.communityArrayBase[0].content?.name
        cell.Description.text = feedbacksbase.feedbackarraybase[0].content![indexPath.row].name
            
        } else {
            print("no data found for feedback \(indexPath.row)")
        }
        cell.BrandImage.layer.borderWidth = 2.0
        cell.BrandImage.layer.masksToBounds = false
        cell.BrandImage.layer.borderColor = UIColor(named: "TextAreaGray")?.cgColor
        cell.BrandImage.layer.cornerRadius = cell.BrandImage.frame.size.width / 2
        cell.BrandImage.clipsToBounds = true
        
        
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
        
        
        if collectionView == FeedbackCollectionView {
            
            let community = communities[indexPath.item]
            let product = descriptions[indexPath.item]
            
            print("selected product data :: community : \(community) product : \(product)")
            
            animateTransition()
            
            //let vc  =  CPFeedbackSubViewController()
            //vc.BackButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
            
            //FeedbackSubviewContainer.alpha = 1
        }
        else {
        }
        
    }
    
    func animateTransition() {
        
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.layer.add(transition, forKey: nil)
        self.view.bringSubviewToFront(self.FeedbackSubviewContainer)
        FeedbackSubviewContainer.alpha = 1
        
    }
    
    func handleBack() {
        
        self.view.sendSubviewToBack(self.FeedbackSubviewContainer)
        self.FeedbackSubviewContainer.alpha = 0
        
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


