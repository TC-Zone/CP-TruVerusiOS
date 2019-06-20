//
//  CPCollectionViewController.swift
//  Truverus
//
//  Created by User on 8/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SVProgressHUD
import Kingfisher

class CPCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var Collection: UICollectionView!
    
    let defaults = UserDefaults.standard
    
    var productDatasourceArray = [productData]()
    
    var tempImgArray = [String]()
    
    
    
    let productNames = ["Adidas Jacket","Guccie shoe","Rolex watch","Puffer Jacket"]
    let productImages = [#imageLiteral(resourceName: "jursey"),#imageLiteral(resourceName: "Running"),#imageLiteral(resourceName: "watch"),#imageLiteral(resourceName: "blackJersy")]
    
    let jacketimages = [#imageLiteral(resourceName: "jursey"),#imageLiteral(resourceName: "nikejackShaded")]
    let shoeimages = [#imageLiteral(resourceName: "Running"),#imageLiteral(resourceName: "shoe")]
    let watchtimages = [#imageLiteral(resourceName: "watch"),#imageLiteral(resourceName: "rollexShaded")]
    let jerceytimages = [#imageLiteral(resourceName: "blackJersy"),#imageLiteral(resourceName: "jacketShaded")]
    
    let titles = ["ADIDAS JACKET","GUCCI SHOE","ROLEX WATCH","NIKE WOMEN'S REVERSIBLE HEAVYWEIGHT PUFFER JACKET"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Collection.dataSource = self
        Collection.delegate = self
        
        
        
        let layout = self.Collection.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: (self.Collection.frame.size.width - 20) / 2, height: self.Collection.frame.size.height / 2)
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if productCollectionBucket.productListBucket.count != 0 {
            
            if productCollectionBucket.productListBucket[0].content?.count != 0 {
                return productCollectionBucket.productListBucket[0].content!.count
            } else {
                return 0
            }
        } else {
            return 0
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = Collection.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CPCollectionTabCollectionViewCell
        
        var count = Int()
        //getPurchasedProducts()
        print("temp array in collectuon :::::: \(tempImgArray)")
        
        if productCollectionBucket.productListBucket[0].content != nil {
            
            count = productCollectionBucket.productListBucket[0].content?.count ?? 0
            
        } else {
            
            count = 0
        }
        
        if count > 0 {
            
            if  productCollectionBucket.productListBucket[0].content?[indexPath.row].productDetail?.product?.id != nil && productCollectionBucket.productListBucket[0].content?[indexPath.row].productDetail?.product?.id != "" {
                
                print("product id sends :: \("\(productCollectionBucket.productListBucket[0].content?[indexPath.row].productDetail?.product?.id ?? "")")")
                
                getProductdata(productID: "\(productCollectionBucket.productListBucket[0].content?[indexPath.row].productDetail?.product?.id ?? "")") { (success) in
                    
                    print("imge 0 isss :::: \(productStruct.productObj.ImagesList[0])")
                    
                    if productStruct.productObj.ImagesList.count > 0 {
                        
                        var imgUrl : URL!
                        
                        print("here with gdddjdj 2:: \(productStruct.productObj.ImagesList)")
                        
                        imgUrl = URL(string: productStruct.productObj.ImagesList[0])!
                        
                        cell.collectionCellImage.kf.setImage(with: imgUrl)
                        
                    } else {
                        
                        cell.collectionCellImage.image = nil
                        
                    }
                    
                    
                }
                
                
                
            }
        
            
            if productCollectionBucket.productListBucket[0].content?[indexPath.row].productDetail?.product?.name != nil && productCollectionBucket.productListBucket[0].content?[indexPath.row].productDetail?.product?.name != "" {
                
                cell.CollectionCellProductLable.text = productCollectionBucket.productListBucket[0].content?[indexPath.row].productDetail?.product?.name
                
            } else {
                
                cell.CollectionCellProductLable.text = "Couldnt retrieve the name"
            }
            
            
        } else {
            
            
            
            
            
            
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        
        
        
        cell?.contentView.layer.cornerRadius = 6.0
        cell?.contentView.layer.borderWidth = 1.0
        cell?.contentView.layer.borderColor = UIColor.clear.cgColor
        cell?.contentView.layer.masksToBounds = true
        
        cell?.layer.shadowColor = UIColor.lightGray.cgColor
        cell?.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell?.layer.shadowRadius = 6.0
        cell?.layer.shadowOpacity = 1.0
        cell?.layer.masksToBounds = false
        cell?.layer.shadowPath = UIBezierPath(roundedRect: cell!.bounds, cornerRadius: (cell?.contentView.layer.cornerRadius)!).cgPath
        cell?.layer.backgroundColor = UIColor.white.cgColor
        
        
        
        let count = productCollectionBucket.productListBucket[0].content?.count
        
        if count ?? 0 > 0 {
            
            if  productCollectionBucket.productListBucket[0].content?[indexPath.row].productDetail?.product?.id != nil && productCollectionBucket.productListBucket[0].content?[indexPath.row].productDetail?.product?.id != "" {
                
                //self.Collection.isHidden = false
                
                print("product id sends :: \("\(productCollectionBucket.productListBucket[0].content?[indexPath.row].productDetail?.product?.id ?? "")")")
                
                getProductdata(productID: "\(productCollectionBucket.productListBucket[0].content?[indexPath.row].productDetail?.product?.id ?? "")") { (success) in
                    
                    print("imge 0 isss :::: \(productStruct.productObj.ImagesList[0])")
                    
                    if productStruct.productObj.ImagesList.count > 0 {
                        
                        var imgUrl : URL!
                        
                        print("here with gdddjdj 2:: \(productStruct.productObj.ImagesList)")
                        
                        imgUrl = URL(string: productStruct.productObj.ImagesList[0])!
                        
                        productStructforcommunity.productcollectionObj.ImagesList = productStruct.productObj.ImagesList
                        
                        if productCollectionBucket.productListBucket[0].content?[indexPath.row].productDetail?.product?.name != nil && productCollectionBucket.productListBucket[0].content?[indexPath.row].productDetail?.product?.name != "" {
                            
                            productStructforcommunity.productcollectionObj.productTitle = productCollectionBucket.productListBucket[0].content?[indexPath.row].productDetail?.product?.name ?? ""
                            
                        } else {
                            
                            productStructforcommunity.productcollectionObj.productTitle = "Couldnt retrieve the name"
                        }
                        
                        if productStruct.productObj.ProductDescription != "" {
                            
                            productStructforcommunity.productcollectionObj.ProductDescription =  productStruct.productObj.ProductDescription
                            
                        } else {
                            
                            productStructforcommunity.productcollectionObj.ProductDescription = "Couldnt retrieve the description"
                            
                        }
                        
                        
                    } else {
                        
                       productStructforcommunity.productcollectionObj.ImagesList = [""]
                        
                    }
                    
                    
                    self.addOrRemoveTransferView(sender: "add", index: indexPath.row)
                    
                    
                    self.animateTransition()
                    
                }
                
            }
            
            
        } else {
            
            print("hereeeee hfubvjnj ebfjfbj")
            
            handleBack()
            
        }
        
        
       
        
    }
    
    
    
    func addOrRemoveTransferView (sender : String, index : Int) {
        
        let news = self.storyboard?.instantiateViewController(withIdentifier: "CPProductScreenVC") as! CPProductScreenViewController
        news.view.frame = self.view.bounds
        news.currentviewFlag = 1
        
        news.image1.image = nil
        news.image2.image = nil
        news.image3.image = nil
        news.image4.image = nil
        
        
        if (sender == "add") {
            
            
                news.productname = productStructforcommunity.productcollectionObj.productTitle
                news.ProductDescription = productStructforcommunity.productcollectionObj.ProductDescription
             
            news.callingFrom = "collection"
            news.setdata()
            self.Collection.isHidden = true
            
            self.view.addSubview(news.view)
            addChild(news)
            news.didMove(toParent: self)
            
        } else if (sender == "Remove") {
            self.Collection.isHidden = false
            removeChild()
        }
        
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.clear.cgColor
        cell?.layer.borderWidth = 0
        
        cell?.contentView.layer.cornerRadius = 0
        cell?.contentView.layer.borderWidth = 0
        cell?.contentView.layer.borderColor = UIColor.clear.cgColor
        cell?.contentView.layer.masksToBounds = true
        
        cell?.layer.shadowColor = UIColor.clear.cgColor
        cell?.layer.shadowOffset = CGSize(width: 0, height: 0.0)
        cell?.layer.shadowRadius = 0.0
        cell?.layer.shadowOpacity = 0.0
        cell?.layer.masksToBounds = false
        cell?.layer.shadowPath = UIBezierPath(roundedRect: cell!.bounds, cornerRadius: (cell?.contentView.layer.cornerRadius)!).cgPath
        cell?.layer.backgroundColor = UIColor.white.cgColor
    }
    
    
    func animateTransition() {
        
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.layer.add(transition, forKey: nil)
        
        
    }
    
    func handleBack() {
        
        addOrRemoveTransferView(sender: "Remove", index: 6)
        
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


extension UIViewController {
    
    func removeChild() {
        self.children.forEach {
            $0.didMove(toParent: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
    }
}

extension CPCollectionViewController {
    
    
    
    
    
    private func getProductdata(productID : String , completion: @escaping (_ success: Bool) -> Void){
        SVProgressHUD.show()
        
        let headers: [String: String] = [:]
        
        let url = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.PRODUCT_DETAILS_VIEW + "\(productID)") as String
        
        print("url is :: \(url)")
        //        let parameters : [String : Any] = ["authCode=" : "89a9a3077550a1f6df9066a6091017a13e1a266e01e1b071093a4b75a84f338cf979056621a5d2a455c23ebeb2deb74b5cace5c9c6e10620a5741af3d67d5f1b2b752134e9c9"]
        
        let parameters : [String : Any] = [:]
        
        if let url = URL(string: url) {
            ApiManager.shared().makeRequestAlamofire(route: url, method: .get, autherized: true, parameter: parameters, header: headers){ (response) in
                SVProgressHUD.dismiss()
                switch response{
                case let .success(data):
                    self.serializeProductDataResponse(data: data)
                    completion(true)
                    print("hereee")
                    print(response)
                case .failure(_):
                    print("fail")
                    completion(false)
                }
            }
        }
        
        
    }
    
    func serializeProductDataResponse(data: Data) {
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            print("data in response :: \(json)")
            guard let productResponse: productData = Mapper<productData>().map(JSONObject: json) else {
                return
            }
            self.productDatasourceArray = [productResponse]
            
            
            //let imageObjects = productDatasourceArray[0].content?.imageObjects
            print("data array count :: \(productDatasourceArray.count)")
            
            
            
            let imageObjects = productDatasourceArray[0].content?.imageObjects
            
            
            print("image 01 :: \(imageObjects![0].id ?? "default")")
            tempImgArray.removeAll()
            
            if imageObjects!.count > 4 {
                
                for i in 0...3{
                    
                    //print("image \(i) id :: \(imageObjects![i].id)")
                    let imageID = imageObjects![i].id
                    let imageurl = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.PRODUCT_IMAGES_BY_ID + "\(imageID ?? "")") as String
                    tempImgArray.append(imageurl)
                    
                }
                
            } else {
                print("image cont :: \(Int(imageObjects!.count))")
                
                for index in (0...Int(imageObjects!.count) - 1) {
                    print("image \(index) id :: \(imageObjects![index].id ?? "")")
                    let imageID = imageObjects![index].id
                    let imageurl = NSString.init(format: "%@%@", UrlConstans.BASE_URL, UrlConstans.PRODUCT_IMAGES_BY_ID + "\(imageID ?? "")") as String
                    tempImgArray.append(imageurl)
                }
                
                
            }
            
            
            
            print("image url list newsd sd d fd df df d df :: \(tempImgArray)")
            
            productStruct.productObj.productTitle = (productResponse.content?.name)!
            productStruct.productObj.ProductDescription = (productResponse.content?.description)!
            productStruct.productObj.youtubeId = (productResponse.content?.videoUrl)!
            productStruct.productObj.ImagesList = (tempImgArray)
            
            
            
            
        }catch {
            print(error)
        }
    }
    
}


class  productStructforcommunity {
    
    
    struct productcollectionObj {
        static var productTitle = String()
        static var ProductDescription = String()
        static var ImagesList = [String]()
        static var youtubeId = String()
    }
    
    
}
