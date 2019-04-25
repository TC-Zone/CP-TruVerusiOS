//
//  CPCustomSegmentedControll.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 3/12/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

@IBDesignable
class CPCustomSegmentedControll: UIControl {

    var buttons = [UIButton]()
    var selector = UIView()
    var selectedSegmentIndex = 0
    
    @IBInspectable
    var borderwidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderwidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    var CommaSeperatedButtonTitles: String = "" {
        didSet {
            UpdateView()
        }
    }
    
    @IBInspectable
    var TextColor: UIColor = .lightGray {
        didSet {
            UpdateView()
        }
    }
  
    @IBInspectable
    var SelectorColor: UIColor = .darkGray  {
        didSet {
            UpdateView()
        }
    }
    
    @IBInspectable
    var SelectorTextColor: UIColor = .lightGray {
        didSet {
            UpdateView()
        }
    }
    
    @IBInspectable
    var selectorStyle: Int = 0 {
        didSet {
            UpdateView()
        }
    }
    
    func UpdateView() {
        
        buttons.removeAll()
        subviews.forEach { $0.removeFromSuperview()
        }
        
        let ButtonTitles = CommaSeperatedButtonTitles.components(separatedBy: ",")
        
        for ButtonTitle in ButtonTitles {
            
            let button = UIButton(type: .system)
            button.setTitle(ButtonTitle, for: .normal)
            button.setTitleColor(TextColor, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
            buttons.append(button)
            
        }
        
        buttons[0].setTitleColor(TextColor, for: .normal)
       
        let sv = UIStackView(arrangedSubviews: buttons)
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fillEqually
        addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        sv.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        sv.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        sv.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        if(selectorStyle == 0){
            
            let selectorWidth = UIScreen.main.bounds.width / CGFloat(ButtonTitles.count)
            let selectorHeight = frame.height / 10
            selector = UIView(frame: CGRect(x: 0, y: (frame.height) - 2.5, width: selectorWidth, height: selectorHeight))
            selector.backgroundColor = SelectorColor
            addSubview(selector)
            
        } else if (selectorStyle == 1){
            
            let selectorWidth = UIScreen.main.bounds.width / CGFloat(ButtonTitles.count)
            let selectorHeight = frame.height / 3
            selector = UIView(frame: CGRect(x: 0, y: (frame.height) - 10, width: selectorWidth, height: selectorHeight))
            selector.backgroundColor = UIColor.clear
            addSubview(selector)
            
            let selectorImageview = UIImageView()
            selectorImageview.frame = CGRect(x: (selectorWidth - (selectorWidth / 4)) + 9, y: (selector.frame.height) - 8, width: selectorWidth / 4, height: selectorHeight)
            selectorImageview.image = UIImage(named: "traingle2")
            selectorImageview.contentMode = .scaleAspectFit
            selector.addSubview(selectorImageview)
            
            
            
            
        }
        
        //selector.center = CGPoint(x: 0 ,y: frame.height)
        
    }
    
    @objc func buttonTapped(button: UIButton){
        
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(TextColor, for: .normal)
            
            if btn == button {
                
                selectedSegmentIndex = buttonIndex
                let selectorStartPosition = frame.width/CGFloat(buttons.count) * CGFloat(buttonIndex)
                
                UIView.animate(withDuration: 0.1, animations: {
                    self.selector.frame.origin.x = selectorStartPosition
                })
                
                btn.setTitleColor(SelectorTextColor, for: .normal)
            }
        }
        
        sendActions(for: .valueChanged)
        
    }
    
   
    

}


