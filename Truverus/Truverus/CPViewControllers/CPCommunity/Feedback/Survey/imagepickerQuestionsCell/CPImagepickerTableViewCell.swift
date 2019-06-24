//
//  CPImagepickerTableViewCell.swift
//  Truverus
//
//  Created by pasan vimukthi wijesuriya on 6/6/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit
import Kingfisher

class CPImagepickerTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var QuestionNumber: UILabel!
    @IBOutlet weak var Question: UILabel!
    @IBOutlet weak var imagecollectionview: UICollectionView!
    
    var imagelist = [""]
    var imagenamelist = [""]
    
    var qcodee : String!
    var qnumber : String!
    var multiselect : Bool!
    
    var selectedAnswerImages = [ImageAnswers]()
    
    var selectedIndexes : [String?] = [""]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imagecollectionview.delegate = self
        imagecollectionview.dataSource = self
        
        self.imagecollectionview.register(UINib(nibName: "CPSurvayQuestionImagesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "QuestionImageCell")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagelist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //QuestionImageCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionImageCell", for: indexPath) as! CPSurvayQuestionImagesCollectionViewCell
        
        var imgUrl : URL!
        
        if imagelist.count != 0 {
            print("in arrayyyyyy :: \(imagelist[indexPath.row])")
            imgUrl = URL(string: imagelist[indexPath.row])!
            
        } else {
            
            imgUrl = nil
        }
        
        cell.CellImage.kf.setImage(with: imgUrl)
        cell.Celltext.text = imagenamelist[indexPath.row]
        
        cell.contentView.layer.cornerRadius = 0.0
        cell.contentView.layer.borderWidth = 1.5
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.shadowColor = UIColor.clear.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 0.0
        cell.layer.shadowOpacity = 0.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: (cell.contentView.layer.cornerRadius)).cgPath
        cell.layer.backgroundColor = UIColor.clear.cgColor
        
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = ((imagecollectionview.frame.width) / 2) - 5
        let height = ((imagecollectionview.frame.height) / 2) - 5
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! CPSurvayQuestionImagesCollectionViewCell
        
        if multiselect == true {
            
            if cell.contentView.layer.cornerRadius == CGFloat(0.0) {
                
                selectedAnswerImages.append(ImageAnswers(number: "\(indexPath.row)", answer: "\(imagelist[indexPath.row])", qcode: qcodee, imageName: "\(imagenamelist[indexPath.row])"))
                
                
                cell.contentView.layer.cornerRadius = 6.0
                cell.contentView.layer.borderWidth = 0.5
                cell.contentView.layer.borderColor = UIColor.clear.cgColor
                cell.contentView.layer.masksToBounds = true
                
                cell.layer.shadowColor = UIColor.lightGray.cgColor
                cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
                cell.layer.shadowRadius = 6.0
                cell.layer.shadowOpacity = 1.0
                cell.layer.masksToBounds = false
                cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: (cell.contentView.layer.cornerRadius)).cgPath
                cell.layer.backgroundColor = UIColor.clear.cgColor
                
                
                
            } else {
                
                if selectedAnswerImages.isEmpty == false {
                    
                    let gotindex = selectedAnswerImages.firstIndex(where: { $0.number == "\(indexPath.row)" })!
                    
                    
                    
                    if gotindex >= 0 {
                        print("got data for index \(indexPath.row) :: \(selectedAnswerImages[gotindex])")
                        let results = selectedAnswerImages.filter {  $0.number == "\(indexPath.row)" }
                        print("occurences :: \(results.count)")
                        
                        
                        selectedAnswerImages.removeAll { (Answers) -> Bool in
                            Answers.number == "\(indexPath.row)"
                        }
                        
                        
                    } else {
                        
                        selectedAnswerImages.removeAll()
                        print("nil was there")
                    }
                }
                
                cell.contentView.layer.cornerRadius = 0.0
                cell.contentView.layer.borderWidth = 1.5
                cell.contentView.layer.borderColor = UIColor.clear.cgColor
                cell.contentView.layer.masksToBounds = true
                
                cell.layer.shadowColor = UIColor.clear.cgColor
                cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
                cell.layer.shadowRadius = 0.0
                cell.layer.shadowOpacity = 0.0
                cell.layer.masksToBounds = false
                cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: (cell.contentView.layer.cornerRadius)).cgPath
                cell.layer.backgroundColor = UIColor.clear.cgColor
                
            }
            
        } else {
            
            if cell.contentView.layer.cornerRadius == CGFloat(0.0) {
                
                selectedAnswerImages.append(ImageAnswers(number: "\(indexPath.row)", answer: "\(imagelist[indexPath.row])", qcode: qcodee, imageName: "\(imagenamelist[indexPath.row])"))
                
                selectedAnswerImages.removeAll { (Answers) -> Bool in
                    Answers.number != "\(indexPath.row)" && Answers.qcode == qcodee
                }
                
                for i in 0...((selectedAnswerImages.count) - 1) {
                    
                    print("current available answer :: \(selectedAnswerImages[i].number) && \(selectedAnswerImages[i].answer)")
                    
                }
                
                cell.contentView.layer.cornerRadius = 6.0
                cell.contentView.layer.borderWidth = 0.5
                cell.contentView.layer.borderColor = UIColor.clear.cgColor
                cell.contentView.layer.masksToBounds = true
                
                cell.layer.shadowColor = UIColor.lightGray.cgColor
                cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
                cell.layer.shadowRadius = 6.0
                cell.layer.shadowOpacity = 1.0
                cell.layer.masksToBounds = false
                cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: (cell.contentView.layer.cornerRadius)).cgPath
                cell.layer.backgroundColor = UIColor.clear.cgColor
                
                for cell in collectionView.visibleCells {
                    guard let visibleCell = cell as? CPSurvayQuestionImagesCollectionViewCell else { return }
                    let path = collectionView.indexPath(for: visibleCell)
                    if path?.row == indexPath.row {
                        
                    } else {
                        visibleCell.contentView.layer.cornerRadius = 0.0
                        visibleCell.contentView.layer.borderWidth = 1.5
                        visibleCell.contentView.layer.borderColor = UIColor.clear.cgColor
                        visibleCell.contentView.layer.masksToBounds = true
                        
                        visibleCell.layer.shadowColor = UIColor.clear.cgColor
                        visibleCell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
                        visibleCell.layer.shadowRadius = 0.0
                        visibleCell.layer.shadowOpacity = 0.0
                        visibleCell.layer.masksToBounds = false
                        visibleCell.layer.shadowPath = UIBezierPath(roundedRect: visibleCell.bounds, cornerRadius: (visibleCell.contentView.layer.cornerRadius)).cgPath
                        visibleCell.layer.backgroundColor = UIColor.clear.cgColor
                    }
                    
                }
                
                
                
            } else {
                
            }
            
            print("mult")
            
        }
        
    }
        
        
        
//                    visibleCell.contentView.layer.cornerRadius = 6.0
//                    visibleCell.contentView.layer.borderWidth = 1.0
//                    visibleCell.contentView.layer.borderColor = UIColor.clear.cgColor
//                    visibleCell.contentView.layer.masksToBounds = true
//
//                    visibleCell.layer.shadowColor = UIColor.lightGray.cgColor
//                    visibleCell.layer.shadowOffset = CGSize(width: 0, height: 0)
//                    visibleCell.layer.shadowRadius = 0.0
//                    visibleCell.layer.shadowOpacity = 0.0
//                    visibleCell.layer.masksToBounds = false
//                    visibleCell.layer.shadowPath = UIBezierPath(roundedRect: visibleCell.bounds, cornerRadius: (visibleCell.contentView.layer.cornerRadius)).cgPath
//                    visibleCell.layer.backgroundColor = UIColor.clear.cgColor
//
//
//
//
//
//                        visibleCell.contentView.layer.cornerRadius = 6.0
//                        visibleCell.contentView.layer.borderWidth = 1.0
//                        visibleCell.contentView.layer.borderColor = UIColor.clear.cgColor
//                        visibleCell.contentView.layer.masksToBounds = true
//
//                        visibleCell.layer.shadowColor = UIColor.lightGray.cgColor
//                        visibleCell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
//                        visibleCell.layer.shadowRadius = 6.0
//                        visibleCell.layer.shadowOpacity = 1.0
//                        visibleCell.layer.masksToBounds = false
//                        visibleCell.layer.shadowPath = UIBezierPath(roundedRect: visibleCell.bounds, cornerRadius: (visibleCell.contentView.layer.cornerRadius)).cgPath
//                        visibleCell.layer.backgroundColor = UIColor.clear.cgColor
        
    
    
}


class ImageAnswers {
    var number = String()
    var answer = String()
    var qcode = String()
    var imageName = String()
    
    init(number:String, answer:String, qcode:String, imageName:String){
        self.number = number
        self.answer = answer
        self.qcode = qcode
        self.imageName = imageName
    }
}
