//
//  CPAPIManager.swift
//  ClearPicture
//
//  Created by pasan vimukthi wijesuriya on 2/20/19.
//  Copyright © 2019 Trumpcode. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import SwiftyJSON

enum Router: URLRequestConvertible {
    
    static let baseURLString = CPConstants.API.BASE_URL
    
    case TagValidate([String : Any])
    case LoadQuestions(String)
    case LoadAnswers(String)
    
    var method: HTTPMethod {
        switch self {
        case .TagValidate:
            return .get
        case .LoadQuestions:
            return .get
        case .LoadAnswers:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .TagValidate:
            return "/product/api/authenticate"
        case .LoadQuestions(let surveryID):
            return "/survey/api/surveys/\(surveryID)"
        case .LoadAnswers(let answerID):
            return "/survey/api/answer-templates/\(answerID)"
        }
    }
    func asURLRequest() throws -> URLRequest {
        
        let url = try Router.baseURLString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //        if let token = LVUserDefaults.token {
        //            urlRequest.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        //        }
        
        
        switch self {
        case .TagValidate(let params):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: params)
        default:
            print("No encoding")
        }
        return urlRequest
    }
}

public class CPAPIManager {
    
    let manager : SessionManager
    
    public static let sharedInstance: CPAPIManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        return CPAPIManager(manager: SessionManager(configuration: configuration))
    }()
    
    private init(manager: SessionManager) {
        self.manager = manager
    }
    
    //# MARK: - NFC token validation
    func validateTag(tagValue: String,callback: @escaping (_ status:Bool, _ message:String?, _ response : [String : Any]?)->()) -> Request {
        let param : [String : Any] = ["authCode" : tagValue]
        let request = self.manager.request(Router.TagValidate(param)).responseJSON { response in
            
            debugPrint(response)
            
            if let json = response.result.value as? [String: Any] {
                print("JSON: \(json)")
                guard let response = json["content"] as? [String: Any] else {
                    return
                }
                let title = response["title"] as? String
                if title == "Sorry;"{
                    return callback (false, "Sorry", nil)
                }
                
                return callback (true, nil, response)
            }
            
        }
        debugPrint(request)
        
        return request
    }
    
    //# MARK: - Load Questions
    func loadQuestions(surveyID: String, callback: @escaping (_ status:Bool, _ message:String?, _ questions : [Any]?)->()) -> Request {
        let request = self.manager.request(Router.LoadQuestions(surveyID)).responseJSON { response in
            
            debugPrint(response)
            
            if let json = response.result.value as? [String: Any] {
                print("JSON: \(json)")
                guard let response = json["content"] as? [String: Any] else {
                    return
                }
                let questionsArray = response["questions"] as! [Any]
                return callback (true, nil, questionsArray)
            }
            
        }
        debugPrint(request)
        
        return request
    }
    
    //# MARK: - Load Answers
    func loadAnswers(answerID: String, callback: @escaping (_ status:Bool, _ message:String?, _ response : [String : Any]?)->()) -> Request {
        let request = self.manager.request(Router.LoadAnswers(answerID)).responseJSON { response in
            
            debugPrint(response)
            
            if let json = response.result.value as? [String: Any] {
                print("JSON: \(json)")
                guard let response = json["content"] as? [String: Any] else {
                    return
                }
                return callback (true, nil, response)
            }
            
        }
        debugPrint(request)
        
        return request
    }
    
    //# MARK: - Validate Response
    func validateResponse (response : DataResponse<Any>) -> (Bool, String){
        
        guard (response.response?.statusCode) != nil else {
            return (false, CPConstants.MESSAGES.SOMETHING_WRONG)
        }
        
        guard response.result.error == nil else {
            return (false, CPConstants.MESSAGES.SOMETHING_WRONG)
        }
        
        guard response.result.isSuccess else {
            return (false, CPConstants.MESSAGES.SOMETHING_WRONG)
        }
        
        guard let json = response.result.value as? [String: Any] else {
            print("Error: \(String(describing: response.result.error))")
            return (false, response.result.error!.localizedDescription)
        }
        
        //ERROR TRUE
        guard let error = json["error"] as? Bool, error == false else {
            
            // let code = json["code"] as? Int
            
            //            if (code == 1115){
            //
            //                CEBUHelper.clear()
            //                let story = UIStoryboard(name: "Login", bundle: nil)
            //                let vc = story.instantiateViewController(withIdentifier: "CEBULoginViewController")
            //                let navController = UINavigationController.init(rootViewController: vc)
            //                appDelegate.window?.rootViewController = navController
            //
            //                return (false, "")
            //            }
            
            let errorMessage = json["message"] as? String
            
            return (false, errorMessage!)
        }
        
        return(true, "")
        
    }
}

