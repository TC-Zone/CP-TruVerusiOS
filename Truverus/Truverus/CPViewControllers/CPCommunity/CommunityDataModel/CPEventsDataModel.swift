//
//  CPPromotionsDataModel.swift
//  Truverus
//
//  Created by User on 30/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation
import ObjectMapper

struct EventsData : Mappable {
    var status : String?
    var statusCode : Int?
    var content : [contents]?
    var pagination : Pagination?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        status <- map["status"]
        statusCode <- map["statusCode"]
        content <- map["content"]
        pagination <- map["pagination"]
    }
    
}

struct contents : Mappable {
    var id : String?
    var name : String?
    var posterImage : String?
    var description : String?
    var startDateTime : String?
    var endDateTime : String?
    var status : String?
    var createdUserId : String?
    var createdDate : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        name <- map["name"]
        posterImage <- map["posterImage"]
        description <- map["description"]
        startDateTime <- map["startDateTime"]
        endDateTime <- map["endDateTime"]
        status <- map["status"]
        createdUserId <- map["createdUserId"]
        createdDate <- map["createdDate"]
    }
    
}

struct Pagination : Mappable {
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
