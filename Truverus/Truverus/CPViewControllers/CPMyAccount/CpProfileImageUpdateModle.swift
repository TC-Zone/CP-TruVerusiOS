//
//  CpProfileImageUpdateModle.swift
//  Truverus
//
//  Created by Trumpcode on 2019-07-24.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation
import ObjectMapper

struct UpdateProfilePicBase : Mappable {
    var status : String?
    var statusCode : Int?
    var content : upproContent?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        status <- map["status"]
        statusCode <- map["statusCode"]
        content <- map["content"]
    }
    
}

struct upproContent : Mappable {
    var id : String?
    var accountName : String?
    var email : String?
    var status : String?
    var profileImage : String?
    var lastModifiedDate : String?
    var client : String?
    var role : upProRole?
    var categories : [String]?
    var communities : [String]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        accountName <- map["accountName"]
        email <- map["email"]
        status <- map["status"]
        profileImage <- map["profileImage"]
        lastModifiedDate <- map["lastModifiedDate"]
        client <- map["client"]
        role <- map["role"]
        categories <- map["categories"]
        communities <- map["communities"]
    }
    
}

struct upProRole : Mappable {
    var id : String?
    var name : String?
    var predefined : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        name <- map["name"]
        predefined <- map["predefined"]
    }
    
}
