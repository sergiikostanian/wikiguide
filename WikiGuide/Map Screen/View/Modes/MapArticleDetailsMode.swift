//
//  MapArticleDetailsMode.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 30.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import Foundation
import MapKit

final class MapArticleDetailsMode: NSObject, MapMode {
    
    var context = MapModeContext()

    private weak var mapVC: MapVC!
    private weak var mapView: MKMapView!
    private var mapViewModel: MapViewModeling

    let detailsView = WikiArticleDetailsView()

    init(mapVC: MapVC, mapView: MKMapView, mapViewModel: MapViewModeling) {
        self.mapVC = mapVC
        self.mapView = mapView
        self.mapViewModel = mapViewModel
    }

    func performTransition(from oldMode: MapMode?, animated: Bool) {
        mapView.delegate = self

        switch oldMode {
        case is MapMainMode:            
            guard let center = context.selectedAnnotation?.coordinate else { return }
            
            let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
            let region = MKCoordinateRegion(center: center, span: span)
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: mapVC.view.bounds.height * (2/3) - 50, right: 0)
            
            mapView.setVisibleMapRect(region.convertToMapRect(), edgePadding: insets, animated: true)

            mapVC.view.addSubviewAndStretchToFill(detailsView)
            mapVC.view.layoutIfNeeded()
            
            detailsView.show()
            detailsView.didTapOverlay = { [weak self] in
                self?.mapVC.setState(.main)
            }
            
        default:
            preconditionFailure("Unknown MapMode transition")
        }
    }
    
}

extension MapArticleDetailsMode: MKMapViewDelegate {
    
}
