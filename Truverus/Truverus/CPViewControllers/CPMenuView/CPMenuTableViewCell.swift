//
//  CPMenuTableViewCell.swift
//  Truverus
//
//  Created by User on 3/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var SeperatorView: UIView!
    @IBOutlet weak var MenuTitle: UILabel!
    @IBOutlet weak var MenuIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
