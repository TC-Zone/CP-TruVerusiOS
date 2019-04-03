//
//  CPCustomCollectionViewCell.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 3/20/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPCustomCollectionViewCell: UICollectionViewCell {
    
//    var avatarImageView: UIImageView = {
//        var avatarView = UIImageView()
//        avatarView.contentMode = .scaleAspectFit
//        
//        return avatarView
//    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        addSubview(avatarImageView)
//
//        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
//        avatarImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        avatarImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//        avatarImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
//        avatarImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
