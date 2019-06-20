//
//  UserLoginDataModel.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 6/10/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation
import ObjectMapper

struct UserLoginData : Mappable {
    var access_token : String?
    var token_type : String?
    var refresh_token : String?
    var expires_in : Int?
    var scope : String?
    var user_type : String?
    var user_id : String?
    var jti : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        access_token <- map["access_token"]
        token_type <- map["token_type"]
        refresh_token <- map["refresh_token"]
        expires_in <- map["expires_in"]
        scope <- map["scope"]
        user_type <- map["user_type"]
        user_id <- map["user_id"]
        jti <- map["jti"]
    }
    
}
