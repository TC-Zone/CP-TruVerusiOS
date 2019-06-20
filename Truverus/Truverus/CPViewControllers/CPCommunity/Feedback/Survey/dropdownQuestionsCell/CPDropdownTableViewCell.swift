//
//  CPDropdownTableViewCell.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 6/6/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPDropdownTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    
    @IBOutlet weak var QuestionNumber: UILabel!
    @IBOutlet weak var Question: UILabel!
    @IBOutlet weak var textBox: UITextField!
    @IBOutlet weak var dropDown: UIPickerView!
    
    
    var list = [""]
    var selectedAnswer : String! = ""
    var qcodee : String!
    var qnumber : String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textBox.delegate = self
        dropDown.dataSource = self
        dropDown.delegate = self
        dropDown.isHidden = true
        
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
        
        return list.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.endEditing(true)
        return list[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.textBox.text = self.list[row]
        selectedAnswer = textBox.text
        self.dropDown.isHidden = true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.textBox {
            self.dropDown.isHidden = false
            //if you dont want the users to se the keyboard type:
            
            textField.endEditing(true)
        }
        
    }
    
    
    
}
