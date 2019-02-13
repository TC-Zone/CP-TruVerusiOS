//
//  SelectionCell.swift
//  Message in a Bottle
//
//  Created by Hasitha De Mel on 10/25/18.
//  Copyright © 2018 Appcoda. All rights reserved.
//

import UIKit

class SelectionCell: UITableViewCell {

    @IBOutlet weak var checkBoxContainer: UIView!
    @IBOutlet weak var answerLabel: UILabel!
    var answrType : String? = nil
    var answrObj : [String : Any]? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(_ answr : [String : Any], _ type : String) {
        
        self.answrType = type
        self.answrObj = answr
        
        let circleBox = Checkbox(frame: self.checkBoxContainer.bounds)
        
        if type == "S" {
            circleBox.borderStyle = .circle
            circleBox.checkmarkStyle = .circle
        }else if type == "M"{
            circleBox.borderStyle = .square
            circleBox.checkmarkStyle = .square
        }
        
        circleBox.borderWidth = 1
        circleBox.uncheckedBorderColor = .lightGray
        circleBox.checkedBorderColor = .gray
        circleBox.checkmarkColor = .gray
        circleBox.checkmarkSize = 0.8
        circleBox.checkmarkColor = .blue
        circleBox.isUserInteractionEnabled = false
        //circleBox.addTarget(self, action: #selector(checkboxValueChanged(sender:)), for: .valueChanged)]
        if checkBoxContainer.subviews.count == 0 {
            checkBoxContainer.addSubview(circleBox)
        }
        //checkBoxContainer.clipsToBounds = true
    }
    
    func checkboxValueCheck() {
        let circleBox = self.checkBoxContainer.subviews[0] as! Checkbox
        if circleBox.isChecked{
            print("checked \(self.tag) ")
            circleBox.isChecked = false
        }else {
            print("not checked \(self.tag)")
            circleBox.isChecked = true
        }
        self.checkboxValueChanged(sender: circleBox)
    }
    @objc func checkboxValueChanged(sender: Checkbox) {
        
        if self.answrType == "S" {
            let preAnswer = CPSurveyManager.shared.preSelectedAnswerRadioButton
            let preAnswrID = CPSurveyManager.shared.preSelectedRadioAnswerID
            
            if (preAnswer != nil) {
                preAnswer?.isChecked = false
//                DispatchQueue.main.async {
//                    sender.isChecked = true
//                }
                CPSurveyManager.shared.preSelectedAnswerRadioButton = sender
                if let index = CPSurveyManager.shared.tmpAnswerArray.index(of:preAnswrID!) {
                    CPSurveyManager.shared.tmpAnswerArray.remove(at: index)
                }
            }
            CPSurveyManager.shared.preSelectedAnswerRadioButton = sender
            CPSurveyManager.shared.preSelectedRadioAnswerID = self.answrObj?["id"] as? String
            CPSurveyManager.shared.tmpAnswerArray.append(self.answrObj?["id"] as! String)
        
        }else if self.answrType == "M"{
            
            if sender.isChecked {
                sender.isChecked = false
                CPSurveyManager.shared.preSelectedAnswerCheckBoxes.append(sender)
                CPSurveyManager.shared.tmpAnswerArray.append(self.answrObj?["id"] as! String)
            }else{
                sender.isChecked = true
                if let index = CPSurveyManager.shared.preSelectedAnswerCheckBoxes.index(of:sender) {
                    CPSurveyManager.shared.preSelectedAnswerCheckBoxes.remove(at: index)
                }
                
                let answerID = self.answrObj?["id"] as! String
                if let index = CPSurveyManager.shared.tmpAnswerArray.index(of:answerID) {
                    CPSurveyManager.shared.tmpAnswerArray.remove(at: index)
                }
            }
            
        }
        
        
        //print("checkbox value change: \(sender.isChecked)")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
