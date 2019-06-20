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
    @IBOutlet weak var explorebutton: UIButton!
    
    let defaults = UserDefaults.standard
    var CommunityArray = [CommunityData]()
    var newAccessTokenData = [RefreshAccessTokenData]()
    var EventsArray = [EventsData]()
    var PromoArray = [PromotionsData]()
    var FeedbackArray = [FeedbacksData]()
    var community : String!
    var feedbackId : String!
    var SurvayID : String!
    //hhhh
    //jbkjbbj
    
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
            self.feedbackId = feedbacksResponse.content![0].id
            print("promotionCount is :: \(feedbacksResponse.content?.count)")
            if feedbacksResponse.content?.count != 0 {
             FeedbackIndicationImage.image = UIImage(named: "feedback done")
            } else {
             FeedbackIndicationImage.image = UIImage(named: "zero feedbacks")
            }
            
            getsurveyByFeedbackid()
            
        }catch {
            print(error)
        }
    }
    
    
    private func getsurveyByFeedbackid() {
        
        SVProgressHUD.show()
        
        let access = defaults.value(forKey: keys.accesstoken)
        
        let accessState = validateToken(token: access)
        
        if accessState == true && feedbackId != "" {
            
            
            let headers: [String: String] = ["Authorization": "Bearer "+(access as! String)]
            
            let url = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.VIEW_SURVAY_BY_FEEDBACK_ID + "\(feedbackId ?? "")") as String
            
            print("feed back url is :: \(url)")
            //        let parameters : [String : Any] = ["authCode=" : "89a9a3077550a1f6df9066a6091017a13e1a266e01e1b071093a4b75a84f338cf979056621a5d2a455c23ebeb2deb74b5cace5c9c6e10620a5741af3d67d5f1b2b752134e9c9"]
            
            let parameters : [String : Any] = [:]
            
            if let url = URL(string: url) {
                ApiManager.shared().makeRequestAlamofire(route: url, method: .get, autherized: false, parameter: parameters, header: headers){ (response) in
                    SVProgressHUD.dismiss()
                    switch response{
                    case let .success(data):
                        self.serializeSurvayIdfromFeedback(data: data)
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
                                    self.getsurveyByFeedbackid()
                                    print(response)
                                case .failure(let error):
                                    print("error in retrieving new access token :: \(error)")
                                }
                            })
                        }
                    }
                }
            }
            
        } else {
            
            print("something went wrong with feedback id")
            
        }
        
    }
    
    
    func serializeSurvayIdfromFeedback(data: Data) {
        do{
            print("data is :: \(data.description)")
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            print("data in response :: \(json)")
            guard let feedbacksSurveyResponse: survayByFeedbackData = Mapper<survayByFeedbackData>().map(JSONObject: json) else {
                return
            }
            
            if feedbacksSurveyResponse.content?.surveyId != "" {
                
                print("survay id is :: \(feedbacksSurveyResponse.content?.surveyId)")
                self.SurvayID = feedbacksSurveyResponse.content?.surveyId
            }
            
            getsurveyByid()
            
        }catch {
            print(error)
        }
    }
    
    private func getsurveyByid() {
        
        SVProgressHUD.show()
        self.explorebutton.isEnabled = false
        self.explorebutton.backgroundColor = UIColor.lightGray
        
        if SurvayID != "" {
            
            
            let headers: [String: String] = [:]
            
            let url = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.GET_SURVAY_BY_ID + "\(SurvayID ?? "")") as String
            
            print("feed back url is :: \(url)")
            //        let parameters : [String : Any] = ["authCode=" : "89a9a3077550a1f6df9066a6091017a13e1a266e01e1b071093a4b75a84f338cf979056621a5d2a455c23ebeb2deb74b5cace5c9c6e10620a5741af3d67d5f1b2b752134e9c9"]
            
            let parameters : [String : Any] = [:]
            
            if let url = URL(string: url) {
                ApiManager.shared().makeRequestAlamofire(route: url, method: .get, autherized: false, parameter: parameters, header: headers){ (response) in
                    SVProgressHUD.dismiss()
                    switch response{
                    case let .success(data):
                        self.serializeSurvay(data: data)
                        print("hereee")
                        print(response)
                    case .failure(let error):
                        self.explorebutton.isEnabled = true
                        self.explorebutton.backgroundColor = UIColor.black
                        print("\(error.errorCode)")
                        print("\(error.description)")
                        print("error status code :: \(error.statusCode)")
                        if error.statusCode == 401 { // MARK -: Means access token is expired
                            ApiManager.shared().RetrieveNewAccessToken(callback: { (response) in
                                switch response {
                                case let .success(data):
                                    self.serializeNewAccessToken(data: data)
                                    self.getsurveyByid()
                                    print(response)
                                case .failure(let error):
                                    print("error in retrieving new access token :: \(error)")
                                }
                            })
                        }
                    }
                }
            }
            
        } else {
            
            print("something went wrong with feedback id")
            
        }
        
    }
    
    
    func serializeSurvay(data: Data) {
        do{
            print("data is :: \(data.description)")
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            print("data in response :: \(json)")
            guard let SurveyResponse: SurvayData = Mapper<SurvayData>().map(JSONObject: json) else {
                return
            }
            
            if SurveyResponse.content?.jsonContent != "" {
                
                print("survay is :: \(SurveyResponse.content?.jsonContent)")
                let returnedSuryay = SurveyResponse.content?.jsonContent
                let returnedSuryayedit1 = returnedSuryay!.dropFirst(1)
                print("edit 1 :: \(returnedSuryayedit1)")
                let finalsurvayString = String(returnedSuryayedit1.dropLast(1)) as String
                print("ready string for survay :: \(finalsurvayString)")
                
                let goodstring = finalsurvayString.unescaped
                
                print("good string is :: \(goodstring)")
                
                let dataaaa = Data(goodstring.utf8)
//
                do {
                    let jsonsss = try JSONSerialization.jsonObject(with: dataaaa, options: [])
                   
                        print("recreated json :: \(jsonsss)") // use the json here
                        guard let SurveyBase: SurvayBase = Mapper<SurvayBase>().map(JSONObject: jsonsss) else {
                            return
                        }
                    
                    surveyModule.Syrvey = [SurveyBase]
                    
                    if SurveyBase.pages![0].elements?.count != nil && (SurveyBase.pages![0].elements?.count ?? 0) > 0 {
                        
                        print("recreated response :: \(SurveyBase)")
                        print("page count :: \(SurveyBase.pages?.count)")
                        print("questions count :: \(SurveyBase.pages![0].elements?.count)")
                        let elemente = SurveyBase.pages![0].elements
                        let count = SurveyBase.pages![0].elements?.count
                        
                        for i in 0...(count! - 1) {
                            
                            print("type of question \(i) is :: \(elemente![i].type ?? "nothing")")
                        }
                        
                    } else {
                        
                        
                        
                        
                    }
                    
                    
                    
                } catch let error as NSError {
                    print(error)
                }
                
               
                
            }
            
            self.explorebutton.isEnabled = true
            self.explorebutton.backgroundColor = UIColor.black
            
        }catch {
            print(error)
        }
    }
    
    
}

extension String {
    var unescaped: String {
        let entities = ["\0", "\t", "\n", "\r", "\"", "\'", "\\"]
        var current = self
        for entity in entities {
            let descriptionCharacters = entity.debugDescription.dropFirst().dropLast()
            let description = String(descriptionCharacters)
            current = current.replacingOccurrences(of: description, with: entity)
        }
        return current
    }
}
