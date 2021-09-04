//
//  FGLocationManager.swift
//  Fringe
//
//  Created by MyMac on 9/4/21.
//

import UIKit
import CoreLocation

/// Handles location related events
@objc protocol FGLocationManagerDelegate {
    
    /// <#Description#>
    /// - Parameters:
    ///   - manager: <#manager description#>
    ///   - locations: <#locations description#>
    @objc optional func locationManager(_ manager: FGLocationManager, didUpdateLocations locations: [CLLocation])
    
    /// <#Description#>
    /// - Parameters:
    ///   - manager: <#manager description#>
    ///   - error: <#error description#>
    @objc optional func locationManager(_ manager: FGLocationManager, didFailWithError error: Error)
    
    /// <#Description#>
    /// - Parameters:
    ///   - manager: <#manager description#>
    ///   - status: <#status description#>
    @objc optional func locationManager(_ manager: FGLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
}

/**
 A subclass of NSObject that confirms to CLLocationManagerDelegate
 
 ## Important Notes ##
 1. Intended to be used as `CLLocationManager`
 */

internal class FGLocationManager: NSObject, CLLocationManagerDelegate {
    
    /// <#Description#>
    public var delegate : FGLocationManagerDelegate?
    
    /// <#Description#>
    private var locationManager = CLLocationManager()
    
    /// <#Description#>
    public var location: CLLocationCoordinate2D?
    
    public var lat : Double?{
        get {
            return UserDefaults.standard.double(forKey: "latt")
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: "latt")
        }
    }
    
    public var long : Double? {
        
        get {
            return UserDefaults.standard.double(forKey: "longg")
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: "longg")
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Shared
    
    static var shared = FGLocationManager()
    
    //------------------------------------------------------
    
    //MARK: Public
    
    func isRequiredToShowPermissionDialogue() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                return true
            case .authorizedAlways, .authorizedWhenInUse:
                return false
            case .restricted:
                return false
            case .denied:
                return false
            @unknown default:
                break
            }
        }
        return false
    }
    
    func isLocationServicesEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            @unknown default:
                break
            }
        } else {
            return false
        }
        return false
    }
    
    func requestForLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func startMonitoring() {
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        if #available(iOS 14.0, *) {
            switch locationManager.authorizationStatus {
            case .notDetermined:
                print("1")
            case .restricted:
                print("2")
                
            case .denied:
                print("3")
                
            case .authorizedAlways:
                print("4")
                
            case .authorizedWhenInUse:
                print("5")
                
            @unknown default:
                print("6")
                
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func stopMonitoring() {
        locationManager.stopUpdatingLocation()
    }
    
    //------------------------------------------------------
    
    //MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        delegate?.locationManager?(self, didChangeAuthorization: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last?.coordinate
        PreferenceManager.shared.lat = locations.last?.coordinate.latitude
        PreferenceManager.shared.long = locations.last?.coordinate.longitude
        //        manager.stopUpdatingLocation()
        print("locationData")
        lat = locations.last?.coordinate.latitude ?? 0.0
        long = locations.last?.coordinate.longitude ?? 0.0
        delegate?.locationManager?(self, didUpdateLocations: locations)
        //        AppDelegate.shared.performUpdateLocation(lat: "\(locations.last?.coordinate.latitude ?? .zero)", long:  "\(locations.last?.coordinate.longitude ?? .zero)") { (flag : Bool) in
        //            print("locationupdatedsuccessfully",flag)
        
        
        //        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        location = nil
        delegate?.locationManager?(self, didFailWithError: error)
    }
    
    //------------------------------------------------------
    
    //MARK: Init
    
    override init() {
        super.init()
        
        locationManager.delegate = self
    }
    
    //------------------------------------------------------
}
