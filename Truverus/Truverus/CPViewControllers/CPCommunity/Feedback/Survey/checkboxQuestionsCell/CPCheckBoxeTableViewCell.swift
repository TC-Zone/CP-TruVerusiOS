//
//  CPCheckBoxeTableViewCell.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 6/13/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPCheckBoxeTableViewCell: UITableViewCell {

    @IBOutlet weak var CheckBoxTitle: UILabel!
    @IBOutlet weak var CheckboxImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
