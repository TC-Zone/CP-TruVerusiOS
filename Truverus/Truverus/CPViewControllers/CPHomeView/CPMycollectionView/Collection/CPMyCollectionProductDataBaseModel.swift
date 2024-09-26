//
//  CPMyCollectionProductDataBaseModel.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 6/17/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation

import ObjectMapper

struct ProductCollectionBase : Mappable {
    var status : String?
    var statusCode : Int?
    var content : [pcolContent]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        status <- map["status"]
        statusCode <- map["statusCode"]
        content <- map["content"]
    }
    
}

struct pcolContent : Mappable {
    var id : String?
    var mobileId : String?
    var productDetail : pcolProductDetail?
    var transferLogs : [pcolTransferLogs]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        mobileId <- map["mobileId"]
        productDetail <- map["productDetail"]
        transferLogs <- map["transferLogs"]
    }
    
}

struct pcolProduct : Mappable {
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

struct pcolProductDetail : Mappable {
    var id : String?
    var product : pcolProduct?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        product <- map["product"]
    }
    
}

struct pcolTransferLogs : Mappable {
    var id : String?
    var record : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        record <- map["record"]
    }
    
}
