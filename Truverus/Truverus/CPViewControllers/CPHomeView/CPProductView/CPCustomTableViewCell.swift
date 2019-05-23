//
//  CPCustomTableViewCell.swift
//  Truverus
//
//  Created by User on 8/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPCustomTableViewCell: UITableViewCell {

    
    @IBOutlet weak var PageControll: UIPageControl!
    
    @IBOutlet weak var Descheight: NSLayoutConstraint!
    @IBOutlet weak var ProductNameLabel: UILabel!
    
    @IBOutlet weak var DescriptionTextArea: UITextView!
    
    @IBOutlet weak var WatchHereButton: UIButton!
    
    @IBOutlet weak var TransferButton: UIButton!
    @IBOutlet weak var BackButton: UIButton!
    
    @IBOutlet weak var CommunityButton: UIButton!
    
    
    var youtubeVedioID : String!
    var Community : String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        TransferButton.isHidden = true
//        BackButton.isHidden = true
        
        // Initialization code
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func SetText(description: String , productName: String) {
        
        
        DescriptionTextArea.translatesAutoresizingMaskIntoConstraints = true
        DescriptionTextArea.text = description
        
        
        if self.DescriptionTextArea.contentSize.height > 310{
            
            let height = (contentView.frame.height) / 2
            let screenwid = (UIScreen.main.bounds.width) / 2
            
            DescriptionTextArea.center = CGPoint(x: screenwid, y: height)
            Descheight.constant = 380
            DescriptionTextArea.isScrollEnabled = false
            let buttonHeight: CGFloat = 30
            let contentInset: CGFloat = 1
            DescriptionTextArea.textContainerInset = UIEdgeInsets(top: contentInset, left: contentInset, bottom: 0, right: contentInset)
            
            let button = UIButton(frame: CGRect(x: contentInset, y: DescriptionTextArea.contentSize.height - buttonHeight - contentInset, width: DescriptionTextArea.contentSize.width-contentInset*2, height: buttonHeight))
            button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
            button.contentVerticalAlignment = UIControl.ContentVerticalAlignment.top
            button.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 6.0)
            button.setTitle("...Read More", for: UIControl.State.normal)
            button.setTitleColor(UIColor(named: "readmorecolor"), for: UIControl.State.normal)
            button.titleLabel?.backgroundColor = UIColor.white
            button.titleLabel?.font = .systemFont(ofSize: 12)
            button.backgroundColor = UIColor.white
            DescriptionTextArea.addSubview(button)
            
            button.addTarget(self, action: #selector(actionButtonTapped(sender:)), for: .touchUpInside)
            
            
            
            
        } else {
            
            DescriptionTextArea.sizeToFit()
            DescriptionTextArea.isScrollEnabled = false
        }
        
        ProductNameLabel.text = productName
        
    }
    
    @objc func actionButtonTapped(sender: UIButton){
        
        DescriptionTextArea.isScrollEnabled = true
        sender.isHidden = true
        
    }
    
    func setPagecontrol(number : Int){
        
        PageControll.currentPage = number
        
    }
    
    @IBAction func CommunityButtonAction(_ sender: Any) {
        
        if productStruct.productObj.CommunityID != "" {
            print("Community Id in cell is :: \(productStruct.productObj.CommunityID)")
        }
        
    }
    
    @IBAction func WatchButtonAction(_ sender: Any) {
        
        print("button is clicked")
        
        var youtubeId = ""
        
        if productStruct.productObj.youtubeId != "" {
            print("youtube Id in cell is :: \(productStruct.productObj.youtubeId)")
            youtubeId = productStruct.productObj.youtubeId
        } else {
            youtubeId = "EKyirtVHsK0"
        }
        
        if let youtubeURL = URL(string: "youtube://\(youtubeId)"),
            UIApplication.shared.canOpenURL(youtubeURL) {
            // redirect to app
            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
        } else if let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(youtubeId)") {
            // redirect through safari
            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
        }
        
        
    }
   
}
