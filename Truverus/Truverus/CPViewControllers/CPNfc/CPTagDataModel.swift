//
//  CPTagDataModel.swift
//  Truverus
//
//  Created by User on 20/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation
import ObjectMapper

struct NFCTagData : Mappable {
    var status : String?
    var statusCode : Int?
    var content : Content?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        status <- map["status"]
        statusCode <- map["statusCode"]
        content <- map["content"]
    }
    
}

struct Content : Mappable {
    var serverId : String?
    var communityId : String?
    var productId : String?
    var title : String?
    var message : String?
    var authCode : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        serverId <- map["serverId"]
        communityId <- map["communityId"]
        productId <- map["productId"]
        title <- map["title"]
        message <- map["message"]
        authCode <- map["authCode"]
    }
    
}
