//
//  CPCommunityDataModel.swift
//  Truverus
//
//  Created by User on 28/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation
import ObjectMapper

struct CommunityData : Mappable {
    var status : String?
    var statusCode : Int?
    var content : Contents?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        status <- map["status"]
        statusCode <- map["statusCode"]
        content <- map["content"]
    }
    
}

struct Client : Mappable {
    var id : String?
    var name : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        name <- map["name"]
    }
    
}

struct Contents : Mappable {
    var id : String?
    var name : String?
    var description : String?
    var status : String?
    var client : Client?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        name <- map["name"]
        description <- map["description"]
        status <- map["status"]
        client <- map["client"]
    }
    
}
