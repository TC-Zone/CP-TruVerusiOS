//
//  CPFeedbackSubViewController.swift
//  Truverus
//
//  Created by User on 13/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyJSON



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
    
    var answeerValues : [String:Any]  = [:]
    
    var feedbackID : String!
    
    var backFlag : Bool!
    
    var currentPageNumber : Int! = 0
    
    var pageBreak : Bool!
    
    var answersObject = [Survey.Answer]()
    var finalAnswerObject = [Survey]()
    
    var OriginalAnswerArray = [OriginalAnswers]()
    
    var dictioary = Dictionary<String, Any>()
    
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(setdataWithServices), name: NSNotification.Name(rawValue: "loadfeed"), object: nil)
        
    }
    
    
    @objc func setdataWithServices() {
        
       self.SurveyTableView.reloadData()
        
        

            if surveyModule.Syrvey.isEmpty == false && surveyModule.Syrvey.count > 0{

                currentIndex = 0

             type = surveyModule.Syrvey[0].pages![0].elements![currentIndex].type
                currentIndex = currentIndex + 1
         
        
            }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        ndx = indexPath
        
        if type == "text" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CPSurveyTextTypeCell") as! CPSurveyTextTypeQuestionTableViewCell
            
            cell.QuestionNumber.text = "Question \(currentIndex ?? 1)"
            cell.Question.text = surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].title
            cell.qcodee = surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].qcode
            cell.qnumber = surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].name
            
            if cell.AnswerText.text != "" {
                cell.AnswerText.text = ""
            }
            
            return cell
        } else if type == "radiogroup" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RadioCell") as! CPRadiogroupTableViewCell

            let count = surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].choices?.count
            cell.questionnumber.text = "Question \(currentIndex ?? 1)"
            cell.Question.text = surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].title
            cell.qcodee = surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].qcode
            cell.qnumber = surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].name
            
            cell.items.removeAll()
            
                for i in 0...(count! - 1) {
                    
                    cell.items.append(surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].choices![i].text!)
                    print("items in radio :: \(cell.items)")
                    
                }
            
            cell.RadioTable.reloadData()
            
            if cell.answr.isEmpty == false {
                
                if ((cell.answr.count) - 1) >= 0 {
                    
                    let res = cell.answr.filter {  $0.qcode == "\(surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].qcode ?? "")" }
                    
                    if res.count >= 0 {
                        
                        cell.answr.removeAll { (Answers) -> Bool in
                            Answers.qcode == "\(surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].qcode ?? "")"
                        }
                        
                    }
                    
                    cell.RadioTable.reloadData()

                    
                }
                
            } else {
                
            }
            return cell
        } else if type == "dropdown" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dropdownCell") as! CPDropdownTableViewCell
            

            let count = surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].choices?.count
            cell.QuestionNumber.text = "Question \(currentIndex ?? 1)"
            cell.Question.text = surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].title
            cell.qcodee = surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].qcode
            cell.qnumber = surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].name
            
            cell.list.removeAll()
            for i in 0...(count! - 1) {
                
                cell.list.append(surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].choices![i].text!)
                
            }
            
            if cell.textBox.text != "" {
                cell.textBox.text = ""
                cell.selectedAnswer = ""
                cell.dropDown.reloadAllComponents()
            } else {
                
                
            }
            
            return cell
        } else if type == "imagepicker" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "imagepickerCell") as! CPImagepickerTableViewCell
            
            cell.QuestionNumber.text = "Question \(currentIndex ?? 1)"
            cell.qcodee = surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].qcode
            cell.qnumber = surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].name
            cell.multiselect = surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].multiselect
            
            if surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].title != nil {
                
                cell.Question.text = surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].title
                
            } else {
                
                cell.Question.text = "couldent recieve the question.. something went wrong!"
                
            }
            
            let imageCount = surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].choices?.count
            
            cell.imagenamelist.removeAll()
            cell.imagelist.removeAll()
            for i in 0...(imageCount! - 1) {
                
                cell.imagenamelist.append(surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].choices![i].text!)
                cell.imagelist.append(surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].choices![i].imagelink!)
             
            }
            
            cell.imagecollectionview.reloadData()
            
            if cell.selectedAnswerImages.isEmpty == false {
                
                if ((cell.selectedAnswerImages.count) - 1) >= 0 {
                    
                    let res = cell.selectedAnswerImages.filter {  $0.qcode == "\(surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].qcode ?? "")" }
                    
                    if res.count >= 0 {
                        
                        cell.selectedAnswerImages.removeAll { (Answers) -> Bool in
                            Answers.qcode == "\(surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].qcode ?? "")"
                        }
                        
                    }
                    
                }
                
            } else {
                
                
                
            }
            
            
            return cell
        } else if type == "rating" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ratingCell") as! CPRatingTableViewCell
            
            cell.QuestionNumber.text = "Question \(currentIndex ?? 1)"
            cell.qcodee = surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].qcode
            cell.qnumber = surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].name
            
            if  surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].title != nil {
                
                cell.Question.text = surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].title
                
            } else {
                
                cell.Question.text = "couldent recieve the question.. something went wrong!"
                
            }
            
            let count = surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].ratemax
            
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
            
         
            return cell
        } else if type == "comment" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as! CPCommentTableViewCell
            
            cell.QuestionNumber.text = "Question \(currentIndex ?? 1)"
            cell.Question.text = surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].title
            cell.qcodee = surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].qcode
            cell.qnumber = surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].name
            
            if cell.AnswerText.text != "" {
                cell.AnswerText.text = ""
            }
            
            
            return cell
        } else if type == "checkbox" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "checkboxCell") as! CPCheckboxTableViewCell
            

            let count = surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].choices?.count
            cell.QuestionNumber.text = "Question \(currentIndex ?? 1)"
            cell.Question.text = surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].title
            cell.qcodee = surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].qcode
            cell.qnumber = surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].name
            
            cell.items.removeAll()
            for i in 0...(count! - 1) {
                
                cell.items.append(surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].choices![i].text!)
                
            }
            
            cell.CheckboxesTable.reloadData()
            
            if cell.ans.isEmpty == false {
                
                if ((cell.ans.count) - 1) >= 0 {
                    
                    let res = cell.ans.filter {  $0.qcode == "\(surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].qcode ?? "")" }
                    
                    if res.count >= 0 {
                        
                        cell.ans.removeAll { (Answers) -> Bool in
                            Answers.qcode == "\(surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].qcode ?? "")"
                        }
                        
                    }
                    
                    cell.CheckboxesTable.reloadData()
                    
                }
                
            } else {
                
            }
            
            
            return cell
        } else if type == "Compleate" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompleatedSurveycell") as! CPSurveyCompleatedTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoSurveyCell") as! CPNoSurveyTableViewCell
            
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
        
        if PreviousButton.backgroundColor == UIColor(named: "CancelRed") || NextButton.backgroundColor == UIColor(named: "AcceptGreen") {
            
            if let parent = self.parent as? CPFeedbackViewController {
                let transition = CATransition()
                transition.type = CATransitionType.push
                transition.subtype = CATransitionSubtype.fromRight
                parent.view.layer.add(transition, forKey: nil)
                parent.handleBack()
            }
            self.currentIndex = 0
            self.currentPageNumber = 0
            type = ""
            self.PreviousButton.isEnabled = false
            self.PreviousButton.backgroundColor = UIColor.lightGray
    
        } else {
        
            if let parent = self.parent as? CPFeedbackViewController {
                let transition = CATransition()
                transition.type = CATransitionType.push
                transition.subtype = CATransitionSubtype.fromRight
                parent.view.layer.add(transition, forKey: nil)
                parent.handleBack()
            }
        
        }
        
        
    }
    
    @IBAction func NextButtonAction(_ sender: Any) {
        
        
        if self.NextButton.titleLabel?.text == "Complete" {
            
            let alert = UIAlertController(title: "Congratulations!!", message: "You have successfully completed the survey. Thank you.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
                
                if let parent = self.parent as? CPFeedbackViewController {
                    let transition = CATransition()
                    transition.type = CATransitionType.push
                    transition.subtype = CATransitionSubtype.fromRight
                    parent.view.layer.add(transition, forKey: nil)
                    parent.handleBack()
                }
                
                self.currentIndex = 0
                self.currentPageNumber = 0
                self.NextButton.isEnabled = true
                self.NextButton.backgroundColor = UIColor(named: "AcceptGreen")
                self.NextButton.setTitle("Next", for: UIControl.State.normal)
                self.PreviousButton.isEnabled = false
                self.PreviousButton.backgroundColor = UIColor.lightGray
                
                
                let survey = Survey(interactionId: "randomSurvey")
                survey.originalResultArray = "hhhhhdjjdjdk"
                survey.futureSurveyAnswers = self.answersObject
                
                self.finalAnswerObject = [survey]
                print(survey)
                
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                do {
                    let jsonData = try encoder.encode(survey)
                    
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        print(jsonString)
                    }
                } catch {
                    print(error.localizedDescription)
                }
                
                survey.futureSurveyAnswers.removeAll()
                self.answersObject.removeAll()
                
                print("final dic is :: \(self.dictioary)")
                
                print("count after clear :: \(self.answersObject.count)")
                

            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
          
            nextActionForCommon()
            
        }
        
        
        
    }
    
    
    func nextActionForCommon(){
        
        
        let pages : Int! = surveyModule.pagecount
        
        if pages ?? 0 > 0 && pages == 1 {
            currentPageNumber = 0
        }
        
        if currentIndex != nil && currentPageNumber != nil {
            
            
            if surveyModule.Syrvey[0].pages?.count != 0 && surveyModule.Syrvey[0].pages![currentPageNumber].elements?.count != 0 {
                
                let elementscount = surveyModule.Syrvey[0].pages![currentPageNumber].elements?.count

                if currentIndex <= (elementscount! - 1) && surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex].type != "" {
                    

                    
                    if surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex].isRequired == true && validateCellInputs() == false {
                        
                        
                        showValidationAlerts(message: "This Question is Required.")
                        
                    } else {
                        
                        _ = validateCellInputs()

                        type = surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex].type
                        
                        if currentIndex == 0 {
                            PreviousButton.isEnabled = false
                            PreviousButton.backgroundColor = UIColor.lightGray
                            
                        } else {
                        PreviousButton.isEnabled = true
                        PreviousButton.backgroundColor = UIColor(named: "CancelRed")
                        }
                        currentIndex = currentIndex + 1
                        
                        pageBreak = false
                        
                    }
                    
                    
                } else {
                    if currentIndex == elementscount! {
                        if surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].isRequired == true && validateCellInputs() == false {
                            

                            showValidationAlerts(message: "This Question is Required.")
                            
                        } else {
                            
                            _ = validateCellInputs()
                            if currentPageNumber >= (pages - 1) {
                                
                                
                                type = surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].type
                                PreviousButton.isEnabled = true
                                PreviousButton.backgroundColor = UIColor(named: "CancelRed")
                                currentIndex = currentIndex + 1
                                
                                NextButton.backgroundColor = UIColor(named: "readmorecolor")
                                NextButton.setTitle("Complete", for: UIControl.State.normal)
                                type = "Compleate"
                                currentIndex = currentIndex + 1
                                
                            } else {
                                
                          
                                currentPageNumber = currentPageNumber + 1
                                currentIndex = 1
                                
                                type = surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].type

                                
                                pageBreak = true
                                
                                
                            }
                            
                            
                            
                        }
                        
                    }
                    
                }
                
            } else {
                
                type = "NoSurveyCell"
                
            }
            
        } else {
            
            if surveyModule.Syrvey.isEmpty == false && surveyModule.Syrvey.count > 0{
                
                if surveyModule.Syrvey[0].pages?.count != nil && surveyModule.Syrvey[0].pages?.count != 0 && surveyModule.Syrvey[0].pages![currentPageNumber].elements?.count != nil && surveyModule.Syrvey[0].pages![currentPageNumber].elements?.count != 0 && surveyModule.Syrvey[0].pages![currentPageNumber].elements?[0].type != nil && surveyModule.Syrvey[0].pages![currentPageNumber].elements?[0].type != ""  {
                    
                    let elementscount = surveyModule.Syrvey[0].pages![currentPageNumber].elements?.count
                    currentIndex = 0
                    
                    if currentIndex <= (elementscount! - 1) {
                        type = surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex].type
                        
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
    
    func convertToJSONString(value: AnyObject) -> String? {
        if JSONSerialization.isValidJSONObject(value) {
            do{
                let data = try JSONSerialization.data(withJSONObject: value, options: [])
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }catch{
            }
        }
        return nil
    }
 
    
    
    
    func validateCellInputs() -> Bool {
        
        let indexpath = NSIndexPath(item: 0, section: 0)
        
        let thiscell = TableSurvay.cellForRow(at: indexpath as IndexPath)

        if thiscell?.reuseIdentifier == "CPSurveyTextTypeCell" {
           
            let currentCell = TableSurvay.cellForRow(at: indexpath as IndexPath) as! CPSurveyTextTypeQuestionTableViewCell
            
            if currentCell.AnswerText.text.isEmpty != true && currentCell.AnswerText.text != "" && currentCell.AnswerText.text != "\n\n" {

                let encoder = JSONEncoder()
                print("currentcell qnumber :: \(currentCell.qnumber)")
                
//                let originResult = OriginalAnswerArray.filter {  $0.number == "\(currentCell.qnumber)" }
                let originResult = OriginalAnswerArray.contains {  $0.number == "\(currentCell.qnumber ?? "")" }
                
                print("occurences of original result :: \(originResult)")
                if originResult == true {
                    
                    OriginalAnswerArray.removeAll { (OriginalAnswers) -> Bool in
                        OriginalAnswers.number == "\(currentCell.qnumber ?? "")"
                    }
                    
                }
                
                OriginalAnswerArray.append(OriginalAnswers(number: currentCell.qnumber, answer: JSON(currentCell.AnswerText!.text as Any)))
                
                print("original array is :: \(OriginalAnswerArray)")
                
                if let jsonDatas = try? encoder.encode(OriginalAnswerArray) {
                    print("Generated data: \(jsonDatas)")
                    print(String(data: jsonDatas, encoding: .utf8)!)
                } else {
                    print("json was unsuccessfull")
                }
                
   
       ////////////////////////////////////////Creating original answer array
                
                let keyExists = dictioary["\(currentCell.qnumber ?? "")"] != nil
                if keyExists == true {
                    
                    dictioary.removeValue(forKey: "\(currentCell.qnumber ?? "")")
                    
                }
                
                dictioary["\(currentCell.qnumber ?? "")"] = currentCell.AnswerText.text
                
                
                print("dic is :: \(dictioary)")
                
        ///////////////////////////////////////
                
                
                
                
                let jsonStringCreated = convertToJSONString(value: OriginalAnswerArray as AnyObject)
                print("originals :: \(jsonStringCreated ?? "npoe")")
                
                let results = answersObject.filter {  $0.qcode == currentCell.qcodee }
                print("occurences :: \(results.count)")
                
                
                answersObject.removeAll { (Answers) -> Bool in
                    Answers.qcode == currentCell.qcodee
                }
                
                print("wasss hereee")
                let answer = Survey.Answer()
                answer.qcode = currentCell.qcodee
                answer.type = .text
                
                answer.values.append({
                    let value = Survey.Answer.Value()
                    value.value = currentCell.AnswerText.text
                    return value
                    }())

                answersObject.append(answer)
                print(Survey.self)

                
                if let jsonData = try? encoder.encode(answer) {
                    print("Generated data: \(jsonData)")
                    print(String(data: jsonData, encoding: .utf8)!)
                } else {
                    print("json was unsuccessfull")
                }
                
                return true
            } else {
                print("no text found")
                let answer = Survey.Answer()
                answer.qcode = currentCell.qcodee
                answer.type = .text
                answer.values.append({
                    let value = Survey.Answer.Value()
                    value.value = nil
                    return value
                    }())
                
                answersObject.append(answer)
                return false
            }
        } else if thiscell?.reuseIdentifier == "checkboxCell"{
            
            let currentCell = TableSurvay.cellForRow(at: indexpath as IndexPath) as! CPCheckboxTableViewCell
            var checkboxanswers = [String]()
            
            if currentCell.ans.isEmpty == false {
                
                
                let results = answersObject.filter {  $0.qcode == currentCell.ans[0].qcode }
                print("occurences :: \(results.count)")
                print("currentcell checkbox qnumber :: \(currentCell.qnumber)")
                
                answersObject.removeAll { (Answers) -> Bool in
                    Answers.qcode == currentCell.ans[0].qcode
                }
                
                let answer = Survey.Answer()
                answer.qcode = currentCell.ans[0].qcode
                answer.type = .checkbox
                
                
                
                if ((currentCell.ans.count) - 1) >= 0 {
                    print("answers array \(currentCell.ans) ")
                    
                    for i in 0...currentCell.ans.count - 1 {
                        
                        print("checkbox vals ::::: \(currentCell.ans[i].answer)")
                        
                    }
                    
                    let has = currentCell.ans.filter {  $0.qcode == "\(currentCell.qcodee ?? "")" }
                    
                    
                    
                    if has.count > 0 {
                        
                        
                        
                        for i in 0...((currentCell.ans.count) - 1) {
                            
                            
                            print("selected answrs are :: \(currentCell.ans[i].number) :: \(currentCell.ans[i].answer) :: qcode \(currentCell.ans[i].qcode)")
                            
                            checkboxanswers.append(currentCell.ans[i].answer)
                            
                            print("wasss hereee")
                            
                            answer.values.append({
                                let value = Survey.Answer.Value()
                                value.value = currentCell.ans[i].answer
                                return value
                                }())


                            let encoder = JSONEncoder()
                            if let jsonData = try? encoder.encode(answer) {
                                print("Generated data: \(jsonData)")
                                 print(String(data: jsonData, encoding: .utf8)!)
                            }
                            
                        }
                        answersObject.append(answer)
                        currentCell.ans.removeAll()
                        
                        ////////////////////////////////////////Creating original answer array
                       
                        let keyExists = dictioary["\(currentCell.qnumber ?? "")"] != nil
                        if keyExists == true {
                            
                            dictioary.removeValue(forKey: "\(currentCell.qnumber ?? "")")
                            
                        } else {
                            
                            print("checkbox array is :: \(checkboxanswers)")
                            
                            dictioary["\(currentCell.qnumber ?? "")"] = checkboxanswers
                            
                        }
                        
                        
                        
                        
                        print("dic is :: \(dictioary)")
                        
                        ///////////////////////////////////////
                        
                        return true
                        
                    } else {
                        
                        
                        return false
                    }
                    
                }
                return true
                
            }  else {
                let answer = Survey.Answer()
                answer.qcode = currentCell.qcodee
                answer.type = .checkbox
                answer.values.append({
                    let value = Survey.Answer.Value()
                    value.value = nil
                    return value
                    }())
                
                answersObject.append(answer)
                
                return false
            }
            
        } else if thiscell?.reuseIdentifier == "RadioCell"{
            
            let currentCell = TableSurvay.cellForRow(at: indexpath as IndexPath) as! CPRadiogroupTableViewCell
            
            if currentCell.answr.isEmpty == false {
                
                let results = answersObject.filter {  $0.qcode == currentCell.answr[0].qcode }
                print("occurences :: \(results.count)")
                
                print("currentcell radio qnumber :: \(currentCell.qnumber)")
                answersObject.removeAll { (Answers) -> Bool in
                    Answers.qcode == currentCell.answr[0].qcode
                }
                
                let answer = Survey.Answer()
                answer.qcode = currentCell.answr[0].qcode
                answer.type = .radiogroup
                
                if ((currentCell.answr.count) - 1) >= 0 {
                    
                    
                    for i in 0...((currentCell.answr.count) - 1) {
                        
                        
                        print("selected answrs are :: \(currentCell.answr[i].number) :: \(currentCell.answr[i].answer) :: qcode \(currentCell.answr[i].qcode)")
                        
                        answer.values.append({
                            let value = Survey.Answer.Value()
                            value.value = currentCell.answr[i].answer
                            return value
                            }())
                        
                        
                    }
                    
                }
                answersObject.append(answer)
                currentCell.answr.removeAll()
                
                return true
                
                
                
            } else {
                let answer = Survey.Answer()
                answer.qcode = currentCell.qcodee
                answer.type = .radiogroup
                answer.values.append({
                    let value = Survey.Answer.Value()
                    value.value = nil
                    return value
                    }())
                
                answersObject.append(answer)
                
                return false
            }
            
        } else if thiscell?.reuseIdentifier == "dropdownCell"{
            
            let currentCell = TableSurvay.cellForRow(at: indexpath as IndexPath) as! CPDropdownTableViewCell
            
            if currentCell.selectedAnswer.isEmpty == false && currentCell.selectedAnswer != "" {
                print("currentcell dropdown qnumber :: \(currentCell.qnumber)")
                
                let results = answersObject.filter {  $0.qcode == currentCell.qcodee }
                print("occurences :: \(results.count)")
                
                
                answersObject.removeAll { (Answers) -> Bool in
                    Answers.qcode == currentCell.qcodee
                }
                
                print("wasss hereee")
                let answer = Survey.Answer()
                answer.qcode = currentCell.qcodee
                answer.type = .dropdown
                
                answer.values.append({
                    let value = Survey.Answer.Value()
                    value.value = currentCell.selectedAnswer
                    return value
                    }())
                
                answersObject.append(answer)
                
                        
                return true
                
            } else {
                let answer = Survey.Answer()
                answer.qcode = currentCell.qcodee
                answer.type = .dropdown
                answer.values.append({
                    let value = Survey.Answer.Value()
                    value.value = nil
                    return value
                    }())
                
                answersObject.append(answer)
                
                return false
            }
            
        } else if thiscell?.reuseIdentifier == "commentCell" {
         
            let currentCell = TableSurvay.cellForRow(at: indexpath as IndexPath) as! CPCommentTableViewCell
            print("currentcell comment qnumber :: \(currentCell.qnumber)")

            if currentCell.AnswerText.text.isEmpty != true && currentCell.AnswerText.text != "" && currentCell.AnswerText.text != "\n\n" {
                
                let results = answersObject.filter {  $0.qcode == currentCell.qcodee }
                print("occurences :: \(results.count)")
                
                
                answersObject.removeAll { (Answers) -> Bool in
                    Answers.qcode == currentCell.qcodee
                }
                
                print("wasss hereee")
                let answer = Survey.Answer()
                answer.qcode = currentCell.qcodee
                answer.type = .comment
                
                answer.values.append({
                    let value = Survey.Answer.Value()
                    value.value = currentCell.AnswerText.text
                    return value
                    }())
                
                answersObject.append(answer)

                return true
            } else {
                print("no text found")
                let answer = Survey.Answer()
                answer.qcode = currentCell.qcodee
                answer.type = .comment
                answer.values.append({
                    let value = Survey.Answer.Value()
                    value.value = nil
                    return value
                    }())
                
                answersObject.append(answer)
                
                return false
            }
        } else if thiscell?.reuseIdentifier == "ratingCell"{
            

            let currentCell = TableSurvay.cellForRow(at: indexpath as IndexPath) as! CPRatingTableViewCell
            
            if currentCell.selectedRating.isEmpty == false && currentCell.selectedRating != "" {
                
                let results = answersObject.filter {  $0.qcode == currentCell.qcodee }
                print("occurences :: \(results.count)")
                
                
                answersObject.removeAll { (Answers) -> Bool in
                    Answers.qcode == currentCell.qcodee
                }
                print("currentcell raing qnumber :: \(currentCell.qnumber)")
                print("wasss hereee")
                let answer = Survey.Answer()
                answer.qcode = currentCell.qcodee
                answer.type = .rating
                
                answer.values.append({
                    let value = Survey.Answer.Value()
                    value.value = currentCell.selectedRating
                    return value
                    }())
                
                answersObject.append(answer)
                

                
                return true
                
            } else {
                let answer = Survey.Answer()
                answer.qcode = currentCell.qcodee
                answer.type = .rating
                answer.values.append({
                    let value = Survey.Answer.Value()
                    value.value = nil
                    return value
                    }())
                
                answersObject.append(answer)
                
                return false
            }
            
        } else if thiscell?.reuseIdentifier == "imagepickerCell" {
            

            let currentCell = TableSurvay.cellForRow(at: indexpath as IndexPath) as! CPImagepickerTableViewCell
            print("currentcell image qnumber :: \(currentCell.qnumber)")
            
            if currentCell.selectedAnswerImages.isEmpty == false {
                
                if ((currentCell.selectedAnswerImages.count) - 1) >= 0 {
                    
                    let has = currentCell.selectedAnswerImages.filter {  $0.qcode == "\(currentCell.qcodee ?? "")" }
                    
                    let results = answersObject.filter {  $0.qcode == currentCell.selectedAnswerImages[0].qcode }
                    print("occurences :: \(results.count)")
                    
                    
                    answersObject.removeAll { (Answers) -> Bool in
                        Answers.qcode == currentCell.selectedAnswerImages[0].qcode
                    }
                    
                    let answer = Survey.Answer()
                    answer.qcode = currentCell.selectedAnswerImages[0].qcode
                    answer.type = .imagepicker
                    
                    if has.count > 0 {
                        
                        for i in 0...((currentCell.selectedAnswerImages.count) - 1) {
                            
                            
                            print("selected answrs are :: \(currentCell.selectedAnswerImages[i].number) :: \(currentCell.selectedAnswerImages[i].answer) :: name was :: \(currentCell.selectedAnswerImages[i].imageName) :: qcode \(currentCell.selectedAnswerImages[i].qcode)")
                            
                            answer.values.append({
                                let value = Survey.Answer.Value()
                                value.value = currentCell.selectedAnswerImages[i].imageName
                                return value
                                }())
                            
                        }
                        
                        answersObject.append(answer)
                        currentCell.selectedAnswerImages.removeAll()
                        return true
                        
                    } else {
                        
                        
                        return false
                    }
                    
                }
                return true
                
            }  else {
                
                print("im here")
                let answer = Survey.Answer()
                answer.qcode = currentCell.qcodee
                answer.type = .imagepicker
                answer.values.append({
                    let value = Survey.Answer.Value()
                    value.value = nil
                    return value
                    }())
                
                answersObject.append(answer)
                
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
        NextButton.setTitle("Next", for: UIControl.State.normal)
        
        let indexpath = NSIndexPath(item: 0, section: 0)
        
        let thiscell = TableSurvay.cellForRow(at: indexpath as IndexPath)
        
        if thiscell?.reuseIdentifier == "CompleatedSurveycell" {
            
             currentIndex = currentIndex - 1
            
        }
        
        
        
        if pageBreak == true {

            if currentPageNumber == 0 {
                
                
            } else {
                
                currentPageNumber = currentPageNumber - 1
                let lastQcode = surveyModule.Syrvey[0].pages![currentPageNumber].elements?.last?.qcode
                let indexOflast = surveyModule.Syrvey[0].pages![currentPageNumber].elements?.firstIndex(where: { $0.qcode == lastQcode })
                currentIndex = indexOflast
                currentIndex = currentIndex + 2
                
            }
            

        } else {
            
            if currentPageNumber > 0 && currentIndex == 1 {
                
                let ind = surveyModule.Syrvey[0].pages![currentPageNumber - 1].elements?.count
                
                currentPageNumber = currentPageNumber - 1
                currentIndex = ind! + 1
                
            }
            
        }
        
        
        let elementsCount =  surveyModule.Syrvey[0].pages![currentPageNumber].elements?.count
        currentIndex = currentIndex - 1
        
        if currentPageNumber == 0 {
           
            
            if currentIndex == 1 {
                PreviousButton.isEnabled = false
                PreviousButton.backgroundColor = UIColor.lightGray
            } else {
                PreviousButton.isEnabled = true
                PreviousButton.backgroundColor = UIColor(named: "CancelRed")
            }
        } else if currentPageNumber > 0 {
            
            if currentIndex < 0 {
                currentIndex = 0
            }
            
        }
        
        if elementsCount != 0 && currentIndex > 0 {
            
            if surveyModule.Syrvey[0].pages?.count != 0 && surveyModule.Syrvey[0].pages![currentPageNumber].elements?.count != 0 {
                
                let elementscount = surveyModule.Syrvey[0].pages![currentPageNumber].elements?.count
                if currentIndex == (elementscount! - 1) || currentIndex - 1 < (elementscount! - 1) && surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].type != "" || currentIndex <= elementsCount! {
                    type = surveyModule.Syrvey[0].pages![currentPageNumber].elements![currentIndex - 1].type
                
                    
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


}





class Survey: Codable {
    
    class Answer: Codable {
        enum AnswerType: String, Codable {
            case imagepicker
            case radiogroup
            case checkbox
            case dropdown
            case rating
            case comment
            case text
        }
        class Value: Codable {
            var value: String?
        }
        
        var type: AnswerType = .imagepicker
        var qcode: String?
        var values: [Value] = [Value]()
    }
    
    let interactionId: String
    var futureSurveyAnswers: [Answer] = [Answer]()
    var originalResultArray: String?
    
    init(interactionId: String) { self.interactionId = interactionId }
}


class OriginalAnswers : Codable {
    var number = String()
    var answer : JSON

    init(number:String, answer:JSON){
        self.number = number
        self.answer = answer
    }
}


extension Collection where Iterator.Element == [String:AnyObject] {
    func toJSONString(options: JSONSerialization.WritingOptions = .prettyPrinted) -> String {
        if let arr = self as? [[String:AnyObject]],
            let dat = try? JSONSerialization.data(withJSONObject: arr, options: options),
            let str = String(data: dat, encoding: String.Encoding.utf8) {
            return str
        }
        return "[]"
    }
}



