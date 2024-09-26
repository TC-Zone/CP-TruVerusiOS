//
//  RegisterUserDataModel.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 6/7/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation

import ObjectMapper

struct UserRegisterDataModel : Mappable {
    var status : String?
    var statusCode : Int?
    var content : contentUser?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        status <- map["status"]
        statusCode <- map["statusCode"]
        content <- map["content"]
    }
    
}

struct MobileUser : Mappable {
    var id : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
    }
    
}

struct contentUser : Mappable {
    var id : String?
    var accountName : String?
    var mobileUser : MobileUser?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        accountName <- map["accountName"]
        mobileUser <- map["mobileUser"]
    }
    
}
