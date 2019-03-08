//
//  ViewController.swift
//  ClearPicture
//
//  Created by pasan vimukthi wijesuriya on 2/20/19.
//  Copyright © 2019 Trumpcode. All rights reserved.
//

import UIKit
import GoogleSignIn
class CPHomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    var imageArray = [UIImage(named: "shoe"),UIImage(named: "nike"), UIImage(named: "shoe3"), UIImage(named: "shoe4")]
    
    @IBOutlet weak var CPcardOne: UIView!
    @IBOutlet weak var CPcardSecond: UIView!
    @IBOutlet weak var CPpageControl: UIPageControl!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var CpProductNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.collectionViewLayout = SnapPagingLayout(
            centerPosition: true,
            peekWidth: 1,
            spacing: 2,
            inset: 0
        )
        
        CPcardOne.setUiViewShadows(view: CPcardOne)
        CPcardSecond.setUiViewShadows(view: CPcardSecond)
        CPpageControl.numberOfPages = imageArray.count
        CpProductNameLabel.text = "Nike Air Max 270"
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    
    
    
    @IBAction func InitialViewButton(_ sender: Any) {
        
        tabBarController?.selectedIndex = 0
        
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






class SnapPagingLayout: UICollectionViewFlowLayout {
    private var centerPosition = true
    private var peekWidth: CGFloat = 0
    private var indexOfCellBeforeDragging = 0
    
    convenience init(centerPosition: Bool = true, peekWidth: CGFloat = 40, spacing: CGFloat? = nil, inset: CGFloat? = nil) {
        self.init()
        
        self.scrollDirection = .horizontal
        self.centerPosition = centerPosition
        self.peekWidth = peekWidth
        
        if let spacing = spacing {
            self.minimumLineSpacing = spacing
        }
        
        if let inset = inset {
            self.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        }
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        self.itemSize = calculateItemSize(from: collectionView.bounds.size)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView,
            !newBounds.size.equalTo(collectionView.bounds.size) else {
                return false
        }
        
        itemSize = calculateItemSize(from: collectionView.bounds.size)
        return true
    }
}

private extension SnapPagingLayout {
    
    func calculateItemSize(from bounds: CGSize) -> CGSize {
        return CGSize(
            width: bounds.width - peekWidth * 2,
            height: bounds.height
        )
    }
    
    func indexOfMajorCell() -> Int {
        guard let collectionView = collectionView else { return 0 }
        
        let proportionalOffset = collectionView.contentOffset.x
            / (itemSize.width + minimumLineSpacing)
        
        return Int(round(proportionalOffset))
    }
}

extension SnapPagingLayout {
    
    func willBeginDragging() {
        indexOfCellBeforeDragging = indexOfMajorCell()
    }
    
    func willEndDragging(withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let collectionView = collectionView else { return }
        
        // Stop scrollView sliding
        targetContentOffset.pointee = collectionView.contentOffset
        
        // Calculate where scrollView should snap to
        let indexOfMajorCell = self.indexOfMajorCell()
        
        guard let dataSourceCount = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: 0),
            dataSourceCount > 0 else {
                return
        }
        
        // Calculate conditions
        let swipeVelocityThreshold: CGFloat = 0.5 // After some trail and error
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < dataSourceCount && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging
            && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        
        guard didUseSwipeToSkipCell else {
            // Better way to scroll to a cell
            collectionView.scrollToItem(
                at: IndexPath(row: indexOfMajorCell, section: 0),
                at: centerPosition ? .centeredHorizontally : .left, // TODO: Left ignores inset
                animated: true
            )
            
            return
        }
        
        let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
        var toValue = CGFloat(snapToIndex) * (itemSize.width + minimumLineSpacing)
        
        if centerPosition {
            // Back up a bit to center
            toValue = toValue - peekWidth + sectionInset.left
        }
        
        // Damping equal 1 => no oscillations => decay animation
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: velocity.x,
            options: .allowUserInteraction,
            animations: {
                collectionView.contentOffset = CGPoint(x: toValue, y: 0)
                collectionView.layoutIfNeeded()
        },
            completion: nil
        )
    }
}

