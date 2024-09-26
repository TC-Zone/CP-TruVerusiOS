//
//  CPRatingTableViewCell.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 6/6/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPRatingTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    

    @IBOutlet weak var QuestionNumber: UILabel!
    @IBOutlet weak var Question: UILabel!
    @IBOutlet weak var Picker: UIPickerView!
    
    var ratingList = [""]
    var answerList = [String?]()
    var qcodee : String!
    var qnumber : String!
    
    var selectedRating = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Picker.dataSource = self
        Picker.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return ratingList.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        //self.endEditing(true)
        return ratingList[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedRating = ratingList[row]
        
    }
    
}
