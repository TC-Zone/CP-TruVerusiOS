//
//  CPMyCollectionScreenViewController.swift
//  Truverus
//
//  Created by User on 8/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit

class CPMyCollectionScreenViewController: UIViewController {
    
    @IBOutlet weak var RequestsContainer: UIView!
    @IBOutlet weak var PendingContainer: UIView!
    @IBOutlet weak var collectionContainer: UIView!
    @IBOutlet weak var nocollectioncontainer: UIView!
    @IBOutlet weak var segmentControl: CPCustomSegmentedControll!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let x = appDelegate.state
        print("state is ::: \(x)")
        
        if (x == "logedin") {
            print("seteeee already")
            collectionContainer.alpha = 1
            nocollectioncontainer.alpha = 0
            PendingContainer.alpha = 0
            RequestsContainer.alpha = 0
            
            
        } else if (x == "logedout") {
            print("seteeee already")
            nocollectioncontainer.alpha = 1
            collectionContainer.alpha = 0
            PendingContainer.alpha = 0
            RequestsContainer.alpha = 0
            
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func SegmentControllValueChanged(_ sender: CPCustomSegmentedControll) {
        let x = appDelegate.state
        
        switch sender.selectedSegmentIndex {
        case 0:
            print("collection")
            print("state is ::: \(x)")
            
            if (x == "logedin") {
                print("seteeee already")
                collectionContainer.alpha = 1
                nocollectioncontainer.alpha = 0
                PendingContainer.alpha = 0
                RequestsContainer.alpha = 0
                
                
            } else if (x == "logedout") {
                print("seteeee already")
                nocollectioncontainer.alpha = 1
                collectionContainer.alpha = 0
                PendingContainer.alpha = 0
                RequestsContainer.alpha = 0
                
                
            }
            
        case 1:
            print("pending list")
            if (x == "logedin") {
                
                PendingContainer.alpha = 1
                nocollectioncontainer.alpha = 0
                collectionContainer.alpha = 0
                RequestsContainer.alpha = 0
                
                
            } else if (x == "logedout") {
                
                nocollectioncontainer.alpha = 1
                PendingContainer.alpha = 0
                collectionContainer.alpha = 0
                RequestsContainer.alpha = 0
                
                
            }
            
        case 2:
            print("Requests")
            print("pending list")
            if (x == "logedin") {
                
                RequestsContainer.alpha = 1
                PendingContainer.alpha = 0
                nocollectioncontainer.alpha = 0
                collectionContainer.alpha = 0
                
                
            } else if (x == "logedout") {
                
                nocollectioncontainer.alpha = 1
                PendingContainer.alpha = 0
                collectionContainer.alpha = 0
                RequestsContainer.alpha = 0
                
                
            }
            
        default:
            print("nothing in switch")
        }
    }
    
    
    func handleback() {
    
        nocollectioncontainer.alpha = 1
        collectionContainer.alpha = 0
        PendingContainer.alpha = 0
        RequestsContainer.alpha = 0
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
