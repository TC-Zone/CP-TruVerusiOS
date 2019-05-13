//
//  CPMapViewController.swift
//  Truverus
//
//  Created by User on 13/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit
import GoogleMaps


class CPMapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var Map: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let camera = GMSCameraPosition.camera(withLatitude: 37.36, longitude: -122.0, zoom: 6.0)
        Map.camera = camera
        showMarker(position: camera.target)
    }
    
   
    func showMarker(position: CLLocationCoordinate2D){
        let marker = GMSMarker()
        marker.position = position
        marker.title = "Palo Alto"
        marker.snippet = "San Francisco"
        marker.map = Map
    }

        // Do any additional setup after loading the view.
    
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
