//
//  CPPurchaseProductDataModel.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 6/17/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation
import ObjectMapper

struct PurchaseProductBase : Mappable {
    var status : String?
    var statusCode : Int?
    var content : PurContent?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        status <- map["status"]
        statusCode <- map["statusCode"]
        content <- map["content"]
    }
    
}

struct PurContent : Mappable {
    var id : String?
    var product : PurProduct?
    var soldProduct : SoldProduct?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        product <- map["product"]
        soldProduct <- map["soldProduct"]
    }
    
}

struct PurProduct : Mappable {
    var id : String?
    var name : String?
    var communityId : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        name <- map["name"]
        communityId <- map["communityId"]
    }
    
}

struct SoldProduct : Mappable {
    var id : String?
    var mobileId : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        mobileId <- map["mobileId"]
    }
    
}


struct PurErrorCatchBase : Mappable {
    var status : String?
    var statusCode : Int?
    var validationFailures : [PurValidationFailures]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        status <- map["status"]
        statusCode <- map["statusCode"]
        validationFailures <- map["validationFailures"]
    }
    
}

struct PurValidationFailures : Mappable {
    var field : String?
    var code : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        field <- map["field"]
        code <- map["code"]
    }
    
}
