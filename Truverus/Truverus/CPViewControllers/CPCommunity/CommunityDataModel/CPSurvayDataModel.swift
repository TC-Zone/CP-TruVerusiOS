//
//  CPSurvayDataModel.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 6/11/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation
import ObjectMapper

struct SurvayData : Mappable {
    var status : String?
    var statusCode : Int?
    var content : ContentSurvey?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        status <- map["status"]
        statusCode <- map["statusCode"]
        content <- map["content"]
    }
    
}

struct ContentSurvey : Mappable {
    var id : String?
    var title : String?
    var clientId : String?
    var origin : String?
    var languageJson : String?
    var jsonContent : String?
    var inviteeGroupId : String?
    var channel : String?
    var compatibility : String?
    var status : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        title <- map["title"]
        clientId <- map["clientId"]
        origin <- map["origin"]
        languageJson <- map["languageJson"]
        jsonContent <- map["jsonContent"]
        inviteeGroupId <- map["inviteeGroupId"]
        channel <- map["channel"]
        compatibility <- map["compatibility"]
        status <- map["status"]
    }
    
}
