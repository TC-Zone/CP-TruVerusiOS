//
//  CPAvailablePurchasedItemsResponse.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 6/17/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation
import ObjectMapper

struct availablePurchasesBase : Mappable {
    var status : String?
    var statusCode : Int?
    var content : [availablepurchaseContent]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        status <- map["status"]
        statusCode <- map["statusCode"]
        content <- map["content"]
    }
    
}

struct availablepurchaseContent : Mappable {
    var id : String?
    var mobileId : String?
    var productDetail : ProductDetail?
    var transferLogs : [TransferLogs]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        mobileId <- map["mobileId"]
        productDetail <- map["productDetail"]
        transferLogs <- map["transferLogs"]
    }
    
}

struct Product : Mappable {
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

struct ProductDetail : Mappable {
    var id : String?
    var product : Product?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        product <- map["product"]
    }
    
}

struct TransferLogs : Mappable {
    var id : String?
    var record : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        record <- map["record"]
    }
    
}
