//
//  CPEventsViewController.swift
//  Truverus
//
//  Created by User on 13/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPEventsViewController: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource {
    
    @IBOutlet weak var EventCollectionView: UICollectionView!
    @IBOutlet weak var EventSubViewContainer: UIView!
    
    
    let titles = ["NIKE SPECIAL EVENT","ADIDAS SPECIAL EVENT"]
    let StartTimes = ["9.00 AM","10.30 AM"]
    let EndDTimes = ["5.00 PM","11.00 PM"]
    let months = ["Feb","Mar"]
    let days = ["02nd","11th"]
    let brandimages = [#imageLiteral(resourceName: "nike logo large"),#imageLiteral(resourceName: "addidas photo")]
    let promosubDescriptions = ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse eu arcu in ligula ultrices placerat. Sed blandit diam vitae pretium vulputate. Nulla vel dignissim velit. Mauris quis arcu rutrum, bibendum ante eget, vehicula ante. Vivamus erat sapien.", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse eu arcu in ligula ultrices placerat. Sed blandit diam vitae pretium vulputate. Nulla vel dignissim velit. Mauris quis arcu rutrum, bibendum ante eget, vehicula ante. Vivamus erat sapien."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EventCollectionView.dataSource = self
        EventCollectionView.delegate = self
        EventSubViewContainer.alpha = 0
        
        let layout = self.EventCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 3, right: 0)
        layout.minimumInteritemSpacing = 1
        
        // Do any additional setup after loading the view.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = EventCollectionView.dequeueReusableCell(withReuseIdentifier: "EventCell", for: indexPath) as! CPEventCollectionViewCell
        
        
        
        cell.Image.image = brandimages[indexPath.item]
        cell.EventTitle.text = titles[indexPath.item]
        cell.StartTime.text = StartTimes[indexPath.item]
        cell.EndTime.text = EndDTimes[indexPath.item]
        cell.Day.text = days[indexPath.item]
        cell.Month.text = months[indexPath.item]
        
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
        
        
        if collectionView == EventCollectionView {
            
            let prtitle = titles[indexPath.item]
            let start = StartTimes[indexPath.item]
            let end = EndDTimes[indexPath.item]
            
            print("selected promotion data :: title : \(prtitle) start : \(start) end : \(end)")
            
            let vc  = self.children[0] as! CPEventSubViewController
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
        self.view.bringSubviewToFront(self.EventSubViewContainer)
        EventSubViewContainer.alpha = 1
        
        
        
        
    }
    
    func handleBack() {
        
        self.view.sendSubviewToBack(self.EventSubViewContainer)
        self.EventSubViewContainer.alpha = 0
        
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
