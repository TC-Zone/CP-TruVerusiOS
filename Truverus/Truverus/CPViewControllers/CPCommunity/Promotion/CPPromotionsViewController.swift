//
//  CPPromotionsViewController.swift
//  Truverus
//
//  Created by User on 13/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPPromotionsViewController: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource {
    
    @IBOutlet weak var PromotionCollectionView: UICollectionView!
    
    let titles = ["NIKE AIR MAX 270","NIKE WOMEN'S REVERSABLE"]
    let images = [#imageLiteral(resourceName: "nikeshoe"),#imageLiteral(resourceName: "blackjer")]
    
    let StartDates = ["02-Feb-2019","18-Feb-2019"]
    let EndDates = ["11-Feb-2019","26-Feb-2019"]
    let percentages = ["25%","50%"]
    @IBOutlet weak var PromotionsSubViewContainer: UIView!
    
    
    let promosubimages = [#imageLiteral(resourceName: "PromoShoe"),#imageLiteral(resourceName: "nike jacket")]
    let promosubDescriptions = ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse eu arcu in ligula ultrices placerat. Sed blandit diam vitae pretium vulputate. Nulla vel dignissim velit. Mauris quis arcu rutrum, bibendum ante eget, vehicula ante. Vivamus erat sapien.", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse eu arcu in ligula ultrices placerat. Sed blandit diam vitae pretium vulputate. Nulla vel dignissim velit. Mauris quis arcu rutrum, bibendum ante eget, vehicula ante. Vivamus erat sapien."]
    
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
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = PromotionCollectionView.dequeueReusableCell(withReuseIdentifier: "PromotionCell", for: indexPath) as! CPPromotionCollectionViewCell
        
        
        
        cell.Image.image = images[indexPath.item]
        cell.ProductTitle.text = titles[indexPath.item]
        cell.StartDate.text = StartDates[indexPath.item]
        cell.EndDate.text = EndDates[indexPath.item]
        cell.Percentage.text = percentages[indexPath.item]
        
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
            
            let prtitle = titles[indexPath.item]
            let start = StartDates[indexPath.item]
            let end = EndDates[indexPath.item]
            
            print("selected promotion data :: title : \(prtitle) start : \(start) end : \(end)")
            
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
