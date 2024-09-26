//
//  CPCommentTableViewCell.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 6/6/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPCommentTableViewCell: UITableViewCell, UITextViewDelegate  {

    @IBOutlet weak var QuestionNumber: UILabel!
    @IBOutlet weak var Question: UILabel!
    @IBOutlet weak var AnswerText: UITextView!
    
    var ValidationStatus : Bool!
    var qcodee : String!
    var qnumber : String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.HideKeyboardWhenTappedAround()
        AnswerText.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        Validate()
    }
    
    func Validate(){
        
        if AnswerText.text.isEmpty != true {
            ValidationStatus = true
        } else {
            ValidationStatus = false
        }
        
    }
    
}
