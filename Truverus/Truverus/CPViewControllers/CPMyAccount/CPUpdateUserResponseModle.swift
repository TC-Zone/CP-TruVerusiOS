//
//  CPUpdateUserResponseModle.swift
//  Truverus
//
//  Created by Trumpcode on 2019-07-23.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation
import ObjectMapper

struct updateUserBase : Mappable {
    var status : String?
    var statusCode : Int?
    var content : UpContent?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        status <- map["status"]
        statusCode <- map["statusCode"]
        content <- map["content"]
    }
    
}

struct UpUser : Mappable {
    var id : String?
    var accountName : String?
    var email : String?
    var status : String?
    var profileImage : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        accountName <- map["accountName"]
        email <- map["email"]
        status <- map["status"]
        profileImage <- map["profileImage"]
    }
    
}

struct UpContent : Mappable {
    var id : String?
    var user : UpUser?
    var mobileNumber : String?
    var verificationCode : String?
    var birthday : String?
    var gender : String?
    var address : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        user <- map["user"]
        mobileNumber <- map["mobileNumber"]
        verificationCode <- map["verificationCode"]
        birthday <- map["birthday"]
        gender <- map["gender"]
        address <- map["address"]
    }
    
}
