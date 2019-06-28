//
//  CPispurchasedDataModel.swift
//  Truverus
//
//  Created by Trumpcode on 2019-06-24.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation

import ObjectMapper

struct IsPurchasedBase : Mappable {
    var status : String?
    var statusCode : Int?
    var content : isContent?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        status <- map["status"]
        statusCode <- map["statusCode"]
        content <- map["content"]
    }
    
}

struct isProduct : Mappable {
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

struct isProductDetail : Mappable {
    var id : String?
    var product : isProduct?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        product <- map["product"]
    }
    
}

struct isContent : Mappable {
    var id : String?
    var mobileId : String?
    var productDetail : isProductDetail?
    var transferLogs : [isTransferLogs]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        mobileId <- map["mobileId"]
        productDetail <- map["productDetail"]
        transferLogs <- map["transferLogs"]
    }
    
}

struct isTransferLogs : Mappable {
    var id : String?
    var record : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        record <- map["record"]
    }
    
}
