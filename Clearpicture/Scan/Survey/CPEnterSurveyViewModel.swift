//
//  CPEnterSurveyViewModel.swift
//  Clearpicture
//
//  Created by Hasitha De Mel on 1/20/19.
//  Copyright © 2019 Hasitha. All rights reserved.
//

import UIKit

class CPEnterSurveyViewModel: NSObject {
    
    static let instance = CPEnterSurveyViewModel.init()
    var surveyID : String?
    var questionsArray = [Any]()
    
    func loadQuestions(completion : @escaping(_ status : Bool) -> Void){
        _ = CPAPIManager.sharedInstance.loadQuestions(surveyID: surveyID!, callback: { (status, message, questions) in
            self.questionsArray = questions!
            completion (status)
        })
    }
    
}
