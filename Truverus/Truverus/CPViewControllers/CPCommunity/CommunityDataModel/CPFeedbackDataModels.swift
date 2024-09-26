//
//  CPFeedbackDataModels.swift
//  Truverus
//
//  Created by User on 30/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation
import ObjectMapper

struct FeedbacksData : Mappable {
    var status : String?
    var statusCode : Int?
    var content : [contentsss]?
    var pagination : Paginationss?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        status <- map["status"]
        statusCode <- map["statusCode"]
        content <- map["content"]
        pagination <- map["pagination"]
    }
    
}

struct contentsss : Mappable {
    var id : String?
    var name : String?
    var status : String?
    var createdDate : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        name <- map["name"]
        status <- map["status"]
        createdDate <- map["createdDate"]
    }
    
}

struct Paginationss : Mappable {
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
