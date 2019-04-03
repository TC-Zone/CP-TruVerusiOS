//
//  CPEditAccountViewController.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 4/1/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit
import TaggerKit

class CPEditAccountViewController: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource {

    

    @IBOutlet weak var fashionContainer: UIView!
    @IBOutlet weak var searchContainer: UIView!
    @IBOutlet weak var FashionTagsCollection: UICollectionView!
    @IBOutlet weak var FashionSearchView: UIView!
    @IBOutlet weak var FashionInterestsTextField: TKTextField!
    @IBOutlet weak var EmployementStatusTextField: UITextField!
    @IBOutlet weak var AddressTextField: UITextField!
    @IBOutlet weak var BirthdayTextField: UITextField!
    @IBOutlet weak var GenderTextField: UITextField!
    @IBOutlet weak var ContactNoTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var NameTextfield: UITextField!
    @IBOutlet weak var ProfilePicture: UIImageView!
    @IBOutlet weak var ChangePhotoButton: UIButton!
    
    var selectedGender : String?
    
    var picker = UIPickerView()
    var datePicker = UIDatePicker()
    var toolBar = UIToolbar()
    
    var GenderTypes = ["Male","Female","Other"]
    
    let productTags = TKCollectionView()
    let allTags     = TKCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CreateProfilePic()
        InitTextFields()
        handlefashiontags()
        
        FashionInterestsTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        FashionInterestsTextField.addTarget(self, action: #selector(textFieldDidEndChange(_:)), for: UIControl.Event.editingDidEnd)
        
        // Do any additional setup after loading the view.
    }
    

    @objc func textFieldDidChange(_ textField:UITextField) {
        // your code here
        //FashionSearchView.alpha = 1
        
        searchContainer.isHidden = false
        
    }
    
    @objc func textFieldDidEndChange(_ textField:UITextField) {
        // your code here
        //FashionSearchView.alpha = 1
        FashionInterestsTextField.text = ""
        searchContainer.isHidden = true
        
    }
    
    func handlefashiontags() {
        
        productTags.tags = ["Tech", "Design", "Writing", "Social Media"]
        
        // These are intended to be all the tags the user has added in the app, which are going to be filtered
        allTags.tags = ["Cars", "Skateboard", "Freetime", "Humor", "Travel", "Music", "Places", "Journalism", "Music", "Sports"]
        
        /*
         We set this collection's action to .removeTag,
         becasue these are supposed to be the tags the user has already added
         */
        productTags.action = .removeTag
        
        
        // Set the current controller as the delegate of both collections
        productTags.delegate = self
        allTags.delegate = self
        
        // "testCollection" takes the tags sent by "searchCollection"
        allTags.receiver = productTags
        
        // The tags in "searchCollection" are going to be added, so we set the action to addTag
        allTags.action = .addTag
        
        
        // Set the sender and receiver of the TextField
        FashionInterestsTextField.sender     = allTags
        FashionInterestsTextField.receiver     = productTags
        
        add(productTags, toView: fashionContainer)
        add(allTags, toView: searchContainer)
        searchContainer.isHidden = true
        
    }
    
    override func tagIsBeingAdded(name: String?) {
        // Example: save testCollection.tags to UserDefault
        print("added \(name!)")
    }
    
    override func tagIsBeingRemoved(name: String?) {
        print("removed \(name!)")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return GenderTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return GenderTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedGender = GenderTypes[row]
        GenderTextField.text = selectedGender
    }

    
    
    func CreateProfilePic(){
        
        
        ProfilePicture.layer.borderWidth = 3.0
        ProfilePicture.layer.masksToBounds = false
        ProfilePicture.layer.borderColor = UIColor(named: "TextGray")?.cgColor
        ProfilePicture.layer.cornerRadius = ProfilePicture.frame.size.width / 2
        ProfilePicture.clipsToBounds = true
        
        
        
    }
    
    func InitTextFields(){

        CreateTextFields(TextField: NameTextfield)
        CreateTextFields(TextField: EmailTextField)
        CreateTextFields(TextField: ContactNoTextField)
        createGenderAndBirthdayText(sender: GenderTextField, img: UIImage(named: "drop")!)
        createGenderAndBirthdayText(sender: BirthdayTextField, img: UIImage(named: "calender")!)
        CreateTextFields(TextField: AddressTextField)
        CreateTextFields(TextField: EmployementStatusTextField)
        //CreateTextFields(TextField: FashionInterestsTextField)
        
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
    
    func createGenderAndBirthdayText(sender : UITextField , img : UIImage) {
        
        
        let ImgView = UIImageView(frame: CGRect(x: 5.0, y: 0.0, width: img.size.width, height: img.size.height))
        ImgView.image = img
        
        let leftView = UIView()
        let RightView = UIView()
        
        
        leftView.frame = CGRect(x: 0, y: 0, width: 10, height: 20)
        RightView.frame = CGRect(x: 0, y: 3, width: 30, height: 20)
        
        let button = UIButton(frame: CGRect(x: 5, y: 3, width: 15, height: 15))
        button.setBackgroundImage(img, for: .normal)
        
        if(sender == GenderTextField){
            
            button.addTarget(self, action: #selector(genderbuttonaction), for: .touchUpInside)
            
        } else if(sender == BirthdayTextField) {
            
            button.addTarget(self, action: #selector(BirthdayButtonAction), for: .touchUpInside)
            
        }
        
        
        
       // ImgView.frame = CGRect(x: 5, y: 3, width: 15, height: 15)
        RightView.addSubview(button)
        sender.leftView = leftView
        sender.leftViewMode = .always
        
        sender.rightView = RightView
        sender.rightViewMode = .always
        
        
        sender.layer.borderColor = UIColor(named: "TextGray")?.cgColor
        sender.layer.borderWidth = 1.0
        sender.layer.cornerRadius = 23
        
        
    }
    
    @objc func genderbuttonaction(){
        
        print("clicked acton")
        
        picker = UIPickerView.init()
        picker.delegate = self
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height , width: UIScreen.main.bounds.size.width, height: 200)
        
        self.view.addSubview(picker)
   
        
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height , width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .default
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        self.view.addSubview(toolBar)
        
        if(GenderTextField.text != ""){
            
            let gender = GenderTextField.text
            if(gender == "Male"){
                picker.selectRow(0, inComponent: 0, animated: true)
            } else if(gender == "Female"){
                picker.selectRow(1, inComponent: 0, animated: true)
            } else{
               picker.selectRow(2, inComponent: 0, animated: true)
            }
            
            
        }
    
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.6)
        let transfrom = CGAffineTransform(translationX: 0, y: -200)
        picker.transform = transfrom
        toolBar.transform = transfrom
        UIView.commitAnimations()
        
        
    }
    
    @objc func onDoneButtonTapped() {
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.6)
        let transfrom = CGAffineTransform(translationX: 0, y: 200)
        picker.transform = transfrom
        toolBar.transform = transfrom
        UIView.commitAnimations()
        
    }
    
    
    @objc func BirthdayButtonAction(){
        
       doDatePicker()
        
        
    }

    
    func doDatePicker(){
        // DatePicker
        
        datePicker = UIDatePicker.init()
        datePicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height , width: UIScreen.main.bounds.size.width, height: 200)
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = UIDatePicker.Mode.date
        
        view.addSubview(self.datePicker)
        
        // ToolBar
        
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height , width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .default
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        self.view.addSubview(toolBar)
        self.toolBar.isHidden = false
        
        if(BirthdayTextField.text != ""){
            
            let dateString = BirthdayTextField.text
            let df = DateFormatter()
            df.dateFormat = "dd MM yyyy"
            let date = df.date(from: dateString!)
            if let unwrappedDate = date {
                datePicker.setDate(unwrappedDate, animated: false)
            }
            
        }
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.6)
        let transfrom = CGAffineTransform(translationX: 0, y: -200)
        datePicker.transform = transfrom
        toolBar.transform = transfrom
        UIView.commitAnimations()
        
        
    }
    
    
    @objc func doneClick() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        
        dateFormatter1.dateFormat = "dd MMMM yyyy"
        let selectedDate = dateFormatter1.string(from: datePicker.date)
        BirthdayTextField.text = selectedDate
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.6)
        let transfrom = CGAffineTransform(translationX: 0, y: 200)
        datePicker.transform = transfrom
        toolBar.transform = transfrom
        UIView.commitAnimations()
        
        
    }
    
    @objc func cancelClick() {
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.6)
        let transfrom = CGAffineTransform(translationX: 0, y: 200)
        datePicker.transform = transfrom
        toolBar.transform = transfrom
        UIView.commitAnimations()
        
    }
    
    
    @IBAction func ChangePhotoButtonAction(_ sender: Any) {
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
