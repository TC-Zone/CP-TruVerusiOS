//
//  CPMapViewController.swift
//  Truverus
//
//  Created by User on 13/5/19.
//  Copyright © 2019 ClearPicture. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation


class CPMapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var Map: GMSMapView!
    @IBOutlet weak var Address: UILabel!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            switch (CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
                openSettingApp(message: "Please enable the location services to get your current location")
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                self.showCurrentLocation()
            @unknown default:
                print("fatal error")
            }
        } else {
            print("Location services are not enabled")
            openSettingApp(message: "Please enable the location services to get your current location")
        }
        
       
        
        
    }
    
    
    //open location settings for app
    func openSettingApp(message: String) {
        let alertController = UIAlertController (title: "Truverus", message:message , preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: NSLocalizedString("settings", comment: ""), style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func showCurrentLocation() {
        Map.settings.myLocationButton = true
        let locationObj = locationManager.location
        let coord = locationObj!.coordinate
        let lattitude = coord.latitude
        let longitude = coord.longitude
        
        print("latitude obj is \(lattitude)")
        print("longtitude obj is \(longitude)")
        
        print(" lat in  updating \(lattitude) ")
        print(" long in  updating \(longitude)")
        
        let center = CLLocationCoordinate2D(latitude: locationObj!.coordinate.latitude, longitude: locationObj!.coordinate.longitude)
        let marker = GMSMarker()
        marker.position = center
        marker.title = "current location"
        marker.map = Map
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: lattitude, longitude: longitude, zoom: Float(16.0))
        self.Map.animate(to: camera)
        
        getAdressName(coords: locationObj!)
        
    }
    

    func getAdressName(coords: CLLocation) {
        
        CLGeocoder().reverseGeocodeLocation(coords) { (placemark, error) in
            if error != nil {
                print("Hay un error")
            } else {
                
                let place = placemark! as [CLPlacemark]
                if place.count > 0 {
                    let place = placemark![0]
                    var adressString : String = ""
                    if place.thoroughfare != nil {
                        adressString = adressString + place.thoroughfare! + ", "
                    }
                    if place.subThoroughfare != nil {
                        adressString = adressString + place.subThoroughfare! + "\n"
                    }
                    if place.locality != nil {
                        adressString = adressString + place.locality! + " - "
                    }
                    if place.postalCode != nil {
                        adressString = adressString + place.postalCode! + "\n"
                    }
                    if place.subAdministrativeArea != nil {
                        adressString = adressString + place.subAdministrativeArea! + " - "
                    }
                    if place.country != nil {
                        adressString = adressString + place.country!
                    }
                    
                    self.Address.text = adressString
                }
            }
        }
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
