//
//  SurveyManager.swift
//  Message in a Bottle
//
//  Created by Hasitha De Mel on 10/24/18.
//  Copyright © 2018 Appcoda. All rights reserved.
//

import UIKit

class CPSurveyManager: NSObject {
    
    static let shared = CPSurveyManager()
    var currentQuestionIndex : Int = 0
    var surveyID : String? = nil
    var authCode : String? = nil
    var surveyAnswers =  [[String : Any]]()
    var surveyViewControllers = [CPQuestionsViewController]()
    
    var tmpAnswerArray = [String]()
    var preSelectedAnswerRadioButton : Checkbox? = nil
    var preSelectedRadioAnswerID : String? = nil
    
    var preSelectedAnswerCheckBoxes = [Checkbox]()
    
    private override init() {
        
    }
    
}
