//
//  LocationService.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 28.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import Foundation

public enum LocationAuthorizationStatus {
    case authorized
    case denied
    case notDetermined
}

/**
 This service is a `CLLocationManager` wrapper.
 For more information see [CLLocationManager](https://developer.apple.com/documentation/corelocation/cllocationmanager) documentation.
 */
public protocol LocationService {
    
    /// Location authorization status. 
    var authorizationStatus: LocationAuthorizationStatus { get }
    
    /// Adds observer to the observer container. Use this method to subscribe to notifications.
    func add(observer: LocationServiceObserver)
    /// Removes observer from the observer container. Use this method to unsubscribe from notifications.
    /// - Important: Don't forget to remove observer before its deinit.
    func remove(observer: LocationServiceObserver)
    
    /// Requests the user’s permission to use location services while the app is in use.
    func requestWhenInUseAuthorization()
    /// Requests the one-time delivery of the user’s current location.
    func requestLocation()
}
