//
//  CPCheckboxTableViewCell.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 6/6/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPCheckboxTableViewCell: UITableViewCell , UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var QuestionNumber: UILabel!
    @IBOutlet weak var Question: UILabel!
    @IBOutlet weak var CheckboxesTable: UITableView!
    
    var items = [""]
    
    var ans = [Answers]()
    
    var qcodee : String!
    var qnumber : String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        CheckboxesTable.delegate = self
        CheckboxesTable.dataSource = self
        
        self.CheckboxesTable.register(UINib(nibName: "CPCheckBoxeTableViewCell", bundle: nil), forCellReuseIdentifier: "checkboxCell")
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkboxCell", for: indexPath) as! CPCheckBoxeTableViewCell
        cell.CheckBoxTitle.text = items[indexPath.row]
        cell.CheckboxImage.image = UIImage(named: "uncheck")
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! CPCheckBoxeTableViewCell
        
        if cell.CheckboxImage.image == UIImage(named: "uncheck") {
            cell.CheckboxImage.image = UIImage(named: "checkbox")
            
            ans.append(Answers(number: "\(indexPath.row)", answer: "\(items[indexPath.row])", qcode: qcodee))
//            checkboxState.append("\(indexPath.row)")
//            selectedAnswers.append("\(items[indexPath.row])")
        } else if cell.CheckboxImage.image == UIImage(named: "checkbox") {
            cell.CheckboxImage.image = UIImage(named: "uncheck")
            
            if ans.isEmpty == false {
                
                let gotindex = ans.firstIndex(where: { $0.number == "\(indexPath.row)" })!
                
               
                
                if gotindex >= 0 {
                     print("got data for index \(indexPath.row) :: \(ans[gotindex])")
                     let results = ans.filter {  $0.number == "\(indexPath.row)" }
                    print("occurences :: \(results.count)")
                    
                        
                        ans.removeAll { (Answers) -> Bool in
                            Answers.number == "\(indexPath.row)"
                        }
                    
                    
                } else {
                    
                     ans.removeAll()
                     print("nil was there")
                }
                
                
                
            }
            
//            if checkboxState.isEmpty && checkboxState.count <= 0 {
//
//                print("count :: \(checkboxState.count) & hf :: \(checkboxState.isEmpty)")
//
//            } else {
//                print("indexpath is :: \(indexPath.row)")
//
//                if indexPath.row == 0 {
//
//                    checkboxState.removeAll()
//
//                }  else  {
//
//                    print("indexpath :: \(indexPath.row)")
//
//                    checkboxState.remove(at: (indexPath.row))
//                    selectedAnswers.remove(at: (indexPath.row))
//
//                }
//
//
//
//            }
            
        }
        
        
        
        
        
        
//        cell.CheckboxImage.image = UIImage(named: "checkbox")
//
//        if String(indexPath.row) == checkboxState[indexPath.row] {
//
//            print("selected answrs are :: answer \(checkboxState[indexPath.row]) = \(selectedAnswers[indexPath.row])")
//        } else {
//
//
//
//        }
        
        
        
        
        
        
    }
    
}


class Answers {
    var number = String()
    var answer = String()
    var qcode = String()
    
    init(number:String, answer:String, qcode:String){
        self.number = number
        self.answer = answer
        self.qcode = qcode
    }
}
