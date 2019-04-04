//
//  TKTextField.swift
//  TaggerKit
//
//  Created by Filippo Zaffoni on 12/03/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//


import UIKit


public class TKTextField: UITextField {
	
	
	// MARK: - Properties
	// Objects to operate - obviously should not be the same
	public var sender 	: TKCollectionView? { didSet { allTags = sender?.tags } }
	public var receiver	: TKCollectionView?
	
	var allTags: [String]!
	
	// Style
	private let defaultBackgroundColor 	= UIColor.white
	private let defaultCornerRadius 	= CGFloat(23.0)
	
	
	// MARK: - Lifecycle Methods
	public override func awakeFromNib() {
		clipsToBounds = true
		layer.cornerRadius = defaultCornerRadius
		backgroundColor = defaultBackgroundColor
        let leftViews = UIView()
        //leftView.addSubview(ImgView)
        
        leftViews.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
        //ImgView.frame = CGRect(x: 11, y: 0, width: 15, height: 15)
        
        leftView = leftViews
        leftViewMode = .always
        
        
        layer.borderColor = UIColor(named: "TextGray")?.cgColor
        layer.borderWidth = 1.0
		
		clearButtonMode = .whileEditing
		
		placeholder = "Add tags"
		
		addTarget(self, action: #selector(addingTags), for: .editingChanged)
		addTarget(self, action: #selector(pressedReturn), for: .editingDidEndOnExit)
	}
	
	
	// MARK: - TextField methods
	@objc func addingTags() {
		guard sender != nil && receiver != nil else { return }
		
		let filteredStrings = allTags.filter({(item: String) -> Bool in
			let stringMatch = item.lowercased().range(of: text!.lowercased())
			return stringMatch != nil ? true : false
		})
		
		
		
		if filteredStrings.isEmpty {
			if text! == "" {
				sender!.tags = allTags
				sender!.tagsCollectionView.reloadData()
			} else {
				sender!.tags = ["\(text!)"]
				sender!.tagsCollectionView.reloadData()
			}
			
		} else {
			sender!.tags = filteredStrings
			sender!.tagsCollectionView.reloadData()
		}
		
	}
	
	
	@objc func pressedReturn() {
		guard sender != nil && receiver != nil else { return }
		sender?.addNewTag(named: text)
	}
	
    func cleartext() {
        
        self.text = ""
        
    }
	
    
}
