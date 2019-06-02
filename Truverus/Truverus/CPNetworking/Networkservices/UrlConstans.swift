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
    static let EVENTS_BY_COMMUNITY_ID : String = "/user/api/events/community/"
    static let PROMOTIONS_BY_COMMUNITY_ID : String = "/user/api/promotions/community/"
    static let PROMOTION_IMAGE_BY_ID : String = "/user/api/downloads/promo/"
    static let EVENT_IMAGE_BY_ID : String = "/user/api/downloads/event/"
    static let FEEDBACK_BY_COMMUNITY_ID = "/user/api/feedback/community/"
}
