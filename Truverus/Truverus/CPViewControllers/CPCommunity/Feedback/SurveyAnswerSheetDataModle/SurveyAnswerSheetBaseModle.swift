//
//  SurveyAnswerSheetBaseModle.swift
//  Truverus
//
//  Created by Trumpcode on 2019-07-04.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation
import ObjectMapper

struct AnswerBase : Mappable {
    var interactionId : String?
    var futureSurveyAnswers : [FutureSurveyAnswers]?
    var originalResultArray : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        interactionId <- map["interactionId"]
        futureSurveyAnswers <- map["futureSurveyAnswers"]
        originalResultArray <- map["originalResultArray"]
    }
    
}

struct FutureSurveyAnswers : Mappable {
    var type : String?
    var qcode : String?
    var values : [Values]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        type <- map["type"]
        qcode <- map["qcode"]
        values <- map["values"]
    }
    
}

struct Values : Mappable {
    var value : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        value <- map["value"]
    }
    
}
