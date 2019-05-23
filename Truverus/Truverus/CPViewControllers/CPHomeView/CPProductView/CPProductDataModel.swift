//
//  CPProductDataModel.swift
//  Truverus
//
//  Created by User on 21/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation

import ObjectMapper

struct productData : Mappable {
    var status : String?
    var statusCode : Int?
    var content : content?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        status <- map["status"]
        statusCode <- map["statusCode"]
        content <- map["content"]
    }
    
}

struct ProductDetails : Mappable {
    var uniqueProductCode : String?
    var authenticationCode : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        uniqueProductCode <- map["uniqueProductCode"]
        authenticationCode <- map["authenticationCode"]
    }
    
}

struct content : Mappable {
    var id : String?
    var name : String?
    var description : String?
    var quantity : Int?
    var expireDate : String?
    var batchNumber : Int?
    var videoUrl : String?
    var imageObjects : [ImageObjects]?
    var productDetails : [ProductDetails]?
    var clientId : String?
    var categoryId : String?
    var surveyId : String?
    var communityId : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        name <- map["name"]
        description <- map["description"]
        quantity <- map["quantity"]
        expireDate <- map["expireDate"]
        batchNumber <- map["batchNumber"]
        videoUrl <- map["videoUrl"]
        imageObjects <- map["imageObjects"]
        productDetails <- map["productDetails"]
        clientId <- map["clientId"]
        categoryId <- map["categoryId"]
        surveyId <- map["surveyId"]
        communityId <- map["communityId"]
    }
    
}

struct ImageObjects : Mappable {
    var id : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
    }
    
}
