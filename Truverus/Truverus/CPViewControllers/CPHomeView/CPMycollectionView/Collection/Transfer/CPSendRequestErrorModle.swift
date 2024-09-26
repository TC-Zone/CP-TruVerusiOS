//
//  CPSendRequestErrorModle.swift
//  Truverus
//
//  Created by Trumpcode on 2019-07-31.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation
import ObjectMapper

struct sendRequestErrorMapping : Mappable {
    var status : String?
    var statusCode : Int?
    var validationFailures : [soldValidationFailures]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        status <- map["status"]
        statusCode <- map["statusCode"]
        validationFailures <- map["validationFailures"]
    }
    
}

struct soldValidationFailures : Mappable {
    var field : String?
    var code : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        field <- map["field"]
        code <- map["code"]
    }
    
}
