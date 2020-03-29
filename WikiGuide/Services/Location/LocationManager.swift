//
//  LocationManager.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 28.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import Foundation
import CoreLocation

/**
 LocationService implementation.
 */
public class LocationManager: NSObject {
    
    public var authorizationStatus: LocationAuthorizationStatus {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            return .authorized
        case .denied, .restricted:
            return .denied
        default:
            return .notDetermined
        }
    }
    
    private let clLocationManager: CLLocationManager        
    private var observers = ObserverContainer<LocationServiceObserver>()
    
    public override init() {
        clLocationManager = CLLocationManager()        
        super.init()
        clLocationManager.delegate = self
    }

}

// MARK: - LocationService
extension LocationManager: LocationService {

    public func add(observer: LocationServiceObserver) {
        observers.add(observer)
    }
    
    public func remove(observer: LocationServiceObserver) {
        observers.remove(observer)
    }
    
    public func requestWhenInUseAuthorization() {
        clLocationManager.requestWhenInUseAuthorization()
    }
    
    public func requestLocation() {
        clLocationManager.requestLocation()
    }
    
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        observers.enumerateObservers { (observer) in
            observer.locationService(self, didChangeAuthorization: authorizationStatus)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        observers.enumerateObservers { (observer) in
            observer.locationService(self, didUpdateLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        observers.enumerateObservers { (observer) in
            observer.locationService(self, didFailWithError: error)
        }
    }
    
}

