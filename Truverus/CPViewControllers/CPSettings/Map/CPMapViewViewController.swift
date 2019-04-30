//
//  CPMapViewViewController.swift
//  Truverus
//
//  Created by User on 25/4/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class CPMapViewViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var MapView: GMSMapView!
    @IBOutlet weak var Mapview: UIView!
    @IBOutlet weak var AddressLabel: UILabel!
    
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        
        if CLLocationManager.locationServicesEnabled() {
            switch (CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            }
        } else {
            print("Location services are not enabled")
        }
        
        self.showCurrentLocation()
        
        // Do any additional setup after loading the view.
    }
    
    
    func showCurrentLocation() {
        MapView.settings.myLocationButton = true
        let locationObj = locationManager.location
        let coord = locationObj?.coordinate
        let lattitude = coord?.latitude
        let longitude = coord?.longitude
        print(" lat in  updating \(String(describing: lattitude)) ")
        print(" long in  updating \(String(describing: longitude))")
        
        let center = CLLocationCoordinate2D(latitude: (locationObj?.coordinate.latitude)!, longitude: locationObj!.coordinate.longitude)
        let marker = GMSMarker()
        marker.position = center
        marker.title = "current location"
        marker.map = MapView
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: lattitude!, longitude: longitude!, zoom: Float(16.0))
        self.MapView.animate(to: camera)
        
        latLong(lat: lattitude!, long: longitude!)
        
        
    }
    
    
    func latLong(lat: Double,long: Double)  {
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat , longitude: long)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            print("Response GeoLocation : \(String(describing: placemarks))")
            
            
            if (error) == nil {
                
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                
                let address = "\(placeMark.thoroughfare ?? "") \(placeMark.locality ?? "") \(placeMark.subLocality ?? "") \(placeMark.administrativeArea ?? "") \(placeMark.postalCode ?? "") \(placeMark.country ?? "")"
                print("addresss issss ::: \(address)")
                
                self.AddressLabel.text = address
                
                
            }
            
//            // Country
//            if let country = placeMark.addressDictionary!["Country"] as? String {
//                print("Country :- \(country)")
//                // City
//                if let city = placeMark.addressDictionary!["City"] as? String {
//                    print("City :- \(city)")
//                    // State
//                    if let state = placeMark.addressDictionary!["State"] as? String{
//                        print("State :- \(state)")
//                        // Street
//                        if let street = placeMark.addressDictionary!["Street"] as? String{
//                            print("Street :- \(street)")
//                            let str = street
//                            let streetNumber = str.components(
//                                separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
//                            print("streetNumber :- \(streetNumber)" as Any)
//
//                            // ZIP
//                            if let zip = placeMark.addressDictionary!["ZIP"] as? String{
//                                print("ZIP :- \(zip)")
//                                // Location name
//                                if let locationName = placeMark?.addressDictionary?["Name"] as? String {
//                                    print("Location Name :- \(locationName)")
//                                    // Street address
//                                    if let thoroughfare = placeMark?.addressDictionary!["Thoroughfare"] as? NSString {
//                                        print("Thoroughfare :- \(thoroughfare)")
//
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        let camera = GMSCameraPosition.camera(withLatitude: 28.7041, longitude: 77.1025, zoom: 10.0)
//        let width = UIScreen.main.bounds.width
//        let height = Mapview.frame.height
//        print("height ::::: \(height)")
//        let frame = CGRect(x: 0, y: 0, width: width, height: height)
//        let mapView = GMSMapView.map(withFrame: frame, camera: camera)
//        self.Mapview.addSubview(mapView)
//
//
//        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: 28.7041, longitude: 77.1025)
//        marker.title = "Delhi"
//        marker.snippet = "India’s capital"
//        marker.map = mapView
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
        
        self.showCurrentLocation()
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
