//
//  XLocation.swift
//  shoppingg
//
//  Created by Botan Amedi on 7/22/20.
//  Copyright © 2020 com.saucepanStory. All rights reserved.
//

import CoreLocation

class XLocations : NSObject , CLLocationManagerDelegate{
    
    static var Shared = XLocations()
    
    var LocationManager : CLLocationManager!
    
    func GetUserLocation(){
        
        LocationManager = CLLocationManager()
        
        LocationManager.delegate = self
        
        LocationManager.requestWhenInUseAuthorization()
        
        LocationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        if CLLocationManager.locationServicesEnabled(){
            LocationManager.startUpdatingLocation()
        }
        
        

    }
    
    var longtude : Double = 0
    var latitude : Double = 0
    var GotLocation : (()->())?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.longtude = locations[0].coordinate.longitude
        self.latitude = locations[0].coordinate.latitude
        
        GotLocation?()
        
    }
    
}

