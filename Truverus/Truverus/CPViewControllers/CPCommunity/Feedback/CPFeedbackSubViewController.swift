//
//  CPFeedbackSubViewController.swift
//  Truverus
//
//  Created by User on 13/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit
import ObjectMapper



class CPFeedbackSubViewController: UIViewController, UITextFieldDelegate , UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var NameText: UITextField!
    @IBOutlet weak var AgeText: UITextField!
    @IBOutlet weak var DescriptionTextArea: UITextView!
    
    @IBOutlet weak var RatingStackView: RatingController!
    @IBOutlet weak var SubmitButton: UIButton!
    @IBOutlet weak var BackButton: UIButton!
    
    @IBOutlet weak var SurveyTableView: UITableView!
    @IBOutlet weak var SurveyView: UIView!
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var PreviousButton: UIButton!
    @IBOutlet weak var SurveyTable: UIView!
    @IBOutlet weak var TableSurvay: UITableView!
    
    var type : String!
    var currentIndex : Int!
    var ndx : IndexPath!
    
    var futureSurveyAnswers : [String : Any]?
    var answerArray : [String : Any]?
    var checkboxAnswersArray : [String]?
    var singleAnswersArry : [String : Any]?
    var imageAnswerArray : [String : Any]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SurveyTableView.dataSource = self
        SurveyTableView.delegate = self
        self.SurveyTableView.register(UINib(nibName: "CPSurveyTextTypeQuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "CPSurveyTextTypeCell")
        self.SurveyTableView.register(UINib(nibName: "CPRadiogroupTableViewCell", bundle: nil), forCellReuseIdentifier: "RadioCell")
        self.SurveyTableView.register(UINib(nibName: "CPDropdownTableViewCell", bundle: nil), forCellReuseIdentifier: "dropdownCell")
        self.SurveyTableView.register(UINib(nibName: "CPImagepickerTableViewCell", bundle: nil), forCellReuseIdentifier: "imagepickerCell")
        self.SurveyTableView.register(UINib(nibName: "CPRatingTableViewCell", bundle: nil), forCellReuseIdentifier: "ratingCell")
        self.SurveyTableView.register(UINib(nibName: "CPCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "commentCell")
        self.SurveyTableView.register(UINib(nibName: "CPCheckboxTableViewCell", bundle: nil), forCellReuseIdentifier: "checkboxCell")
        self.SurveyTableView.register(UINib(nibName: "CPNoSurveyTableViewCell", bundle: nil), forCellReuseIdentifier: "NoSurveyCell")
        self.SurveyTableView.register(UINib(nibName: "CPSurveyCompleatedTableViewCell", bundle: nil), forCellReuseIdentifier: "CompleatedSurveycell")
        
        
        
        nextActionForCommon()
        
//        PreviousButton.isEnabled = false
//        PreviousButton.backgroundColor = UIColor.lightGray
        // Do any additional setup after loading the view.
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        ndx = indexPath
        
        if type == "text" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CPSurveyTextTypeCell") as! CPSurveyTextTypeQuestionTableViewCell
            
            cell.QuestionNumber.text = "Question \(currentIndex ?? 1)"
            cell.Question.text = surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].title
            cell.qcodee = surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].qcode
            cell.qnumber = surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].name
            
            if cell.AnswerText.text != "" {
                cell.AnswerText.text = ""
            }
            
            
            // Set up cell.label
            return cell
        } else if type == "radiogroup" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RadioCell") as! CPRadiogroupTableViewCell
           
            print("choices count :: \(surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].choices?.count)")
            let count = surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].choices?.count
            cell.questionnumber.text = "Question \(currentIndex ?? 1)"
            cell.Question.text = surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].title
            cell.qcodee = surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].qcode
            cell.qnumber = surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].name
            
            cell.items.removeAll()
            for i in 0...(count! - 1) {
                
                cell.items.append(surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].choices![i].text!)
                print("items in radio :: \(cell.items)")
                
            }
            
            
            if cell.answr.isEmpty == false {
                
                if ((cell.answr.count) - 1) >= 0 {
                    
                    let res = cell.answr.filter {  $0.qcode == "\(surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].qcode ?? "")" }
                    
                    if res.count >= 0 {
                        
                        cell.answr.removeAll { (Answers) -> Bool in
                            Answers.qcode == "\(surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].qcode ?? "")"
                        }
                        
                    }
                    
                    cell.RadioTable.reloadData()

                    
                }
                
            } else {
                
            }
            // Set up cell.button
            return cell
        } else if type == "dropdown" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dropdownCell") as! CPDropdownTableViewCell
            
            print("choices count :: \(surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].choices?.count)")
            let count = surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].choices?.count
            cell.QuestionNumber.text = "Question \(currentIndex ?? 1)"
            cell.Question.text = surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].title
            cell.qcodee = surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].qcode
            cell.qnumber = surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].name
            
            cell.list.removeAll()
            for i in 0...(count! - 1) {
                
                cell.list.append(surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].choices![i].text!)
                
            }
            
            if cell.textBox.text != "" {
                cell.textBox.text = ""
                cell.selectedAnswer = ""
                cell.dropDown.reloadAllComponents()
            } else {
                
                
            }
            
            
            // Set up cell.button   imagepickerCell
            return cell
        } else if type == "imagepicker" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "imagepickerCell") as! CPImagepickerTableViewCell
            
            cell.QuestionNumber.text = "Question \(currentIndex ?? 1)"
            cell.qcodee = surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].qcode
            cell.qnumber = surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].name
            
            if surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].title != nil {
                
                cell.Question.text = surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].title
                
            } else {
                
                cell.Question.text = "couldent recieve the question.. something went wrong!"
                
            }
            
            let imageCount = surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].choices?.count
            
            cell.imagenamelist.removeAll()
            cell.imagelist.removeAll()
            for i in 0...(imageCount! - 1) {
                
                cell.imagenamelist.append(surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].choices![i].text!)
                cell.imagelist.append(surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].choices![i].imagelink!)
                //gygfcfgcgcvhv
            }
            
            cell.imagecollectionview.reloadData()
            
            if cell.selectedAnswerImages.isEmpty == false {
                
                if ((cell.selectedAnswerImages.count) - 1) >= 0 {
                    
                    let res = cell.selectedAnswerImages.filter {  $0.qcode == "\(surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].qcode ?? "")" }
                    
                    if res.count >= 0 {
                        
                        cell.selectedAnswerImages.removeAll { (Answers) -> Bool in
                            Answers.qcode == "\(surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].qcode ?? "")"
                        }
                        
                    }
                    //cell.ans.removeAll()
                    
                }
                
            } else {
                
                
                
            }
            
            
            
            
            // Set up cell.button
            return cell
        } else if type == "rating" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ratingCell") as! CPRatingTableViewCell
            
            cell.QuestionNumber.text = "Question \(currentIndex ?? 1)"
            cell.qcodee = surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].qcode
            cell.qnumber = surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].name
            
            if  surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].title != nil {
                
                cell.Question.text = surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].title
                
            } else {
                
                cell.Question.text = "couldent recieve the question.. something went wrong!"
                
            }
            
            let count = surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].ratemax
            
            if count != nil {
                
                cell.ratingList.removeAll()
                for i in 0...(count! - 1) {
                    
                    cell.ratingList.append("\(i + 1)")
                    
                }
                
            } else {
                
                cell.ratingList.removeAll()
                for i in 0...4 {
                    
                    cell.ratingList.append("\(i + 1)")
                    
                }
                
            }
            
            
            if cell.selectedRating != "" {
                cell.selectedRating = ""
                cell.Picker.reloadAllComponents()
                cell.Picker.selectRow(0, inComponent: 0, animated: true)
            } else {
                
            }
            
            // Set up cell.button
            return cell
        } else if type == "comment" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as! CPCommentTableViewCell
            
            cell.QuestionNumber.text = "Question \(currentIndex ?? 1)"
            cell.Question.text = surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].title
            cell.qcodee = surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].qcode
            cell.qnumber = surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].name
            
            if cell.AnswerText.text != "" {
                cell.AnswerText.text = ""
            }
            
            // Set up cell.button
            return cell
        } else if type == "checkbox" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "checkboxCell") as! CPCheckboxTableViewCell
            
            print("choices count :: \(surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].choices?.count)")
            let count = surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].choices?.count
            cell.QuestionNumber.text = "Question \(currentIndex ?? 1)"
            cell.Question.text = surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].title
            cell.qcodee = surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].qcode
            cell.qnumber = surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].name
            
            cell.items.removeAll()
            for i in 0...(count! - 1) {
                
                cell.items.append(surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].choices![i].text!)
                //gyg
            }
            
            if cell.ans.isEmpty == false {
                
                if ((cell.ans.count) - 1) >= 0 {
                    
                    let res = cell.ans.filter {  $0.qcode == "\(surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].qcode ?? "")" }
                    
                    if res.count >= 0 {
                        
                        cell.ans.removeAll { (Answers) -> Bool in
                            Answers.qcode == "\(surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].qcode ?? "")"
                        }
                        
                    }
                    
                    cell.CheckboxesTable.reloadData()
                    //cell.ans.removeAll()
                    
                }
                
            } else {
                
            }
            
            
            // Set up cell.button
            return cell
        } else if type == "Compleate" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompleatedSurveycell") as! CPSurveyCompleatedTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoSurveyCell") as! CPNoSurveyTableViewCell
            // Set up cell.textField
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SurveyTableView.frame.height
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
    
    @IBAction func NextButtonAction(_ sender: Any) {
        
        nextActionForCommon()
        
    }
    
    
    func nextActionForCommon(){
        
        print("index in outer block :: \(currentIndex)")
        
        
        
        if currentIndex != nil {
            
            if surveyModule.Syrvey[0].pages?.count != 0 && surveyModule.Syrvey[0].pages![0].elements?.count != 0 {
                
                let elementscount = surveyModule.Syrvey[0].pages![0].elements?.count
                print("element count is :: \(elementscount)")
                print("index in if block :: \(currentIndex)")
                if currentIndex <= (elementscount! - 1) && surveyModule.Syrvey[0].pages![0].elements![currentIndex].type != "" {
                    
                    print("validation results :: \(validateCellInputs())")
                    print("is reqired was 11 :: \(surveyModule.Syrvey[0].pages![0].elements![currentIndex].isRequired)")
                    
                    if surveyModule.Syrvey[0].pages![0].elements![currentIndex].isRequired == true && validateCellInputs() == false {
                        
                        print("is reqired was :: \(surveyModule.Syrvey[0].pages![0].elements![currentIndex].isRequired)")
                        
                        showValidationAlerts(message: "This Question is Required.")
                        
                    } else {
                        
                        print("next block currentIndex:: \(currentIndex) and (elementscount! - 1) :: \((elementscount! - 1))")
                        type = surveyModule.Syrvey[0].pages![0].elements![currentIndex].type
                        PreviousButton.isEnabled = true
                        PreviousButton.backgroundColor = UIColor(named: "CancelRed")
                        currentIndex = currentIndex + 1
                        
                    }
                    
                    
                } else {
                    if currentIndex == elementscount! {
                        if surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].isRequired == true && validateCellInputs() == false {
                            
                            print("is reqired was :: \(surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].isRequired)")
                            
                            print("type is :: \(surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].type)")
                            showValidationAlerts(message: "This Question is Required.")
                            
                        } else {
                            
                            print("next block currentIndex:: \(currentIndex - 1) and (elementscount! - 1) :: \((elementscount! - 1))")
                            type = surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].type
                            PreviousButton.isEnabled = true
                            PreviousButton.backgroundColor = UIColor(named: "CancelRed")
                            currentIndex = currentIndex + 1
                            
                            NextButton.isEnabled = false
                            NextButton.backgroundColor = UIColor.lightGray
                            type = "Compleate"
                            currentIndex = currentIndex + 1
                            
                        }
                        
                    }
                    
                }
                
            } else {
                
                type = "NoSurveyCell"
                
            }
            
        } else {
            
            if surveyModule.Syrvey.isEmpty == false && surveyModule.Syrvey.count > 0{
                
                if surveyModule.Syrvey[0].pages?.count != nil && surveyModule.Syrvey[0].pages?.count != 0 && surveyModule.Syrvey[0].pages![0].elements?.count != nil && surveyModule.Syrvey[0].pages![0].elements?.count != 0 && surveyModule.Syrvey[0].pages![0].elements?[0].type != nil && surveyModule.Syrvey[0].pages![0].elements?[0].type != ""  {
                    
                    let elementscount = surveyModule.Syrvey[0].pages![0].elements?.count
                    currentIndex = 0
                    
                    if currentIndex <= (elementscount! - 1) {
                        type = surveyModule.Syrvey[0].pages![0].elements![currentIndex].type
                        
                        currentIndex = currentIndex + 1
                    } else {
                        
                        type = "NoSurveyCell"
                    }
                    
                } else {
                    
                    type = "NoSurveyCell"
                    
                }
                
                
            } else {
                
                type = "NoSurveyCell"
                
            }
            
            
        }
        
        SurveyTableView.reloadData()
        
    }
    
    func validateCellInputs() -> Bool {
        
        let indexpath = NSIndexPath(item: 0, section: 0)
        
        let thiscell = TableSurvay.cellForRow(at: indexpath as IndexPath)

        if thiscell?.reuseIdentifier == "CPSurveyTextTypeCell" {
            print("in identified block")
            let currentCell = TableSurvay.cellForRow(at: indexpath as IndexPath) as! CPSurveyTextTypeQuestionTableViewCell
            
            print("answer was :: \(currentCell.AnswerText.text)")
            if currentCell.AnswerText.text.isEmpty != true && currentCell.AnswerText.text != "" && currentCell.AnswerText.text != "\n\n" {
                print("answer was :: \(currentCell.AnswerText.text) qcode is :: \(currentCell.qcodee)")
                return true
            } else {
                print("no text found")
                return false
            }
        } else if thiscell?.reuseIdentifier == "checkboxCell"{
            
            print("in identified block")
            let currentCell = TableSurvay.cellForRow(at: indexpath as IndexPath) as! CPCheckboxTableViewCell
            
            if currentCell.ans.isEmpty == false {
                
                
                if ((currentCell.ans.count) - 1) >= 0 {
                    print("answers array \(currentCell.ans) ")
                    
                    let has = currentCell.ans.filter {  $0.qcode == "\(currentCell.qcodee ?? "")" }
                    
                    if has.count > 0 {
                        
                        for i in 0...((currentCell.ans.count) - 1) {
                            
                            
                            print("selected answrs are :: \(currentCell.ans[i].number) :: \(currentCell.ans[i].answer) :: qcode \(currentCell.ans[i].qcode)")
                            
                        }
                        return true
                        
                    } else {
                        
                        return false
                    }
                    
                }
                return true
                
            }  else {
                
                return false
            }
            
        } else if thiscell?.reuseIdentifier == "RadioCell"{
            
            print("in identified block")
            let currentCell = TableSurvay.cellForRow(at: indexpath as IndexPath) as! CPRadiogroupTableViewCell
            
            if currentCell.answr.isEmpty == false {
                
                
                if ((currentCell.answr.count) - 1) >= 0 {
                    print("answers array \(currentCell.answr) ")
                    
                    
                    for i in 0...((currentCell.answr.count) - 1) {
                        
                        
                        print("selected answrs are :: \(currentCell.answr[i].number) :: \(currentCell.answr[i].answer) :: qcode \(currentCell.answr[i].qcode)")
                        
                    }
                    
                }
                return true
                
                
                
            } else {
                
                return false
            }
            
        } else if thiscell?.reuseIdentifier == "dropdownCell"{
            
            print("in identified block")
            let currentCell = TableSurvay.cellForRow(at: indexpath as IndexPath) as! CPDropdownTableViewCell
            
            if currentCell.selectedAnswer.isEmpty == false && currentCell.selectedAnswer != "" {
                
                        print("selected answr from dropdown is :: \(currentCell.selectedAnswer) qcode is :: \(currentCell.qcodee)")
                //currentCell.dropDown.reloadAllComponents()
                        
                return true
                
            } else {
                
                return false
            }
            
        } else if thiscell?.reuseIdentifier == "commentCell" {
            print("in identified block")
            let currentCell = TableSurvay.cellForRow(at: indexpath as IndexPath) as! CPCommentTableViewCell
            
            print("answer was :: \(currentCell.AnswerText.text)")
            if currentCell.AnswerText.text.isEmpty != true && currentCell.AnswerText.text != "" && currentCell.AnswerText.text != "\n\n" {
                print("answer was :: \(currentCell.AnswerText.text) qcode is :: \(currentCell.qcodee)")
                return true
            } else {
                print("no text found")
                return false
            }
        } else if thiscell?.reuseIdentifier == "ratingCell"{
            
            print("in identified block")
            let currentCell = TableSurvay.cellForRow(at: indexpath as IndexPath) as! CPRatingTableViewCell
            
            if currentCell.selectedRating.isEmpty == false && currentCell.selectedRating != "" {
                
                print("selected rating from picker is :: \(currentCell.selectedRating) qcode is :: \(currentCell.qcodee)")
                //currentCell.dropDown.reloadAllComponents()
                
                return true
                
            } else {
                
                return false
            }
            
        } else if thiscell?.reuseIdentifier == "imagepickerCell"{
            
            print("in identified block is :: \(thiscell?.reuseIdentifier)")
            let currentCell = TableSurvay.cellForRow(at: indexpath as IndexPath) as! CPImagepickerTableViewCell
            
            
            if currentCell.selectedAnswerImages.isEmpty == false {
                
                if ((currentCell.selectedAnswerImages.count) - 1) >= 0 {
                    print("answers array \(currentCell.selectedAnswerImages) ")
                    
                    let has = currentCell.selectedAnswerImages.filter {  $0.qcode == "\(currentCell.qcodee ?? "")" }
                    
                    if has.count > 0 {
                        
                        for i in 0...((currentCell.selectedAnswerImages.count) - 1) {
                            
                            
                            print("selected answrs are :: \(currentCell.selectedAnswerImages[i].number) :: \(currentCell.selectedAnswerImages[i].answer) :: name was :: \(currentCell.selectedAnswerImages[i].imageName) :: qcode \(currentCell.selectedAnswerImages[i].qcode)")
                            
                        }
                        return true
                        
                    } else {
                        
                        return false
                    }
                    
                }
                return true
                
            }  else {
                
                return false
            }
            
        } else {
            return false
        }

    }
    
    
    func showValidationAlerts(message : String) {
        
        let alert = UIAlertController(title: "Sorry!", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func PreviousButtonAction(_ sender: Any) {
        
        NextButton.isEnabled = true
        NextButton.backgroundColor = UIColor(named: "AcceptGreen")
        
        let indexpath = NSIndexPath(item: 0, section: 0)
        
        let thiscell = TableSurvay.cellForRow(at: indexpath as IndexPath)
        
        if thiscell?.reuseIdentifier == "CompleatedSurveycell"{
            
             currentIndex = currentIndex - 1
            
        }
        
        
        let elementsCount =  surveyModule.Syrvey[0].pages![0].elements?.count
        currentIndex = currentIndex - 1
        if currentIndex < 0 {
            currentIndex = 0
        }
        
        if currentIndex == 1 {
            PreviousButton.isEnabled = false
            PreviousButton.backgroundColor = UIColor.lightGray
        } else {
            PreviousButton.isEnabled = true
            PreviousButton.backgroundColor = UIColor(named: "CancelRed")
        }
        
        if elementsCount != 0 && currentIndex > 0 {
            
            if surveyModule.Syrvey[0].pages?.count != 0 && surveyModule.Syrvey[0].pages![0].elements?.count != 0 {
                
                let elementscount = surveyModule.Syrvey[0].pages![0].elements?.count
                if currentIndex == (elementscount! - 1) || currentIndex - 1 < (elementscount! - 1) && surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].type != "" || currentIndex <= elementsCount! {
                    type = surveyModule.Syrvey[0].pages![0].elements![currentIndex - 1].type
                
                    // retrieve data and show
                    
                    
                } else {
                    type = "NoSurveyCell"
                }
                
            } else {
                
                type = "NoSurveyCell"
                
            }
            
        } else {
            
            type = "NoSurveyCell"
            
        }
        
         SurveyTableView.reloadData()
        
    }
    
    
    
    //    func InitTextFields(){
//
//        CreateTextFields(TextField: NameText)
//        CreateTextFields(TextField: AgeText)
//        createTextArea(TextField: DescriptionTextArea)
//
//
//    }
//
//    func CreateTextFields(TextField : UITextField ) {
//
//
//        let leftView = UIView()
//        //leftView.addSubview(ImgView)
//
//        leftView.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
//        //ImgView.frame = CGRect(x: 11, y: 0, width: 15, height: 15)
//
//        TextField.leftView = leftView
//        TextField.leftViewMode = .always
//
//
//        TextField.layer.borderColor = UIColor(named: "TextGray")?.cgColor
//        TextField.layer.borderWidth = 1.0
//        TextField.layer.cornerRadius = 23
//
//    }
//
//    func createTextArea(TextField : UITextView) {
//
//
//        TextField.layer.borderColor = UIColor(named: "TextGray")?.cgColor
//        TextField.layer.borderWidth = 1.0
//        TextField.layer.cornerRadius = 23
//
//        TextField.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
//
//    }
//
//    func settextDelegates() {
//
//        NameText.delegate = self
//        AgeText.delegate = self
//        DescriptionTextArea.delegate = self
//    }
//
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//
//        NameText.resignFirstResponder()
//        AgeText.resignFirstResponder()
//        DescriptionTextArea.resignFirstResponder()
//
//        return true
//    }
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if text == "\n" {
//            textView.resignFirstResponder()
//            return false
//        }
//        return true
//    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

}

