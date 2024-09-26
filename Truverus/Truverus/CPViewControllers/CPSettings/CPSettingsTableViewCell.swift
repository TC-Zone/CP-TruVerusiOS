//
//  CPSettingsTableViewCell.swift
//  Truverus
//
//  Created by User on 13/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPSettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var SettingIcon: UIImageView!
    
    @IBOutlet weak var SettingTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
