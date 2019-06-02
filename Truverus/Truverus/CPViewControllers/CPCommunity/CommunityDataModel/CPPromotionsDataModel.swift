//
//  CPPromotionsDataModel.swift
//  Truverus
//
//  Created by User on 30/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation
import ObjectMapper

struct PromotionsData : Mappable {
    var status : String?
    var statusCode : Int?
    var content : [contentss]?
    var pagination : Paginations?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        status <- map["status"]
        statusCode <- map["statusCode"]
        content <- map["content"]
        pagination <- map["pagination"]
    }
    
}

struct Community : Mappable {
    var id : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
    }
    
}

struct contentss : Mappable {
    var id : String?
    var name : String?
    var promoImage : String?
    var description : String?
    var startDate : String?
    var endDate : String?
    var percentage : String?
    var status : String?
    var community : Community?
    var createdUserId : String?
    var createdDate : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        name <- map["name"]
        promoImage <- map["promoImage"]
        description <- map["description"]
        startDate <- map["startDate"]
        endDate <- map["endDate"]
        percentage <- map["percentage"]
        status <- map["status"]
        community <- map["community"]
        createdUserId <- map["createdUserId"]
        createdDate <- map["createdDate"]
    }
    
}

struct Paginations : Mappable {
    var pageNumber : Int?
    var pageSize : Int?
    var totalPages : Int?
    var totalRecords : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        pageNumber <- map["pageNumber"]
        pageSize <- map["pageSize"]
        totalPages <- map["totalPages"]
        totalRecords <- map["totalRecords"]
    }
    
}

