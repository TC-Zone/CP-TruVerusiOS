//
//  QuestionsViewController.swift
//  Message in a Bottle
//
//  Created by Hasitha De Mel on 10/22/18.
//  Copyright © 2018 Appcoda. All rights reserved.
//

import UIKit
import Alamofire

class CPQuestionsViewController: UIViewController {

    let kCellIdentifierSelectionCell = "SelectionCell"
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var lblQuestionNo: UILabel!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var answrContainerView: UIView!
    @IBOutlet weak var txtViewContainer: UIView!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var answrTableView: UITableView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    
    

    
    var viewModel : CPQuestionsViewModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNibs()
        
        self.navigationItem.hidesBackButton = true
        self.btnNext.layer.cornerRadius = 10
        self.btnCancel.layer.cornerRadius = 10
        
        let nextIndex = CPSurveyManager.shared.currentQuestionIndex + 1
        if nextIndex == CPSurveyManager.shared.surveyViewControllers.count{
            self.btnNext.setTitle("Done", for: .normal)
        }
        self.lblQuestion.text = self.viewModel!.questionObj["name"] as? String
        self.lblQuestionNo.text = "\(CPSurveyManager.shared.currentQuestionIndex + 1) of \(CPSurveyManager.shared.surveyViewControllers.count)"
        
        CPHelper.showHud()
        self.viewModel?.loadAnswers(completion: { (status) in
            CPHelper.hideHud()
            if status{
                self.answrTableView.reloadData()
                if self.viewModel?.answrType
                    == "F" {
                    self.txtViewContainer.frame = self.answrContainerView.bounds
                    self.answrContainerView.addSubview(self.txtViewContainer)
                    //self.containerViewHeight.constant = 100.0
                }else{
                    self.answrTableView.frame = self.answrContainerView.bounds
                    self.answrContainerView.addSubview(self.answrTableView)
                    //self.containerViewHeight.constant = 300.0
                }
            }
        })
    }
    
    
    @IBAction func nextClicked(_ sender: Any) {
        
        let nextIndex = CPSurveyManager.shared.currentQuestionIndex + 1
        
        if nextIndex < CPSurveyManager.shared.surveyViewControllers.count {
            CPSurveyManager.shared.currentQuestionIndex = nextIndex
            
            self.addAnswrsToArray()
            
            self.navigationController?
                .pushViewController(CPSurveyManager.shared.surveyViewControllers[nextIndex], animated: true)
        }else{
      
            self.addAnswrsToArray()
            let arry = CPSurveyManager.shared.surveyAnswers
            var dic : [String : Any] = ["questions" : arry]
            dic["surveyId"] = CPSurveyManager.shared.surveyID
            dic["authCode"] = CPSurveyManager.shared.authCode
            
            self.sendAnswersToTheServer(dic)
            //let dictionary = ["aKey": "aValue", "anotherKey": "anotherValue"]
            if let theJSONData = try?  JSONSerialization.data(
                withJSONObject: dic,
                options: .prettyPrinted
                ),
                let theJSONText = String(data: theJSONData,
                                         encoding: String.Encoding.ascii) {
                print("JSON string = \n\(theJSONText)")
            }
        
            //print("add")
        }
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func addAnswrsToArray(){
        
        if self.viewModel!.answrType == "F"{
            var params:[String : Any] = [String : Any]()
            params["id"] = self.viewModel!.questionObj["id"]
            params["freeText"] = self.txtView.text
            CPSurveyManager.shared.surveyAnswers.append(params)
            
        }else{
            
            var params:[String : Any] = [String : Any]()
            params["id"] = self.viewModel!.questionObj["id"]
            
            var answrArray = [[String : Any]]()
            for answrID in CPSurveyManager.shared.tmpAnswerArray {
                
                var tmpAnswers:[String : Any] = [String : Any]()
                tmpAnswers["id"] = answrID
                answrArray.append(tmpAnswers)
            }
            params["answers"] = answrArray
            
            CPSurveyManager.shared.surveyAnswers.append(params)
            CPSurveyManager.shared.preSelectedAnswerRadioButton = nil
            CPSurveyManager.shared.preSelectedRadioAnswerID = nil
            CPSurveyManager.shared.tmpAnswerArray.removeAll()
            
        }
    }
    
    
    func sendAnswersToTheServer(_ params : [String : Any]){
        
//        ACProgressHUD.shared.showHUD()
        let urlString = "\(CPConstants.API.BASE_URL)/survey/api/survey/questions/answers"
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Content-Type"] = "application/json"
        Alamofire.request(urlString, method: .post, parameters: params,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            
//            ACProgressHUD.shared.hideHUD()
            switch response.result {
            case .success:
                print(response)
                self.dismiss(animated: true, completion: nil)
                break
            case .failure(let error):
                
                print(error)
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CPQuestionsViewController : UITableViewDelegate, UITableViewDataSource{
    
    func registerNibs() {
        
        let adCellNib = UINib(nibName: kCellIdentifierSelectionCell, bundle: nil)
        self.answrTableView.register(adCellNib, forCellReuseIdentifier: kCellIdentifierSelectionCell)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel!.answrsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SelectionCell = self.answrTableView.dequeueReusableCell(withIdentifier: kCellIdentifierSelectionCell, for: indexPath) as! SelectionCell
        let answrObj : [String : Any] = self.viewModel!.answrsArray[indexPath.row] as! [String : Any]
        cell.answerLabel.text = answrObj["lable"] as? String
        cell.setupCell(answrObj, self.viewModel!.answrType!)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell : SelectionCell = self.answrTableView.cellForRow(at: indexPath) as! SelectionCell
        cell.tag = indexPath.row
        cell.checkboxValueCheck()
        //self.answrTableView.reloadRows(at: [indexPath], with: .left)
    }
}

extension CPQuestionsViewController : UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn _: NSRange, replacementText text: String) -> Bool {
        let resultRange = text.rangeOfCharacter(from: CharacterSet.newlines, options: .backwards)
        if text.count == 1 && resultRange != nil {
            textView.resignFirstResponder()
            // Do any additional stuff here
            return false
        }
        return true
    }
    
}

