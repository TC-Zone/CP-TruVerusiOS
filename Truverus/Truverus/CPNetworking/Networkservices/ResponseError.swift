//
//  ResponseError.swift
//  Truverus
//
//  Created by User on 17/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation

open class ResponseError: Error {
    
    public enum ViewType: String {
        case error, warning, info
    }
    
    open var errorCode: String = ""
    
    open var localizedDescription: String = ""
    
    open var errorType: ViewType = .error
    
    open var request: URLRequest?
    
    open var JSON: Any?
    
    open var statusCode: Int = 0
    
    public init(error: String, localizedDescription: String = "", errorType: ViewType = .error, statusCode: Int = 0) {
        self.errorCode = error
        self.localizedDescription = localizedDescription.isEmpty ? NSLocalizedString(errorCode, comment: "") : localizedDescription
        self.errorType = errorType
        self.statusCode = statusCode
    }
    
    open var description: String {
        return String(format: "Error: %@ Description: %@", errorCode, localizedDescription)
    }
    
}
