//
//  CPuserFCMdataModule.swift
//  Truverus
//
//  Created by Trumpcode on 2019-07-31.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation
import ObjectMapper

struct userFCMtempserviceModle : Mappable {
    var status : String?
    var statusCode : Int?
    var content : [FCMContent]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        status <- map["status"]
        statusCode <- map["statusCode"]
        content <- map["content"]
    }
    
}

struct FCMUser : Mappable {
    var id : String?
    var accountName : String?
    var email : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        accountName <- map["accountName"]
        email <- map["email"]
    }
    
}

struct FCMContent : Mappable {
    var id : String?
    var registerToken : String?
    var user : FCMUser?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        registerToken <- map["registerToken"]
        user <- map["user"]
    }
    
}
