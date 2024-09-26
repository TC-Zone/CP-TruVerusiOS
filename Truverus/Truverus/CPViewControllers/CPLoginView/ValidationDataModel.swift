//
//  ValidationDataModel.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 6/9/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation

import ObjectMapper

struct registerErrorData : Mappable {
    var status : String?
    var statusCode : Int?
    var validationFailures : [ValidationFailures]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        status <- map["status"]
        statusCode <- map["statusCode"]
        validationFailures <- map["validationFailures"]
    }
    
}

struct ValidationFailures : Mappable {
    var field : String?
    var code : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        field <- map["field"]
        code <- map["code"]
    }
    
}


struct loginErrorDataMap : Mappable {
    var error : String?
    var error_description : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        error <- map["error"]
        error_description <- map["error_description"]
    }
    
}
