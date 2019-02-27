//
//  ViewController.swift
//  ClearPicture
//
//  Created by pasan vimukthi wijesuriya on 2/20/19.
//  Copyright © 2019 Trumpcode. All rights reserved.
//

import UIKit

class CPHomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    var imageArray = [UIImage(named: "shoe"),UIImage(named: "nike"), UIImage(named: "shoe3"), UIImage(named: "shoe4")]
    
    @IBOutlet weak var CPcardOne: UIView!
    @IBOutlet weak var CPcardSecond: UIView!
    @IBOutlet weak var CPpageControl: UIPageControl!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var CpProductNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CPcardOne.setUiViewShadows(view: CPcardOne)
        CPcardSecond.setUiViewShadows(view: CPcardSecond)
        CPpageControl.numberOfPages = imageArray.count
        CpProductNameLabel.text = "Nike Air Max 270"
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionViewCell", for: indexPath) as! imageCollectionViewCell
        
        cell.image.image = imageArray[indexPath.row]
        
        return cell
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
        let index = scrollView.contentOffset.x / witdh
        let roundedIndex = round(index)
        self.CPpageControl?.currentPage = Int(roundedIndex)
    }

}


