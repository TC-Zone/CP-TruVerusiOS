//
//  CPCollectionViewController.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 3/25/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var Collection: UICollectionView!
    
    let productNames = ["Adidas Jacket","Guccie shoe","Rolex watch","Puffer Jacket"]
    let productImages = [#imageLiteral(resourceName: "jursey"),#imageLiteral(resourceName: "Running"),#imageLiteral(resourceName: "watch"),#imageLiteral(resourceName: "blackJersy")]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Collection.dataSource = self
        Collection.delegate = self
        
        let layout = self.Collection.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 5, left: 6, bottom: 0, right: 6)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
