//
//  CPInboxViewController.swift
//  Truverus
//
//  Created by User on 10/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPInboxViewController: BaseViewController, UICollectionViewDelegate , UICollectionViewDataSource {

    let NotificationTypes = ["New Promotion","Upcoming Events","New Transfer Request"]
    let NotificationImages = [#imageLiteral(resourceName: "inbox_promotion"),#imageLiteral(resourceName: "inbox_events"),#imageLiteral(resourceName: "inbox_transfer")]
    let notifications = ["pr Nike Promotion","ev Nike event","re request from jane","ev Adidas event"]

    
    @IBOutlet weak var InboxCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSlideMenuButton()
        
        InboxCollectionView.dataSource = self
        InboxCollectionView.delegate = self
        
        
        let layout = self.InboxCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 3, right: 0)
        layout.minimumInteritemSpacing = 1
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = InboxCollectionView.dequeueReusableCell(withReuseIdentifier: "InboxCell", for: indexPath) as! CPInboxCollectionViewCell
        
        let v = indexPath.item
        print("vvv ois ::: \(v)")
        cell.CellDescription.text = notifications[indexPath.item]
        
        let first2 = String(notifications[indexPath.item].prefix(2))
        
        print("prefix is :: \(first2)")
        
        if (first2 == "pr") {
            
            cell.CellImage.image = NotificationImages[0]
            cell.CellTitle.text = NotificationTypes[0]
            
        } else if (first2 == "ev") {
            
            cell.CellImage.image = NotificationImages[1]
            cell.CellTitle.text = NotificationTypes[1]
            
        } else if (first2 == "re") {
            
            cell.CellImage.image = NotificationImages[2]
            cell.CellTitle.text = NotificationTypes[2]
            
        }
        
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: (cell.contentView.layer.cornerRadius)).cgPath
        cell.layer.backgroundColor = UIColor.white.cgColor
        
        cell.CellButton.addTarget(self, action: #selector(cellbuttonClicked), for: .touchUpInside)
        
        return cell
    }
    
    
    @objc func cellbuttonClicked() {
        
        //self.navigationItem.hidesBackButton = true
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Inbox", bundle: nil)
        let Acc : CPRemovePopupViewController = storyboard.instantiateViewController(withIdentifier: "CPRemovePopupViewController") as! CPRemovePopupViewController
        
        self.addChild(Acc)
        
        let height  = UIScreen.main.bounds.height
        let width  = UIScreen.main.bounds.width
        
        Acc.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        self.view.addSubview(Acc.view)
        Acc.didMove(toParent: self)
        
        
    }
    
    func handleNavigationButton () {
        
         self.navigationItem.hidesBackButton = false
        
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
