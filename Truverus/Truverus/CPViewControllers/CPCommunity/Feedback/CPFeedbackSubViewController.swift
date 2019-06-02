//
//  CPFeedbackSubViewController.swift
//  Truverus
//
//  Created by User on 13/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPFeedbackSubViewController: UIViewController, UITextFieldDelegate , UITextViewDelegate{

    @IBOutlet weak var NameText: UITextField!
    @IBOutlet weak var AgeText: UITextField!
    @IBOutlet weak var DescriptionTextArea: UITextView!
    
    @IBOutlet weak var RatingStackView: RatingController!
    @IBOutlet weak var SubmitButton: UIButton!
    @IBOutlet weak var BackButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InitTextFields()
        settextDelegates()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func SubmitAction(_ sender: Any) {
        
        print("Ratings :: \(RatingStackView.starRating)")
        let alert = UIAlertController(title: "Sorry!", message: "This option is temporarily disabled due to development purposes", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            @unknown default:
                fatalError()
            }}))
        
            self.present(alert, animated: true, completion: nil)
        
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
    
    func settextDelegates() {
        
        NameText.delegate = self
        AgeText.delegate = self
        DescriptionTextArea.delegate = self
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        NameText.resignFirstResponder()
        AgeText.resignFirstResponder()
        DescriptionTextArea.resignFirstResponder()
        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
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
