//
//  ThirdViewController.swift
//  PlayingWithTabs
//
//  Created by Nathaniel Mcdowell on 8/21/19.
//  Copyright © 2019 Nathaniel Mcdowell. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ThirdViewController: UIViewController {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionInMeters:Double = 1000
    var previousLocation:CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
   
    }
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorization()
            // setup location manager
            
        }else{
            //Show alert letting user know to turn global location services on.
        }
    }
    
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startTrackingUserLocation()
        case .denied:
            //give instructions to re-enable permissions for this app in Settings
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
            //show alert letting them know what's up (parental controls, organization rules, etc.)
        case .authorizedAlways:
            break
        }
    }
    
    
    func startTrackingUserLocation(){
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
    }
    

    func getCenterLocation(for mapView: MKMapView)->CLLocation {
    
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
    }

}

extension ThirdViewController: CLLocationManagerDelegate {
func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    // fires off everything when you do chose Allow etc, the first time especially
    checkLocationAuthorization()
}




    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("location updated")
        guard let location = locations.last else {return}
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        previousLocation = location //added this to enable moving the "location" of the sim iPhone
        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
}



extension ThirdViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("triggered")
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
       guard let previousLocation = self.previousLocation else {return}
      
        guard center.distance(from: previousLocation) > 50 else {return}
        self.previousLocation = center
        
       
        geoCoder.reverseGeocodeLocation(center, completionHandler: {[weak self] (placemarks, error) in
            guard let self = self else {return}
            
            if let _ = error {
                //TODO: Show alter informing the user
                return
            }
            
            guard let placemark = placemarks?.first else {
            //TODO: Show alert to user
                return
            }
            ///////////////made it, now do stuff///////////////
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            
            DispatchQueue.main.async {
                self.addressLabel.text = "\(streetNumber) \(streetName)"
            }
            
            })
        
    }
}
