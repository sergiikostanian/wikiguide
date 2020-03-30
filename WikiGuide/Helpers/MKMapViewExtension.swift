//
//  MKMapViewExtension.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 30.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import MapKit

extension MKCoordinateRegion {
    
    /// Converts a map region to a map rect.
    func convertToMapRect() -> MKMapRect {

        let topLeftPointLat = center.latitude + (span.latitudeDelta/2)
        let topLeftPointLon = center.longitude - (span.longitudeDelta/2)
        let topLeftPoint = MKMapPoint(CLLocationCoordinate2D(latitude: topLeftPointLat, longitude: topLeftPointLon))
        
        let bottomRightPointLat = center.latitude - (span.latitudeDelta/2)
        let bottomRightPointLon = center.longitude + (span.longitudeDelta/2)
        let bottomRightPoint = MKMapPoint(CLLocationCoordinate2D(latitude: bottomRightPointLat, longitude: bottomRightPointLon))

        return MKMapRect(x: min(topLeftPoint.x, bottomRightPoint.x), 
                         y: min(topLeftPoint.y, bottomRightPoint.y), 
                         width: abs(topLeftPoint.x - bottomRightPoint.x), 
                         height: abs(topLeftPoint.y - bottomRightPoint.y))
    }
}
