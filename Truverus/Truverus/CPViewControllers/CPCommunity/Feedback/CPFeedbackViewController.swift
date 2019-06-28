//
//  CPFeedbackViewController.swift
//  Truverus
//
//  Created by User on 13/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import Kingfisher
import SVProgressHUD

class CPFeedbackViewController: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource{
    
    
    @IBOutlet weak var FeedbackSubviewContainer: UIView!
    @IBOutlet weak var FeedbackCollectionView: UICollectionView!
    
    let descriptions = ["Nike Air Max 270","Nike Women's Reversible"]
    let images = [#imageLiteral(resourceName: "nikeshoe"),#imageLiteral(resourceName: "blackjer")]
    let Brandimages = [#imageLiteral(resourceName: "nike logo"),#imageLiteral(resourceName: "adidas logo")]
    let communities = ["NIKE COMMUNITY","ADDIDAS COMMUNITY"]
    
    let defaults = UserDefaults.standard
    
    var SurvayID : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        FeedbackCollectionView.dataSource = self
        FeedbackCollectionView.delegate = self
        FeedbackSubviewContainer.alpha = 0
        
        
        let layout = self.FeedbackCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 3, right: 0)
        layout.minimumInteritemSpacing = 1
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if feedbacksbase.feedbackarraybase.isEmpty == false {
            
            if feedbacksbase.feedbackarraybase[0].content!.count != 0 {
                return feedbacksbase.feedbackarraybase[0].content!.count
            } else {
                return 0
            }
            
        } else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = FeedbackCollectionView.dequeueReusableCell(withReuseIdentifier: "feedbackCell", for: indexPath) as! CPFeedbackCollectionViewCell
        
        if communityBase.communityArrayBase[0].content?.id != nil || feedbacksbase.feedbackarraybase[0].content![indexPath.row].name != nil {
        
            let imageID = communityBase.communityArrayBase[0].content?.client?.id
            let imageurl = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.CLIENT_IMAGE_BY_ID + "\(imageID ?? "")") as String
            let imgUrl = URL(string: imageurl)
            
            if imgUrl != nil {
                
                cell.BrandImage.kf.setImage(with: imgUrl)
                
            } else {
                
                cell.BrandImage.image = UIImage(named: "noimage")
                
            }
            
        //cell.ProductImage.image = images[indexPath.item]
        cell.FeedbackTitle.text = communityBase.communityArrayBase[0].content?.name
        cell.Description.text = feedbacksbase.feedbackarraybase[0].content![indexPath.row].name
            
        } else {
            print("no data found for feedback \(indexPath.row)")
        }
        cell.BrandImage.layer.borderWidth = 2.0
        cell.BrandImage.layer.masksToBounds = false
        cell.BrandImage.layer.borderColor = UIColor(named: "TextAreaGray")?.cgColor
        cell.BrandImage.layer.cornerRadius = cell.BrandImage.frame.size.width / 2
        cell.BrandImage.clipsToBounds = true
        
        
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: (cell.contentView.layer.cornerRadius)).cgPath
        cell.layer.backgroundColor = UIColor.white.cgColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if collectionView == FeedbackCollectionView {
            
           
            let feedback = feedbacksbase.feedbackarraybase[0].content?[indexPath.row].name
            let feedbackID = feedbacksbase.feedbackarraybase[0].content?[indexPath.row].id
            //let product = descriptions[indexPath.item]
            
            print("selected product data :: feedback is :: \(feedback) and feed id is :: \(feedbackID)")
            
            getsurveyByFeedbackid(feedbackId: feedbackID!)
            
            //let vc  =  CPFeedbackSubViewController()
            //vc.BackButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
            
            //FeedbackSubviewContainer.alpha = 1
        }
        else {
        }
        
    }
    
    func animateTransition() {
        
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.layer.add(transition, forKey: nil)
        self.view.bringSubviewToFront(self.FeedbackSubviewContainer)
        FeedbackSubviewContainer.alpha = 1
        
    }
    
    func handleBack() {
        
        self.view.sendSubviewToBack(self.FeedbackSubviewContainer)
        self.FeedbackSubviewContainer.alpha = 0
        surveyModule.Syrvey.removeAll()
        
        self.FeedbackCollectionView.reloadData()
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

}


extension CPFeedbackViewController {
    
    private func getsurveyByFeedbackid(feedbackId : String) {
        
        showProgressHud()
        
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
                                    self.getsurveyByFeedbackid(feedbackId: feedbackId)
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
        
        showProgressHud()
        
        
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
                    
                    let pagecount = SurveyBase.pages?.count
                    
                    if pagecount != nil && pagecount ?? 0 > 0 {
                        
                        for j in 0...(pagecount! - 1) {
                            
                            if SurveyBase.pages![j].elements?.count != nil && (SurveyBase.pages![j].elements?.count ?? 0) > 0 {
                                
                                print("recreated response :: \(SurveyBase)")
                                print("page count :: \(SurveyBase.pages?.count)")
                                print("questions count :: \(SurveyBase.pages![j].elements?.count)")
                                let elemente = SurveyBase.pages![j].elements
                                let count = SurveyBase.pages![j].elements?.count
                                
                                for i in 0...(count! - 1) {
                                    
                                    print("type of page \(j) question \(i) is :: \(elemente![i].type ?? "nothing")")
                                }
                                
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadfeed"), object: nil)
                                
                                animateTransition()
                                
                            } else {
                                
                                
                            }
                            
                        }
                        
                    }
                    
                    
                    
                } catch let error as NSError {
                    print(error)
                }
                
                
                
            }
            
            
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
    
    
    func serializeNewAccessToken(data: Data) {
        do{
            print("data is :: \(data.description)")
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            print("data in response :: \(json)")
            guard let newTokenResponse: RefreshAccessTokenData = Mapper<RefreshAccessTokenData>().map(JSONObject: json) else {
                return
            }
            print("new Access token is :: \(newTokenResponse.access_token)")
            defaults.set(newTokenResponse.access_token, forKey: "Access_Token")
            print("new refresh token is :: \(newTokenResponse.refresh_token)")
            defaults.set(newTokenResponse.refresh_token, forKey: "Refresh_Token")
            print("User defaults updated!!")
            
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
