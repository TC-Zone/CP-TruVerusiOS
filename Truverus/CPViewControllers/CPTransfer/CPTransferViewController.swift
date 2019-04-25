//
//  CPTransferViewController.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 4/12/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPTransferViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    
    @IBOutlet weak var BackButton: UIButton!
    
    @IBOutlet weak var SearchTextField: UITextField!
    @IBOutlet weak var SearchTable: UITableView!
    
    var names : [String] = Array()
    var tempNames : [String] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createShapes(textss: SearchTextField, tabl: SearchTable)
        SearchTable.delegate = self
        SearchTable.dataSource = self
        
        SearchTable.isHidden = true
        
        SearchTextField.delegate = self
        
        names.append("John doe")
        names.append("John cena")
        names.append("John logi bared")
        names.append("John wick")
        names.append("gon thilina")
        names.append("chicken run shashii")
        
        for name in names {
            
            tempNames.append(name)
            
        }
        
        SearchTextField.addTarget(self, action: #selector(searchRecords(_ :)), for: .editingChanged)
        
        // Do any additional setup after loading the view.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        SearchTextField.resignFirstResponder()
        return true
    }
    
    @objc func searchRecords(_ textField : UITextField){
        
        self.names.removeAll()
        if textField.text?.count != 0 {
            
            self.SearchTable.isHidden = false
            
            for name in tempNames {
                
                if let nameToSearch = textField.text {
                
                    let range = name.lowercased().range(of: nameToSearch, options: .caseInsensitive, range: nil, locale: nil)
                    
                    if range != nil {
                        self.names.append(name)
                    }
                    
                }
            }
            
        } else {
            
            for name in tempNames {
                
                names.append(name)
                
            }
            
        }
        
        SearchTable.reloadData()
        
    }
    
    func createShapes(textss : UITextField, tabl : UITableView) {
        
        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        textss.leftView = leftView
        textss.leftViewMode = .always
        
        textss.clipsToBounds = true
        textss.layer.cornerRadius = 20
        textss.layer.borderWidth = 2
        textss.layer.borderColor = UIColor(named: "SearchColor")?.cgColor
        textss.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        tabl.clipsToBounds = true
        tabl.layer.cornerRadius = 20
        tabl.layer.borderWidth = 2
        tabl.layer.borderColor = UIColor(named: "SearchColor")?.cgColor
        tabl.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]

        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "names")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "names")
        }
        cell?.textLabel?.text = names[indexPath.row]
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currentCell = tableView.cellForRow(at: indexPath)
        self.SearchTextField.text = currentCell!.textLabel?.text
        
        self.SearchTable.isHidden = true
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                print("Backspace was pressed")
                if SearchTextField.text?.count == 1 {
                    self.SearchTable.isHidden = true
                }
            }
        }
        return true
    }
    
    
    @IBAction func BackButtonAction(_ sender: Any) {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : CPHomeScreenViewController = storyboard.instantiateViewController(withIdentifier: "CPHomeScreenViewController") as! CPHomeScreenViewController
        
        UIApplication.shared.keyWindow?.setRootViewController(vc, options: .init(direction: .toLeft, style: .easeIn))
        vc.handleBack()
        
        
    }
    
 
        
       
    
    @IBAction func TransferButton(_ sender: Any) {
        
        let name = SearchTextField.text!
        
        if name != "" {
            
            let alert = UIAlertController(title: "Success!", message: "Transfer Request sent to \(name)", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "Error!", message: "Please select a user to transfer", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
