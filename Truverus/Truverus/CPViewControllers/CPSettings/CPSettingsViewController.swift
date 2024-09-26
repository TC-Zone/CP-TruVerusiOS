//
//  CPSettingsViewController.swift
//  Truverus
//
//  Created by User on 13/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPSettingsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    

    @IBOutlet weak var Table: UITableView!
    
    let settingslist = ["App Settings","Change Language","Manage Location"]
    let settingslistIcons = [UIImage(named: "setting"),UIImage(named: "LanguageChange"),UIImage(named: "address")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSlideMenuButton()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingslist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CPSettingCell") as? CPSettingsTableViewCell {
            
            cell.SettingIcon.image = settingslistIcons[indexPath.row]
            cell.SettingTitle.text = settingslist[indexPath.row]
            
            return cell
            
        }else {
            
            return CPMenuTableViewCell()
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
            return 60
         
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 2 {
            
            let homeStoryBoard : UIStoryboard = UIStoryboard(name: "ManageLocation", bundle: nil)
            let vc = homeStoryBoard.instantiateViewController(withIdentifier: "CPMapViewController") as! CPMapViewController
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.pushViewController(vc, animated: true)
            
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
