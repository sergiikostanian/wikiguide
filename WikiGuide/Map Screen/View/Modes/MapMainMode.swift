//
//  MapMainMode.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 30.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import Foundation
import MapKit

final class MapMainMode: NSObject, MapMode {

    var context = MapModeContext()
    
    private weak var mapVC: MapVC!
    private weak var mapView: MKMapView!
    private var mapViewModel: MapViewModeling
    
    init(mapVC: MapVC, mapView: MKMapView, mapViewModel: MapViewModeling) {
        self.mapVC = mapVC
        self.mapView = mapView
        self.mapViewModel = mapViewModel
    }

    func performTransition(from oldMode: MapMode?, animated: Bool) {
        mapView.delegate = self

        switch oldMode {
        case nil:
            showNearbyArticles()
            
        case let oldMode as MapArticleDetailsMode:
            guard let selectedAnnotation = context.selectedAnnotation else { return }
            guard let mapRect = context.originalMapRect else { return }
            
            mapView.deselectAnnotation(selectedAnnotation, animated: true)
            mapView.setVisibleMapRect(mapRect, animated: true)
            
            context.selectedAnnotation = nil
            context.originalMapRect = nil

            oldMode.hideAndRemoveDetailsView()
            
        default:
            preconditionFailure("Unknown MapMode transition")
        }
    }
    
    private func showNearbyArticles() {
        // Fetch user location.
        mapViewModel.fetchUserLocation { [weak self] (result) in
            guard let strongSelf = self else { return }

            switch result {
            case .success(let location):
                strongSelf.mapView.setCenter(strongSelf.mapView.userLocation.coordinate, animated: true)
                strongSelf.context.userLocation = location
                
                // Fetch and display nearby wiki articles. 
                strongSelf.mapViewModel.fetchWikiArticles(for: location, completion: { (result) in
                    switch result {
                    case .success(let articles):
                        let annotations = articles.map({ WikiArticleAnnotation(article: $0) })
                        strongSelf.context.annotations = annotations
                        strongSelf.addArticlesAnnotations(annotations)
                    case .failure(let error):
                        strongSelf.mapVC.showError(error)
                    }
                })
            case .failure(let error):
                strongSelf.mapVC.showError(error)
            }
        }
    }
    
    private func addArticlesAnnotations(_ annotations: [WikiArticleAnnotation]) {
        let oldArticlesAnnotations = mapView.annotations.filter({ $0 is WikiArticleAnnotation })
        mapView.removeAnnotations(oldArticlesAnnotations)
        mapView.showAnnotations(annotations, animated: true)
    }

}

// MARK: - MKMapViewDelegate
extension MapMainMode: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let wikiArticleAnnotation = view.annotation as? WikiArticleAnnotation else { return }
        
        context.selectedAnnotation = wikiArticleAnnotation
        context.originalMapRect = mapView.visibleMapRect
        
        mapVC.setState(.articleDetails)
    }
}
