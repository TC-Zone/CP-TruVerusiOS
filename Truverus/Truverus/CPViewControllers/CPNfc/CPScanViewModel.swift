//
//  CPScanViewModel.swift
//  Truverus
//
//  Created by User on 15/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPScanViewModel: NSObject {
    
    static let instance = CPScanViewModel.init()
    
    func scanTag(_ tagCode : String!, completion: @escaping(_ status : Bool, _ response : [String : Any]?) -> Void){
        _ = CPAPIManager.sharedInstance.validateTag(tagValue: tagCode, callback: { (status, message, response) in
            completion(status, response)
        })
    }
}
