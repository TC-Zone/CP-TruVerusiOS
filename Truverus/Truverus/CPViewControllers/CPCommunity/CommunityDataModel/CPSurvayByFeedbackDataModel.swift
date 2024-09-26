//
//  CPSurvayByFeedbackDataModel.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 6/11/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation

import ObjectMapper

struct survayByFeedbackData : Mappable {
    var status : String?
    var statusCode : Int?
    var content : ContentSurFeed?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        status <- map["status"]
        statusCode <- map["statusCode"]
        content <- map["content"]
    }
    
}

struct ContentSurFeed : Mappable {
    var id : String?
    var name : String?
    var surveyId : String?
    var community : CommunitySurFeed?
    var status : String?
    var createdDate : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        name <- map["name"]
        surveyId <- map["surveyId"]
        community <- map["community"]
        status <- map["status"]
        createdDate <- map["createdDate"]
    }
    
}

struct CommunitySurFeed : Mappable {
    var id : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
    }
    
}
