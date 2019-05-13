//
//  UserProfile.swift
//  Truverus
//
//  Created by User on 10/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation

class StructProfile {
    
    struct ProfilePicture {
        static var ProfilePicURL = String()
        static var name = String()
        static var email = String()
        static var accessToken = String()
        static var IDToken = String()
    }
    
}

class StructGoogleProfile {
    
    struct GoogleProfileData {
        
        static var GoogleDataArray : [String]  = []
        
        static var ProfilePicURL = String()
        static var name = String()
        static var email = String()
    }
    
}
