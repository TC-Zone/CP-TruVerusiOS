//
//  CPCommunityHomeViewController.swift
//  Truverus
//
//  Created by User on 28/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SVProgressHUD
import Kingfisher

class CPCommunityMainViewController: UIViewController {

    @IBOutlet weak var Logo: UIImageView!
    @IBOutlet weak var CommunityName: UILabel!
    @IBOutlet weak var CommunityDescription: UILabel!
    @IBOutlet weak var PromotionsCount: UILabel!
    @IBOutlet weak var EventsCount: UILabel!
    @IBOutlet weak var FeedbackIcon: UIImageView!
    @IBOutlet weak var FeedbackIndicationImage: UIImageView!
    
    let defaults = UserDefaults.standard
    var CommunityArray = [CommunityData]()
    var newAccessTokenData = [RefreshAccessTokenData]()
    var EventsArray = [EventsData]()
    var PromoArray = [PromotionsData]()
    var FeedbackArray = [FeedbacksData]()
    var community : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setdata()
        getEventsData()
        getPromotionsData()
        getFeedbackData()
//        NotificationCenter.default.addObserver(self, selector: #selector(setdata), name: NSNotification.Name(rawValue: "loadComData"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    
    func setdata() {

        if communityBase.communityArrayBase[0].content?.id != nil || communityBase.communityArrayBase[0].content?.id != "" {

            CommunityName.text = communityBase.communityArrayBase[0].content?.name
            CommunityDescription.text = communityBase.communityArrayBase[0].content?.description


            let imageID = communityBase.communityArrayBase[0].content?.client?.id
            let imageurl = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.CLIENT_IMAGE_BY_ID + "\(imageID ?? "")") as String
            let imgUrl = URL(string: imageurl)

            if imgUrl != nil {
                
                print("community logooo :: \(imageurl)")
                Logo.kf.setImage(with: imgUrl)

            } else {

                Logo.image = UIImage(named: "noimage")

            }
        }
        
        
//        if eventBase.eventarraybase[0].content?.count != nil   {
//            EventsCount.text = "\(eventBase.eventarraybase[0].content?.count ?? 0)"
//        }
//        if promotionBase.promoarraybase[0].content?.count != nil {
//            PromotionsCount.text = "\(promotionBase.promoarraybase[0].content?.count ?? 0)"
//        }
//        if feedbacksbase.feedbackarraybase[0].content?.count != 0 {
//            FeedbackIndicationImage.image = UIImage(named: "feedback done")
//        } else {
//            FeedbackIndicationImage.image = UIImage(named: "zero feedbacks")
//        }

    }

    
    @IBAction func ExploreButton(_ sender: Any) {
        
        let story = UIStoryboard.init(name: "CPCommunity", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "CPCommunityHomeViewController") as! CPCommunityHomeViewController
        
        vc.EventsObject = EventsArray
        vc.PromoObject = PromoArray
        
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }


}


extension CPCommunityMainViewController {
    
//    private func getCommunityData(){
//        SVProgressHUD.show()
//
//        let token = defaults.value(forKey: keys.accesstoken)
//
//
//        let tokenResult = validateToken(token: token)
//
//        if tokenResult == true {
//
//        print("current access token is :: \(token)")
//
//        let headers: [String: String] = ["Authorization": "Bearer "+(token as! String)]
//
//        print("community recieved :: \(community)")
//
//        let url = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.COMMUNITY_DATA_VIEW + "\(community ?? "")") as String
//
//        print("url is :: \(url)")
//        //        let parameters : [String : Any] = ["authCode=" : "89a9a3077550a1f6df9066a6091017a13e1a266e01e1b071093a4b75a84f338cf979056621a5d2a455c23ebeb2deb74b5cace5c9c6e10620a5741af3d67d5f1b2b752134e9c9"]
//
//        let parameters : [String : Any] = [:]
//
//        if let url = URL(string: url) {
//            ApiManager.shared().makeRequestAlamofire(route: url, method: .get, autherized: false, parameter: parameters, header: headers){ (response) in
//                SVProgressHUD.dismiss()
//                switch response{
//                case let .success(data):
//                    self.serializeCommunityDataResponse(data: data)
//                    print("hereee")
//                    print(response)
//                case .failure(let error):
//                    print("\(error.errorCode)")
//                    print("\(error.description)")
//                    print("error status code :: \(error.statusCode)")
//                    if error.statusCode == 401 { // MARK -: Means access token is expired
//                        ApiManager.shared().RetrieveNewAccessToken(callback: { (response) in
//                            switch response {
//                            case let .success(data):
//                                self.serializeNewAccessToken(data: data)
//                                self.getCommunityData()
//                                print(response)
//                            case .failure(let error):
//                                print("error in retrieving new access token :: \(error)")
//                            }
//                        })
//                    }
//                }
//            }
//        }
//        }
//
//    }
//
//    func serializeCommunityDataResponse(data: Data) {
//        do{
//            let json = try JSONSerialization.jsonObject(with: data, options: [])
//
//            print("data in response :: \(json)")
//            guard let CommunityResponse: CommunityData = Mapper<CommunityData>().map(JSONObject: json) else {
//                return
//            }
//            self.CommunityArray = [CommunityResponse]
//            communityBase.communityArrayBase = CommunityArray
//            print("data array count :: \(CommunityArray.count)")
//            print("status of community response :: \(CommunityResponse.status)")
//            print("status of community description :: \(CommunityResponse.content?.description)")
//            print("status of community name :: \(CommunityResponse.content?.name)")
//            print("status of community id :: \(CommunityResponse.content?.id)")
//            print("status of community status :: \(CommunityResponse.content?.status)")
//            print("status of community client id :: \(CommunityResponse.content?.client?.id)")
//            print("status of community client name :: \(CommunityResponse.content?.client?.name)")
//
//            CommunityName.text = CommunityResponse.content?.name
//            CommunityDescription.text = CommunityResponse.content?.description
//
//
//            let imageID = CommunityArray[0].content?.client?.id
//            let imageurl = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.CLIENT_IMAGE_BY_ID + "\(imageID ?? "")") as String
//            let imgUrl = URL(string: imageurl)
//
//            if imgUrl != nil {
//
//
//                print("imaage com string :: \(imageurl)")
//                print("imaage com url :: \(imgUrl)")
//                Logo.kf.setImage(with: imgUrl)
//
//            } else {
//
//                Logo.image = UIImage(named: "noimage")
//
//            }
//
//
////            let story = UIStoryboard.init(name: "CPHomeView", bundle: nil)
////            let vc = story.instantiateViewController(withIdentifier: "CPHomeView") as! CPHomeViewController
////
////            self.navigationController?.pushViewController(vc, animated: true)
////
////            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
//
//
//        }catch {
//            print(error)
//        }
//    }
    
    func serializeNewAccessToken(data: Data) {
        do{
            print("data is :: \(data.description)")
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            print("data in response :: \(json)")
            guard let newTokenResponse: RefreshAccessTokenData = Mapper<RefreshAccessTokenData>().map(JSONObject: json) else {
                return
            }
            self.newAccessTokenData = [newTokenResponse]
            print("new Access token is :: \(newTokenResponse.access_token)")
            defaults.set(newTokenResponse.access_token, forKey: "Access_Token")
            print("new refresh token is :: \(newTokenResponse.refresh_token)")
            defaults.set(newTokenResponse.refresh_token, forKey: "Refresh_Token")
            print("User defaults updated!!")
            
        }catch {
            print(error)
        }
        
    }
    
    private func validateToken(token : Any?) -> Bool {
        
        if token == nil {
            // Create the alert controller
            let alertController = UIAlertController(title: "Sorry!", message: "You are not loggedIn to view community", preferredStyle: .alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "Login", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
                let homeStoryBoard : UIStoryboard = UIStoryboard(name: "CPLogin", bundle: nil)
                let vc = homeStoryBoard.instantiateViewController(withIdentifier: "CPLoginView") as! CPLoginViewController
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
                NSLog("Cancel Pressed")
            }
            
            // Add the actions
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
            
            return false
        } else {
            return true
        }
        
    }
    
    
    private func getEventsData() {
        SVProgressHUD.show()
        
        let access = defaults.value(forKey: keys.accesstoken)
        
        let accessState = validateToken(token: access)
        
        if accessState == true {
            
            
            let headers: [String: String] = ["Authorization": "Bearer "+(access as! String)]
            
            let url = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.EVENTS_BY_COMMUNITY_ID + "\(community ?? "")") as String
            
            print("url is :: \(url)")
            //        let parameters : [String : Any] = ["authCode=" : "89a9a3077550a1f6df9066a6091017a13e1a266e01e1b071093a4b75a84f338cf979056621a5d2a455c23ebeb2deb74b5cace5c9c6e10620a5741af3d67d5f1b2b752134e9c9"]
            
            let parameters : [String : Any] = [:]
            
            if let url = URL(string: url) {
                ApiManager.shared().makeRequestAlamofire(route: url, method: .get, autherized: false, parameter: parameters, header: headers){ (response) in
                    SVProgressHUD.dismiss()
                    switch response{
                    case let .success(data):
                        self.serializeEventsData(data: data)
                        print("hereee")
                        print(response)
                    case .failure(let error):
                        print("\(error.errorCode)")
                        print("\(error.description)")
                        print("error status code :: \(error.statusCode)")
                        if error.statusCode == 401 { // MARK -: Means access token is expired
                            ApiManager.shared().RetrieveNewAccessToken(callback: { (response) in
                                switch response {
                                case let .success(data):
                                    self.serializeNewAccessToken(data: data)
                                    self.getEventsData()
                                    print(response)
                                case .failure(let error):
                                    print("error in retrieving new access token :: \(error)")
                                }
                            })
                        }
                    }
                }
            }
            
        }
        
    }
    
    
    func serializeEventsData(data: Data) {
        do{
            print("data is :: \(data.description)")
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            print("data in response :: \(json)")
            guard let promotionsResponse: EventsData = Mapper<EventsData>().map(JSONObject: json) else {
                return
            }
            self.EventsArray = [promotionsResponse]
            eventBase.eventarraybase = self.EventsArray
            print("promotionCount is :: \(promotionsResponse.content?.count)")
            EventsCount.text = "\(promotionsResponse.content?.count ?? 0)"
            
        }catch {
            print(error)
        }
    }
    
    
    private func getPromotionsData() {
        SVProgressHUD.show()

        let access = defaults.value(forKey: keys.accesstoken)

        let accessState = validateToken(token: access)

        if accessState == true {


            let headers: [String: String] = ["Authorization": "Bearer "+(access as! String)]

            let url = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.PROMOTIONS_BY_COMMUNITY_ID + "\(community ?? "")") as String

            print("url is :: \(url)")
            //        let parameters : [String : Any] = ["authCode=" : "89a9a3077550a1f6df9066a6091017a13e1a266e01e1b071093a4b75a84f338cf979056621a5d2a455c23ebeb2deb74b5cace5c9c6e10620a5741af3d67d5f1b2b752134e9c9"]

            let parameters : [String : Any] = [:]

            if let url = URL(string: url) {
                ApiManager.shared().makeRequestAlamofire(route: url, method: .get, autherized: false, parameter: parameters, header: headers){ (response) in
                    SVProgressHUD.dismiss()
                    switch response{
                    case let .success(data):
                        self.serializeNewPromotions(data: data)
                        print("hereee")
                        print(response)
                    case .failure(let error):
                        print("\(error.errorCode)")
                        print("\(error.description)")
                        print("error status code :: \(error.statusCode)")
                        if error.statusCode == 401 { // MARK -: Means access token is expired
                            ApiManager.shared().RetrieveNewAccessToken(callback: { (response) in
                                switch response {
                                case let .success(data):
                                    self.serializeNewAccessToken(data: data)
                                    self.getPromotionsData()
                                    print(response)
                                case .failure(let error):
                                    print("error in retrieving new access token :: \(error)")
                                }
                            })
                        }
                    }
                }
            }

        }

    }


    func serializeNewPromotions(data: Data) {
        do{
            print("data is :: \(data.description)")
            let json = try JSONSerialization.jsonObject(with: data, options: [])

            print("data in response :: \(json)")
            guard let promotionsResponse: PromotionsData = Mapper<PromotionsData>().map(JSONObject: json) else {
                return
            }
            self.PromoArray = [promotionsResponse]
            promotionBase.promoarraybase = self.PromoArray
            print("promotionCount is :: \(promotionsResponse.content?.count)")
            PromotionsCount.text = "\(promotionsResponse.content?.count ?? 0)"

        }catch {
            print(error)
        }
    }
    
    
    private func getFeedbackData() {
        
        SVProgressHUD.show()
        
        let access = defaults.value(forKey: keys.accesstoken)
        
        let accessState = validateToken(token: access)
        
        if accessState == true {
            
            
            let headers: [String: String] = ["Authorization": "Bearer "+(access as! String)]
            
            let url = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.FEEDBACK_BY_COMMUNITY_ID + "\(community ?? "")") as String
            
            print("feed back url is :: \(url)")
            //        let parameters : [String : Any] = ["authCode=" : "89a9a3077550a1f6df9066a6091017a13e1a266e01e1b071093a4b75a84f338cf979056621a5d2a455c23ebeb2deb74b5cace5c9c6e10620a5741af3d67d5f1b2b752134e9c9"]
            
            let parameters : [String : Any] = [:]
            
            if let url = URL(string: url) {
                ApiManager.shared().makeRequestAlamofire(route: url, method: .get, autherized: false, parameter: parameters, header: headers){ (response) in
                    SVProgressHUD.dismiss()
                    switch response{
                    case let .success(data):
                        self.serializeFeedbacks(data: data)
                        print("hereee")
                        print(response)
                    case .failure(let error):
                        print("\(error.errorCode)")
                        print("\(error.description)")
                        print("error status code :: \(error.statusCode)")
                        if error.statusCode == 401 { // MARK -: Means access token is expired
                            ApiManager.shared().RetrieveNewAccessToken(callback: { (response) in
                                switch response {
                                case let .success(data):
                                    self.serializeNewAccessToken(data: data)
                                    self.getFeedbackData()
                                    print(response)
                                case .failure(let error):
                                    print("error in retrieving new access token :: \(error)")
                                }
                            })
                        }
                    }
                }
            }
            
        }
        
    }
    
    func serializeFeedbacks(data: Data) {
        do{
            print("data is :: \(data.description)")
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            print("data in response :: \(json)")
            guard let feedbacksResponse: FeedbacksData = Mapper<FeedbacksData>().map(JSONObject: json) else {
                return
            }
            self.FeedbackArray = [feedbacksResponse]
            feedbacksbase.feedbackarraybase = self.FeedbackArray
            feedbacksbase.community = community
            print("promotionCount is :: \(feedbacksResponse.content?.count)")
            if feedbacksResponse.content?.count != 0 {
             FeedbackIndicationImage.image = UIImage(named: "feedback done")
            } else {
             FeedbackIndicationImage.image = UIImage(named: "zero feedbacks")
            }
            
        }catch {
            print(error)
        }
    }
    
}
