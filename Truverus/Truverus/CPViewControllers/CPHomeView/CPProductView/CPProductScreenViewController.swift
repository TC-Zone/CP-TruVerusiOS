//
//  CPProductScreenViewController.swift
//  Truverus
//
//  Created by User on 8/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit
import Kingfisher
import SVProgressHUD
import ObjectMapper


class CPProductScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    static let productInstance = CPProductScreenViewController()
    
    
    @IBOutlet weak var TableParralex: CPParallaxTableView!
    @IBOutlet weak var NoDataViewContainer: UIView!
    
    var productDataObject = [productData]()
    
    let defaults = UserDefaults.standard
    var CommunityArray = [CommunityData]()
    var newAccessTokenData = [RefreshAccessTokenData]()
    var EventsArray = [EventsData]()
    var PromoArray = [PromotionsData]()
    var FeedbackArray = [FeedbacksData]()
    var community : String!
  
    var descriptionText = String()
    var productname = String()
    var originalHeight: CGFloat!
    
    var currentviewFlag : Int!
    
    var scroll = UIScrollView()
    
    var images = [#imageLiteral(resourceName: "jursey"),#imageLiteral(resourceName: "blackJersy"),#imageLiteral(resourceName: "watch"),#imageLiteral(resourceName: "Running")]
    
    var MaximageCount = 4
    
    var imageURLs = [String]()
    
    var callingFrom : String!
    
    var image1 = UIImageView()
    var image2 = UIImageView()
    var image3 = UIImageView()
    var image4 = UIImageView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        validateView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setdataWithServices), name: NSNotification.Name(rawValue: "load"), object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    func validateView() {
        
        if productStruct.productObj.productTitle == "" {
            print("no data")
            
            self.NoDataViewContainer.alpha = 1
            self.view.bringSubviewToFront(NoDataViewContainer)
            
        } else {
            print("has data")
            print("data is :: \(productStruct.productObj.productTitle)")
            self.NoDataViewContainer.alpha = 0
            self.view.sendSubviewToBack(NoDataViewContainer)
            
            SetUpTableView()
            
            SetupImageView()
            
        }
        
    }
    
    
    // MARK : called from collection view
    func setdata() {
        
        self.NoDataViewContainer.alpha = 0
        self.view.sendSubviewToBack(NoDataViewContainer)
        
        TableParralex.reloadData()
        
        SetUpTableView()
        
        SetupImageView()
        
        
    }
    
    
    // MARK : called from product view with web service data
    @objc func setdataWithServices() {
        
        TableParralex.reloadData()
        
        SetUpTableView()
        
        SetupImageView()
        
    }
    
    @objc func goToCommunity() {
        
        let communityID  = productStruct.productObj.CommunityID
        
        if communityID != "" {
            
            
            let token = defaults.value(forKey: keys.accesstoken)
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
            } else {
                
                getCommunityData()
//
               
            }
            
        } else {
            
            let alert = UIAlertController(title: "Sorry!", message: "No Community found for this product", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
        
    }
    
 
    func SetUpTableView(){
        
        TableParralex.constructParallaxHeader()
        TableParralex.delegate = self
        TableParralex.dataSource = self
        
        let imageviewHeight = (UIScreen.main.bounds.height / 5) * 3.2
        
        TableParralex.contentInset = UIEdgeInsets(top: imageviewHeight, left: 0, bottom: 0, right: 0)
        
    }
    
    func SetupImageView(){
        
        view.addSubview(scroll)
        
        let rect = CGRect(x: 0, y: 0, width: view.bounds.width, height: (UIScreen.main.bounds.height / 5) * 3.2)
        
        scroll.frame = rect
        scroll.backgroundColor = UIColor.white
        scroll.contentOffset.x = 0
        scroll.isPagingEnabled = true
        
        
        var countIndex : Int!
        
        if callingFrom == "collection" {
            countIndex = 2
        } else {
            countIndex = Int(productStruct.productObj.ImagesList.count)
        }
        
        for i in 0..<countIndex{
            
            var imgUrl : URL!
            
            print("struct image count :: \(productStruct.productObj.ImagesList)")
            if productStruct.productObj.ImagesList.count != 0 {
                print("in arrayyyyyy :: \(productStruct.productObj.ImagesList[i])")
                imgUrl = URL(string: productStruct.productObj.ImagesList[i])!
                
            } else {
                
                imgUrl = nil
            }
            
            if(i == 0){
                
                if callingFrom == "collection" {
                    image1.image = images[i]
                } else {
                    if imgUrl != nil {
                    image1.kf.setImage(with: imgUrl)
                    }
                }
                
                let xPosition = self.view.frame.width * CGFloat(i)
                image1.contentMode = .scaleAspectFill
                image1.frame = CGRect(x: xPosition, y: 0, width: self.view.frame.width, height: self.scroll.frame.height)
                scroll.addSubview(image1)
                
            } else if (i == 1){
                
                if callingFrom == "collection" {
                    image2.image = images[i]
                } else {
                    if imgUrl != nil {
                        image2.kf.setImage(with: imgUrl)
                    }
                }
                
                let xPosition = self.view.frame.width * CGFloat(i)
                image2.contentMode = .scaleAspectFill
                image2.frame = CGRect(x: xPosition, y: 0, width: self.view.frame.width, height: self.scroll.frame.height)
                scroll.addSubview(image2)
                
            } else if (i == 2){
                
                if callingFrom == "collection" {
                    image3.image = images[i]
                } else {
                    if imgUrl != nil {
                        image3.kf.setImage(with: imgUrl)
                    }
                }
                
                let xPosition = self.view.frame.width * CGFloat(i)
                image3.contentMode = .scaleAspectFill
                image3.frame = CGRect(x: xPosition, y: 0, width: self.view.frame.width, height: self.scroll.frame.height)
                scroll.addSubview(image3)
                
            } else if (i == 3){
                
                if callingFrom == "collection" {
                    image4.image = images[i]
                } else {
                    if imgUrl != nil {
                        image4.kf.setImage(with: imgUrl)
                    }
                }
                
                let xPosition = self.view.frame.width * CGFloat(i)
                image4.contentMode = .scaleAspectFill
                image4.frame = CGRect(x: xPosition, y: 0, width: self.view.frame.width, height: self.scroll.frame.height)
                scroll.addSubview(image4)
                
            } else {
                
                print("count is too much than 4")
                
            }
            
            scroll.delegate = self
            
            var j = 0
            if(i > 3){
                j = 3
            }else{
                j = i
            }
            
            scroll.contentSize.width = scroll.frame.width * CGFloat(j + 1)
            
        }
        
        
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        if let _ = scrollView as? UITableView {
            
            //tableview
            
            TableParralex.updateHeaderView()
            
            let height = (UIScreen.main.bounds.height / 5) * 3.2
            let y = height - (scrollView.contentOffset.y + height)
            let h = max(46, y)
            let rect = CGRect(x: 0, y: 0, width: view.bounds.width, height: h)
            
            scroll.frame = rect
            image1.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: h)
            image2.frame = CGRect(x: self.view.frame.width * CGFloat(1), y: 0, width: view.bounds.width, height: h)
            image3.frame = CGRect(x: self.view.frame.width * CGFloat(2), y: 0, width: view.bounds.width, height: h)
            image4.frame = CGRect(x: self.view.frame.width * CGFloat(3), y: 0, width: view.bounds.width, height: h)
            
        } else{
            
            //scrollview
            
            TableParralex?.visibleCells.forEach { cell in
                if let cell = cell as? CPCustomTableViewCell {
                    
                    let page = Int(scroll.contentOffset.x / scroll.frame.size.width)
                    cell.setPagecontrol(number: page)
                }
            }
            
        }
        
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if let _ = scrollView as? UITableView {
            
            //tableview
            
        } else{
            
            //scrollview
            
            changesize()
        }
        
    }
    
    func changesize(){
        
        
        let pageNumber = Int(scroll.contentOffset.x / scroll.frame.size.width)
        
        if (pageNumber == 0){
            image1.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: self.scroll.frame.height)
            scroll.bringSubviewToFront(image1)
        }
        else if (pageNumber == 1){
            image2.frame = CGRect(x: self.view.frame.width * CGFloat(1), y: 0, width: view.bounds.width, height: self.scroll.frame.height)
            scroll.bringSubviewToFront(image2)
        }
        else if (pageNumber == 2){
            image3.frame = CGRect(x: self.view.frame.width * CGFloat(2), y: 0, width: view.bounds.width, height:  self.scroll.frame.height)
            scroll.bringSubviewToFront(image3)
        }
        else if (pageNumber == 3){
            image4.frame = CGRect(x: self.view.frame.width * CGFloat(3), y: 0, width: view.bounds.width, height:  self.scroll.frame.height)
            scroll.bringSubviewToFront(image4)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CPProductCell") as? CPCustomTableViewCell {
            
            
            if callingFrom == "collection" {
                cell.SetText(description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.", productName: productname)
            } else {
                cell.SetText(description: productStruct.productObj.ProductDescription, productName: productStruct.productObj.productTitle)
            }
            
            if (productStruct.productObj.ImagesList.count < 2){
                cell.PageControll.numberOfPages = 0
                
            } else if (images.count > 4){
                cell.PageControll.numberOfPages = 4
            } else {
                cell.PageControll.numberOfPages = productStruct.productObj.ImagesList.count
            }
            
            if (currentviewFlag == 1){
                
                if callingFrom == "collection" {
                    cell.ProductNameLabel.text = productname
                } else {
                    cell.ProductNameLabel.text = productStruct.productObj.productTitle
                }
                
                cell.TransferButton.isHidden = false
                cell.BackButton.isHidden = false
                cell.BackButton.addTarget(self, action: #selector(self.back(_:)), for: .touchUpInside)
                cell.TransferButton.addTarget(self, action: #selector(transfer(_:)), for: .touchUpInside)
                
            } else {
                
                cell.CommunityButton.addTarget(self, action: #selector(goToCommunity), for: .touchUpInside)
                cell.TransferButton.isHidden = true
                cell.BackButton.isHidden = true
                
            }
            
            return cell
        } else {
            
            return CPCustomTableViewCell()
            
        }
    }
  
    @objc func transfer(_ sender: UIButton?) {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Transfer", bundle: nil)
        let Acc : CPTransferViewController = storyboard.instantiateViewController(withIdentifier: "CPTransferVC") as! CPTransferViewController
        
        self.navigationController?.pushViewController(Acc, animated: true)

        
    }
    
    @objc func back(_ sender: UIButton?) {
        
        if let parent = self.parent as? CPCollectionViewController {
            let transition = CATransition()
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            parent.view.layer.add(transition, forKey: nil)
            parent.handleBack()
        }
        
    }
    
    func manageContent(){
        
        descriptionText = "When you think Nike, your mind can take you in so many different directions, but it all comes back to the When you think Nike, your mind can take you in so many different directions, but it When you think Nike, your mind can take you in so many different directions, but it all comes back to the When you think Nike, your mind can take you in so many different directions, but itWhen you think Nike, your mind can take you in so many different directions, but it all comes back to the When you think Nike, your mind can take you in so many different directions, but itWhen you think Nike, your mind can take you in so many different directions, but it all comes back to the When you think Nike, your mind can take you in so many different directions, but itWhen you think Nike, your mind can take you in so many different directions, but it all comes back to the When you think Nike, your mind can take you in so many different directions, but itWhen you think Nike, your mind can take you in so many different directions, but it all comes back to the When you think Nike, your mind can take you in so many different directions, but itWhen you think Nike, your mind can take you in so many different directions, but it all comes back to the When you think Nike, your mind can take you in so many different directions, but itWhen you think Nike, your mind can take you in so many different directions, but it all comes back to the When you think Nike, your mind can take you in so many different directions, but itWhen you think Nike, your mind can take you in so many different directions, but it all comes back to the When you think Nike, your mind can take you in so many different directions, but itWhen you think Nike, your mind can take you in so many different directions, but it all comes back to the When you think Nike, your mind can take you in so many different directions, but itWhen you think Nike, your mind can take you in so many different directions, but it all comes back to the When you think Nike, your mind can take you in so many different directions, but itWhen you think Nike, your mind can take you in so many different directions, but it all comes back to the When you think Nike, your mind can take you in so many different directions, but itWhen you think Nike, your mind can take you in so many different directions, but it all comes back to the When you think Nike, your mind can take you in so many different directions, but itWhen you think Nike, your mind can take you in so many different directions, but it all comes back to the When you think Nike, your mind can take you in so many different directions. "
        
        productname = "ADIDAS JERCEY"
        
    }
    


}



extension CPProductScreenViewController {
    
    private func getCommunityData(){
        SVProgressHUD.show()
        
        let token = defaults.value(forKey: keys.accesstoken)
        
        community = productStruct.productObj.CommunityID
        
        let tokenResult = validateToken(token: token)
        
        if tokenResult == true {
            
            print("current access token is :: \(token)")
            
            let headers: [String: String] = ["Authorization": "Bearer "+(token as! String)]
            
            print("community recieved :: \(community)")
            
            let url = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.COMMUNITY_DATA_VIEW + "\(community ?? "")") as String
            
            print("url is :: \(url)")
            //        let parameters : [String : Any] = ["authCode=" : "89a9a3077550a1f6df9066a6091017a13e1a266e01e1b071093a4b75a84f338cf979056621a5d2a455c23ebeb2deb74b5cace5c9c6e10620a5741af3d67d5f1b2b752134e9c9"]
            
            let parameters : [String : Any] = [:]
            
            if let url = URL(string: url) {
                ApiManager.shared().makeRequestAlamofire(route: url, method: .get, autherized: false, parameter: parameters, header: headers){ (response) in
                    SVProgressHUD.dismiss()
                    switch response{
                    case let .success(data):
                        self.serializeCommunityDataResponse(data: data)
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
                                    self.getCommunityData()
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
    
    func serializeCommunityDataResponse(data: Data) {
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            print("data in response :: \(json)")
            guard let CommunityResponse: CommunityData = Mapper<CommunityData>().map(JSONObject: json) else {
                return
            }
            self.CommunityArray = [CommunityResponse]
            communityBase.communityArrayBase = CommunityArray
            print("data array count :: \(CommunityArray.count)")
            print("status of community response :: \(CommunityResponse.status)")
            print("status of community description :: \(CommunityResponse.content?.description)")
            print("status of community name :: \(CommunityResponse.content?.name)")
            print("status of community id :: \(CommunityResponse.content?.id)")
            print("status of community status :: \(CommunityResponse.content?.status)")
            print("status of community client id :: \(CommunityResponse.content?.client?.id)")
            print("status of community client name :: \(CommunityResponse.content?.client?.name)")
            
            let story = UIStoryboard.init(name: "CPCommunity", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "CPCommunityMainViewController") as! CPCommunityMainViewController
            vc.community = community
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.pushViewController(vc, animated: true)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadComData"), object: nil)

            
            

        }catch {
            print(error)
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
            
            print("url is :: \(url)")
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
            
            
        }catch {
            print(error)
        }
    }
    
}
    

