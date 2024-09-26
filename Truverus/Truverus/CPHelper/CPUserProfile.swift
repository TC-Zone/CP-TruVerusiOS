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
        static var FCMToken = String()
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

struct  StructProductRelatedData {
    static var ProductTagCode = String()
    static var purchaseAvailability = Bool()
}

struct productCollectionBucket {
    
    static var productListBucket = [ProductCollectionBase]()
    static var communityList = [String]()
    static var communityNamelist = [String]()
    static var imageidlist = [String]()
    static var communityIDList = [String]()
    static var comData = [[String : String]]()
    static var featureCom = [comListFeatures]()
    
}

struct purchasedProductResponse {
    static var purchasedDataBucket = [ProductCollectionBase]()
}


class comListFeatures {
    var comID = String()
    var ComName = String()
    
    init(comID:String, ComName:String){
        self.comID = comID
        self.ComName = ComName
    }
}
