//
//  CPQuestionsViewModel.swift
//  Clearpicture
//
//  Created by Hasitha De Mel on 1/21/19.
//  Copyright © 2019 Hasitha. All rights reserved.
//

import UIKit

class CPQuestionsViewModel: NSObject {

    static let instance = CPQuestionsViewModel.init()
    
    var questionObj : [String:Any] = [:]
    var answrType : String!
    var answrsArray = [Any]()
    
    func loadAnswers(completion : @escaping(_ status : Bool) -> Void){
        
        let answerObj = self.questionObj["answerTemplate"] as! [String : Any]
        let answrTag = answerObj["id"] as! String
        _ = CPAPIManager.sharedInstance.loadAnswers(answerID: answrTag, callback: { (status, message, response) in
            if status {
                self.answrsArray = response!["answers"] as! [Any]
                self.answrType = response!["answerTemplateType"] as? String
                completion(status)
            }
        })
    }
}
