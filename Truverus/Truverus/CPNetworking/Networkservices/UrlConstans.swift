//
//  UrlConstans.swift
//  Truverus
//
//  Created by User on 17/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation

struct UrlConstans {
    
    static let BASE_URL             : String = "https://authenticak84f365ea.ca1.hana.ondemand.com"
    
    static let SOCIAL_USER_SIGN_IN  : String = "/user/api/social"
    static let AUTHENTICATE_PRODUCT : String = "/product/api/authenticate?"
    static let PRODUCT_DETAILS_VIEW : String = "/product/api/products/"
    static let PRODUCT_IMAGES_BY_ID : String = "/product/downloadFile/"
    static let COMMUNITY_DATA_VIEW  : String = "/user/api/communities/"
    static let REFRESH_TOKEN_RENEWAL: String = "/user/oauth/token"
    static let CLIENT_IMAGE_BY_ID   : String = "/user/api/downloads/client/"
    static let EVENTS_BY_COMMUNITY_ID : String     = "/user/api/events/community/"
    static let PROMOTIONS_BY_COMMUNITY_ID : String = "/user/api/promotions/community/"
    static let PROMOTION_IMAGE_BY_ID : String      = "/user/api/downloads/promo/"
    static let EVENT_IMAGE_BY_ID : String          = "/user/api/downloads/event/"
    static let FEEDBACK_BY_COMMUNITY_ID : String   = "/user/api/feedback/community/"
    static let USER_REGISTRATION : String          = "/user/api/mobile/user"
    static let VERIFY_EMAIL_GETRESULT : String     = "/user/api/mobile/userActivate"
    static let USER_LOGIN : String                 = "/user/oauth/token"
    static let VIEW_USER_BY_ID : String            = "/user/api/mobile/userView/"
    static let VIEW_SURVAY_BY_FEEDBACK_ID : String = "/user/api/feedback/"
    static let GET_SURVAY_BY_ID : String           = "/survey/api/surveys/futureSurvey/"
    static var PURCHASE_PRODUCT : String           = "/product/api/productOps/purchase?"
    static var GET_PURCHASED_ITEMS : String        = "/product/api/productOps/soldProducts/"
    static var UPDATE_COMMUNITY_BY_PURCHASES : String = "/user/api/platform-users/communities/"
    static var PURCHASED_PRODUCTS_BY_USER_ID : String = "/product/api/productOps/soldProducts/"
    static var IS_PURCHASED_BY_AUTHCODE : String   = "/product/api/productOps/isPurchased/"
}
