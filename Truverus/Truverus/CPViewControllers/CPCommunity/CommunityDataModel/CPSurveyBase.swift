//
//  CPSurveyBase.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 6/11/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation
import ObjectMapper

struct SurvayBase : Mappable {
    var title : String?
    var pages : [Pages]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        title <- map["title"]
        pages <- map["pages"]
    }
    
}

struct Pages : Mappable {
    var name : String?
    var elements : [Elements]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        name <- map["name"]
        elements <- map["elements"]
    }
    
}

struct Elements : Mappable {
    var type : String?
    var name : String?
    var title : String?
    var isRequired : Bool?
    var qcode : String?
    var choices : [Choices]?
    var ratemax : Int?
    var multiselect : Bool?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        type <- map["type"]
        name <- map["name"]
        title <- map["title"]
        isRequired <- map["isRequired"]
        qcode <- map["qcode"]
        choices <- map["choices"]
        multiselect <- map["multiSelect"]
        ratemax <- map["rateMax"]
        
    }
    
}

struct Choices : Mappable {
    var value : String?
    var text : String?
    var imagelink : String?
    var multiselect : Bool?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        value <- map["value"]
        text <- map["text"]
        imagelink <- map["imageLink"]
        multiselect <- map["multiSelect"]
    }
    
}
