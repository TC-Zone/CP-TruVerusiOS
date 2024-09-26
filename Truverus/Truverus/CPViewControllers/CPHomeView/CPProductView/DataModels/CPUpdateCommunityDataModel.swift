//
//  CPUpdateCommunityDataModel.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 6/17/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation
import ObjectMapper

struct UpdateCommunityBase : Mappable {
    var status : String?
    var statusCode : Int?
    var content : UpdateCommunityContent?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        status <- map["status"]
        statusCode <- map["statusCode"]
        content <- map["content"]
    }
    
}

struct UpdateCommunityContent : Mappable {
    var id : String?
    var communities : [Communities]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        communities <- map["communities"]
    }
    
}

struct Communities : Mappable {
    var id : String?
    var name : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        name <- map["name"]
    }
    
}
