//
//  CPPushNotificationsModule.swift
//  Truverus
//
//  Created by Trumpcode on 2019-07-29.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation

import ObjectMapper

struct pushnotificationModle : Mappable {
    var aps : Aps?
    var customKey : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        aps <- map["aps"]
        customKey <- map["customKey"]
    }
    
}

struct Aps : Mappable {
    var alert : Alert?
    var badge : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        alert <- map["alert"]
        badge <- map["badge"]
    }
    
}

struct Alert : Mappable {
    var body : String?
    var title : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        body <- map["body"]
        title <- map["title"]
    }
    
}
