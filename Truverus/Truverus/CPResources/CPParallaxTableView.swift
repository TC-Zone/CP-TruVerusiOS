//
//  CPParallaxTableView.swift
//  Truverus
//
//  Created by User on 8/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPParallaxTableView: UITableView {
    
    var kTableHeaderHeight: CGFloat = ((UIScreen.main.bounds.height) / 4) * 2.8
    var kTableHeaderCutAway: CGFloat = 80.0
    var kOverlapRatio: CGFloat = 3
    
    private var headerView: UIView?
    private var headerMaskLayer: CAShapeLayer?
    
    func constructParallaxHeader() {
        if self.tableHeaderView !== nil {
            // get the original table header
            headerView = self.tableHeaderView
            // remove the header from table view
            self.tableHeaderView = nil
            
            // add the header back to table view as a subview
            self.addSubview(headerView!)
            let effectiveHeight = kTableHeaderHeight - kTableHeaderCutAway / kOverlapRatio
            self.contentInset = UIEdgeInsets(top: effectiveHeight, left: 0, bottom: 0, right: 0)
            self.contentOffset = CGPoint(x: 0, y: -effectiveHeight)
            
            // construct cut away
            //            headerMaskLayer = CAShapeLayer()
            //            headerMaskLayer!.fillColor = UIColor.black.cgColor
            //            headerView!.layer.mask = headerMaskLayer
            // call the update to calculate header size and cut away
            updateHeaderView()
        }
    }
    
    func updateHeaderView() {
        let effectiveHeight = kTableHeaderHeight - kTableHeaderCutAway / kOverlapRatio
        var headerRect = CGRect(x: 0, y: -effectiveHeight, width: self.bounds.width, height: kTableHeaderHeight)
        if self.contentOffset.y < -effectiveHeight {
            headerRect.origin.y = self.contentOffset.y
            headerRect.size.height = -self.contentOffset.y + kTableHeaderCutAway / kOverlapRatio
        }
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: headerRect.width, y: 0))
        path.addLine(to: CGPoint(x: headerRect.width, y: headerRect.height))
        path.addLine(to: CGPoint(x: 0, y: headerRect.height - kTableHeaderCutAway))
        headerMaskLayer?.path = path.cgPath
        
        headerView?.frame = headerRect
        
    }
    
}
