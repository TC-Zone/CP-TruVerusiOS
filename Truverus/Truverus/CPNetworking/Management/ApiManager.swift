//
//  ApiManager.swift
//  Truverus
//
//  Created by User on 17/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import Foundation

import Alamofire
import Reachability
import SVProgressHUD

extension ResponseError {
    static let noInternetConnection = ResponseError(error: NSLocalizedString("No internet connection", comment: ""), statusCode: -1)
}

enum APIResult<T>{
    case success(T)
    case failure(ResponseError)
}

class ApiManager {
    
    let defaults = UserDefaults.standard
    var reachability = Reachability()
    var isReachable: Bool { return reachability?.connection != .none ? true : false }
    
    var appDelegateRefreshTokenProtocol : AppDelegateRefreshTokenProtocol?
    
    private static var sharedApiManager: ApiManager = {
        let apiManager = ApiManager()
        return apiManager
    }()
    
    private init(){
        initReachibility()
    }
    
    class func shared() -> ApiManager {
        return sharedApiManager
    }
    
    func isReachableConnection() -> Bool{
        self.initReachibility()
        guard isReachable else{
            print("Common Reachable connection : Not Reachable")
            return false
        }
        return true
    }
    
    fileprivate var noInternetConnectionResponse: ResponseError {
        return .noInternetConnection
    }
    
    func makeRequestAlamofire(route:URL, method:HTTPMethod, autherized:Bool, parameter:Parameters,header:[String:String], callback: @escaping (APIResult<Data>) -> Void){
        
        let headers = header
        
        guard isReachableConnection() else{
            callback(.failure(noInternetConnectionResponse))
            return
        }
        
        Alamofire.request(route,method: method,parameters:parameter, encoding: JSONEncoding.default,headers:headers ).validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"]).responseData { response in
                switch response.result {
                case .success(let val):
                    callback(.success((val)))
                case .failure(let error):
                    ///Commented Codes Deleted
                    
                    if(response.response != nil) {
                        if let statusCode = response.response?.statusCode{
                            print("status code check \(statusCode)")
                            if statusCode == 401 {
                                callback(.failure(ResponseError.init(error: error.localizedDescription, errorType: .error, statusCode: response.response!.statusCode)))
//                                self.refreshAccessToken(){ (results) in
//                                    print("Process")
//                                    switch results{
//                                    case .success(_):
//                                        print("results success check")
//                                        self.makeRequestAlamofire(route: route, method: method, autherized: autherized, parameter: parameter, header: header){ (apiResult) in
//                                            switch apiResult{
//                                            case let .success(data): callback(.success((data)))
//                                            case let .failure(error): callback(.failure(error))
//                                            }
//                                        }
//                                    case let .failure(error):
//                                        callback(.failure(error))
//                                    }
//                                }
                            }else{
                                callback(.failure(ResponseError.init(error: error.localizedDescription, errorType: .error, statusCode: response.response!.statusCode)))
                            }
                        }
                    }else{
                        callback(.failure(ResponseError.init(error: error.localizedDescription, errorType: .error, statusCode:0)))
                    }
                }
        }
    }
    
    //Get request Only --------------->
    func makeGetRequestAlamofire(route:URL, method:HTTPMethod, autherized:Bool, header:[String:String], callback: @escaping (APIResult<Data>) -> Void){
        
        let headers = header
        
        guard isReachableConnection() else{
            callback(.failure(noInternetConnectionResponse))
            return
        }
        
        Alamofire.request(route,method: method, encoding: JSONEncoding.default,headers:headers ).validate(statusCode: 200..<300)
            .validate(contentType: ["application/json","text/plain;charset=UTF-8"]).responseData { response in
                switch response.result {
                case .success(let val):
                    callback(.success((val)))
                case .failure(let error):
                    ///Commented Codes Deleted
                    if(response.response != nil) {
                        if let statusCode = response.response?.statusCode{
                            print("status code check \(statusCode)")
                            if statusCode == 401 {
                                self.refreshAccessToken() { (results) in
                                    print("Process")
                                    switch results {
                                    case .success(_):
                                        print("results success check")
                                        self.makeGetRequestAlamofire(route: route, method: method, autherized: autherized, header: header){ (apiResult) in
                                            switch apiResult {
                                            case let .success(data): callback(.success((data)))
                                            case let .failure(error): callback(.failure(error))
                                            }
                                        }
                                    case let .failure(error):
                                        callback(.failure(error))
                                    }
                                }
                            }else{
                                callback(.failure(ResponseError.init(error: error.localizedDescription, errorType: .error, statusCode: response.response!.statusCode)))
                            }
                        }
                    }else{
                        callback(.failure(ResponseError.init(error: error.localizedDescription, errorType: .error, statusCode:0)))
                    }
                }
        }
    }
    
    //
    
    
    func RetrieveNewAccessToken(callback: @escaping (APIResult<Data>) -> Void) {
        
        
        let username = "CPAP"
        let password = "Cp43&$^fdgd*+!!@#Agdo4Ged"
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)! as NSData
        let base64EncodedString = loginData.base64EncodedString()
        let url = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.REFRESH_TOKEN_RENEWAL) as String
        
        print("url is :: \(url)")
        
        let headers = [
            "Content-Type":  "application/x-www-form-urlencoded",
            "Authorization": "Basic \(base64EncodedString)"
        ]
        
        let parameters: Parameters = [
            "refresh_token" : defaults.value(forKey: "Refresh_Token") as! String,
            "grant_type": "refresh_token"
        ]
        
        
        if let url = URL(string: url) {
            Alamofire.request(url,method:.post,parameters:parameters, encoding: URLEncoding.default ,headers:headers).debugLog().responseData { response in
                switch response.result {
                case .success(let val):
                    callback(.success((val)))
                    print("succeeeded with :: \(val)")
                    debugPrint(val)
                    print(response.response?.allHeaderFields)
                case .failure(let error):
                    ///Commented Codes Deleted
                    
                    if(response.response != nil) {
                        if let statusCode = response.response?.statusCode{
                            print("status code check \(statusCode)")
                            if statusCode == 401 {
                                
                                print("failed with 401 :: \(error)")
                                callback(.failure(ResponseError.init(error: error.localizedDescription, errorType: .error, statusCode: response.response!.statusCode)))
                                
                            }else{
                                 callback(.failure(ResponseError.init(error: error.localizedDescription, errorType: .error, statusCode: response.response!.statusCode)))
                            }
                        }
                    }else{
                        callback(.failure(ResponseError.init(error: error.localizedDescription, errorType: .error, statusCode:0)))
                    }
                }
            }
        }
        
    }
    
    private func refreshAccessToken(compeletion: @escaping(APIResult<Void>)->Void){
        self.appDelegateRefreshTokenProtocol?.refreshAccessTokenOnBase(){ (response) in
            switch response{
            case .success:
                compeletion(.success(()))
            case .failure(_):
                compeletion(.failure(ResponseError(error: "Token Error")))
            }
        }
        
        
    }
    
    func initReachibility() {
        guard let reachability = Reachability() else { return }
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachabilty: ", "Reachable via WiFi")
            } else {
                print("Reachabilty: ", "Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { reachability in
            print("Reachabilty: ", "Not reachable")
            
            //POP Alert to Internet Connection
            //            let popOverVC = UIStoryboard(name: "SignUp", bundle: nil).instantiateViewController(withIdentifier: "AlertSB") as! SignInAlertViewController
            //            popOverVC.verificationExeType = .Error
            //            popOverVC.msgTitle = "Error"
            //            popOverVC.errorMessage = "No internet connection"
            //
            //            let alertWindow = UIWindow(frame: UIScreen.main.bounds)
            //            alertWindow.rootViewController = UIViewController()
            //            alertWindow.windowLevel = UIWindowLevelAlert + 1;
            //            alertWindow.makeKeyAndVisible()
            //            alertWindow.rootViewController?.present(popOverVC, animated: true, completion: nil)
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Reachabilty: ", "Unable to start notifier")
        }
    }
}



extension Request {
    public func debugLog() -> Self {
        #if DEBUG
        debugPrint("=======================================")
        debugPrint(self)
        debugPrint("=======================================")
        #endif
        return self
    }
}
