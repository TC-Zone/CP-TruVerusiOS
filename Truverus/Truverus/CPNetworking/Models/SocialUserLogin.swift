//
//  SocialUserLogin.swift
//  Truverus
//
//  Created by User on 17/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation
import ObjectMapper



class googleUser: Mappable {
    
//    var user_id : String?
//    var user_type : String?
    var jti : String?
    var expire : String?
    var token_type : String?
    var access_token : String?
    var refresh_token : String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
//        user_id <- map["user_id"]
//        user_type <- map["user_type"]
        jti <- map["response.jti"]
        expire <- map["response.expires_in"]
        token_type <- map["response.token_type"]
        access_token <- map["response.access_token"]
        refresh_token <- map["response.refresh_token"]
    }
    
    
}
