//
//  UserLocationServiceObserver.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 28.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import Foundation

/**
This protocol defines methods that you can use to receive events from an associated `LocationService`.
 */
public protocol LocationServiceObserver: AnyObject {
    
    /// Tells the observer that new location data is available.
    func locationService(_ locationService: LocationService, didUpdateLatitude latitude: Double, longitude: Double)
    /// Tells the observer its authorization status when the authorization status changes.
    func locationService(_ locationService: LocationService, didChangeAuthorization status: LocationAuthorizationStatus)
    /// Tells the observer that the location service was unable to retrieve a location value.
    func locationService(_ locationService: LocationService, didFailWithError error: Error)
}
