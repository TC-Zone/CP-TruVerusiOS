//
//  CPCollectionViewController.swift
//  Truverus
//
//  Created by User on 8/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var Collection: UICollectionView!
    
    let productNames = ["Adidas Jacket","Guccie shoe","Rolex watch","Puffer Jacket"]
    let productImages = [#imageLiteral(resourceName: "jursey"),#imageLiteral(resourceName: "Running"),#imageLiteral(resourceName: "watch"),#imageLiteral(resourceName: "blackJersy")]
    
    let jacketimages = [#imageLiteral(resourceName: "jursey"),#imageLiteral(resourceName: "nikejackShaded")]
    let shoeimages = [#imageLiteral(resourceName: "Running"),#imageLiteral(resourceName: "shoe")]
    let watchtimages = [#imageLiteral(resourceName: "watch"),#imageLiteral(resourceName: "rollexShaded")]
    let jerceytimages = [#imageLiteral(resourceName: "blackJersy"),#imageLiteral(resourceName: "jacketShaded")]
    
    let titles = ["ADIDAS JACKET","GUCCI SHOE","ROLEX WATCH","NIKE WOMEN'S REVERSIBLE HEAVYWEIGHT PUFFER JACKET"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Collection.dataSource = self
        Collection.delegate = self
        
        let layout = self.Collection.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: (self.Collection.frame.size.width - 20) / 2, height: self.Collection.frame.size.height / 2)
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = Collection.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CPCollectionTabCollectionViewCell
        
        cell.collectionCellImage.image = productImages[indexPath.item]
        cell.CollectionCellProductLable.text = productNames[indexPath.item]
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        cell?.contentView.layer.cornerRadius = 6.0
        cell?.contentView.layer.borderWidth = 1.0
        cell?.contentView.layer.borderColor = UIColor.clear.cgColor
        cell?.contentView.layer.masksToBounds = true
        
        cell?.layer.shadowColor = UIColor.lightGray.cgColor
        cell?.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell?.layer.shadowRadius = 6.0
        cell?.layer.shadowOpacity = 1.0
        cell?.layer.masksToBounds = false
        cell?.layer.shadowPath = UIBezierPath(roundedRect: cell!.bounds, cornerRadius: (cell?.contentView.layer.cornerRadius)!).cgPath
        cell?.layer.backgroundColor = UIColor.white.cgColor
        
       addOrRemoveTransferView(sender: "add", index: indexPath.row)
        
        
        animateTransition()
        
    }
    
    
    
    func addOrRemoveTransferView (sender : String, index : Int) {
        
        let news = self.storyboard?.instantiateViewController(withIdentifier: "CPProductScreenVC") as! CPProductScreenViewController
        news.view.frame = self.view.bounds
        news.currentviewFlag = 1
        
        news.image1.image = nil
        news.image2.image = nil
        news.image3.image = nil
        news.image4.image = nil
        
        
        if (sender == "add") {
            
            if (index == 0) {
                news.images = jacketimages
                news.productname = titles[0]
            } else if (index == 1) {
                news.images = shoeimages
                news.productname = titles[1]
            } else if (index == 2) {
                news.images = watchtimages
                news.productname = titles[2]
            } else if (index == 3) {
                news.images = jerceytimages
                news.productname = titles[3]
            }
            
            news.callingFrom = "collection"
            news.setdata()
            self.Collection.isHidden = true
            
            self.view.addSubview(news.view)
            addChild(news)
            news.didMove(toParent: self)
            
        } else if (sender == "Remove") {
            self.Collection.isHidden = false
            removeChild()
        }
        
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.clear.cgColor
        cell?.layer.borderWidth = 0
        
        cell?.contentView.layer.cornerRadius = 0
        cell?.contentView.layer.borderWidth = 0
        cell?.contentView.layer.borderColor = UIColor.clear.cgColor
        cell?.contentView.layer.masksToBounds = true
        
        cell?.layer.shadowColor = UIColor.clear.cgColor
        cell?.layer.shadowOffset = CGSize(width: 0, height: 0.0)
        cell?.layer.shadowRadius = 0.0
        cell?.layer.shadowOpacity = 0.0
        cell?.layer.masksToBounds = false
        cell?.layer.shadowPath = UIBezierPath(roundedRect: cell!.bounds, cornerRadius: (cell?.contentView.layer.cornerRadius)!).cgPath
        cell?.layer.backgroundColor = UIColor.white.cgColor
    }
    
    
    func animateTransition() {
        
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.layer.add(transition, forKey: nil)
        
        
    }
    
    func handleBack() {
        
        addOrRemoveTransferView(sender: "Remove", index: 6)
        
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


extension UIViewController {
    
    func removeChild() {
        self.children.forEach {
            $0.didMove(toParent: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
    }
}
