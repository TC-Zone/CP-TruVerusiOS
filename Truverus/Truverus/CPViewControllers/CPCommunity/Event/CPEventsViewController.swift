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
        if promotionBase.promoarraybase[0].content!.count != 0 {
            return eventBase.eventarraybase[0].content!.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = EventCollectionView.dequeueReusableCell(withReuseIdentifier: "EventCell", for: indexPath) as! CPEventCollectionViewCell
        
        if eventBase.eventarraybase[0].content!.count != 0 {
            
            let imageID = eventBase.eventarraybase[0].content![indexPath.item].id
            let imageurl = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.EVENT_IMAGE_BY_ID + "\(imageID ?? "")") as String
            let imgUrl = URL(string: imageurl)
            
            if imgUrl != nil {
                
                cell.Image.kf.setImage(with: imgUrl)
                
            } else {
                
                cell.Image.image = UIImage(named: "noimage")
                
            }
            cell.EventTitle.text = eventBase.eventarraybase[0].content![indexPath.item].name
            
            let start =  eventBase.eventarraybase[0].content![indexPath.item].startDateTime!
            let startTime = start.suffix(5)
            print("time :: \(startTime)")
            
            let end =  eventBase.eventarraybase[0].content![indexPath.item].endDateTime!
            let endTime = end.suffix(5)
            print("end time :: \(endTime)")
            let firstChar = Array(start)[5]
            let second = Array(start)[6]
            let month = "\(firstChar)\(second)"
            print("month is :: \(month)")
            
            let dayfirstChar = Array(start)[8]
            let daysecond = Array(start)[9]
            var day = "\(dayfirstChar)\(daysecond)"
            if Int(day) == 01 {
                day = "\(day)st"
            } else if Int(day) == 02 {
                day = "\(day)nd"
            } else if Int(day) == 03 {
                day = "\(day)rd"
            } else {
                day = "\(day)th"
            }
            print("month is :: \(day)")
            
            let year = start.prefix(4)
            
            let monthName = DateFormatter().monthSymbols![Int(month)! - 1]
            print("month name :: \(monthName)")
            cell.StartTime.text = String(startTime)
            cell.EndTime.text = String(endTime)
            cell.Day.text = day
            cell.Month.text = monthName
            cell.Year.text = String(year)
            
            
        } else {
            
            print("No events recieved")
            
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
        
        
        if collectionView == EventCollectionView {
            
            let start =  eventBase.eventarraybase[0].content![indexPath.item].startDateTime!
            let startTime = start.suffix(5)
            let end =  eventBase.eventarraybase[0].content![indexPath.item].endDateTime!
            let endTime = end.suffix(5)
            print("end time :: \(endTime)")
            
            let vc  = self.children[0] as! CPEventSubViewController
            vc.indexpath = indexPath.row
            vc.starttime = String(startTime)
            vc.endTime = String(endTime)
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
