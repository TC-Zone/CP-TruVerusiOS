//
//  CPMapViewViewController.swift
//  Truverus
//
//  Created by User on 25/4/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit
import GoogleMaps

class CPMapViewViewController: UIViewController {

    @IBOutlet weak var Mapview: UIView!
    @IBOutlet weak var AddressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let camera = GMSCameraPosition.camera(withLatitude: 28.7041, longitude: 77.1025, zoom: 10.0)
        let width = UIScreen.main.bounds.width
        let height = Mapview.frame.height
        print("height ::::: \(height)")
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        let mapView = GMSMapView.map(withFrame: frame, camera: camera)
        self.Mapview.addSubview(mapView)
        
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 28.7041, longitude: 77.1025)
        marker.title = "Delhi"
        marker.snippet = "India’s capital"
        marker.map = mapView
    }
//    override func loadView() {
//        // Create a GMSCameraPosition that tells the map to display the
//        // coordinate -33.86,151.20 at zoom level 6.
//        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
//        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//        self.Mapview = mapView
//
//        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = mapView
//    }
    
    @IBAction func SetLocationAction(_ sender: Any) {
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
