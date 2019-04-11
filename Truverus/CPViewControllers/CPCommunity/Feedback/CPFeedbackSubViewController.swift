//
//  CPFeedbackSubViewController.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 4/9/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit


class CPFeedbackSubViewController: UIViewController {

    @IBOutlet weak var NameText: UITextField!
    @IBOutlet weak var AgeText: UITextField!
    @IBOutlet weak var DescriptionTextArea: UITextView!
  
    @IBOutlet weak var RatingStackView: RatingController!
    @IBOutlet weak var SubmitButton: UIButton!
    @IBOutlet weak var BackButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InitTextFields()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func SubmitAction(_ sender: Any) {
        
        print("Ratings :: \(RatingStackView.starRating)")
        
    }
    
    @IBAction func BackAction(_ sender: Any) {
        
   
        
        if let parent = self.parent as? CPFeedbackViewController {
            let transition = CATransition()
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            parent.view.layer.add(transition, forKey: nil)
            parent.handleBack()
        }
 
        
        
    }
    
    func InitTextFields(){
        
        CreateTextFields(TextField: NameText)
        CreateTextFields(TextField: AgeText)
        createTextArea(TextField: DescriptionTextArea)
       
        
    }
    
    func CreateTextFields(TextField : UITextField ) {
        
        
        let leftView = UIView()
        //leftView.addSubview(ImgView)
        
        leftView.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
        //ImgView.frame = CGRect(x: 11, y: 0, width: 15, height: 15)
        
        TextField.leftView = leftView
        TextField.leftViewMode = .always
        
        
        TextField.layer.borderColor = UIColor(named: "TextGray")?.cgColor
        TextField.layer.borderWidth = 1.0
        TextField.layer.cornerRadius = 23
        
    }
    
    func createTextArea(TextField : UITextView) {
        
        
        TextField.layer.borderColor = UIColor(named: "TextGray")?.cgColor
        TextField.layer.borderWidth = 1.0
        TextField.layer.cornerRadius = 23
        
        TextField.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        
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
