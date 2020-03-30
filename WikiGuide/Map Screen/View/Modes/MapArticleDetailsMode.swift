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

    let detailsView = WikiArticleDetailsView.loadFromNib()

    init(mapVC: MapVC, mapView: MKMapView, mapViewModel: MapViewModeling) {
        self.mapVC = mapVC
        self.mapView = mapView
        self.mapViewModel = mapViewModel
    }

    func performTransition(from oldMode: MapMode?, animated: Bool) {
        mapView.delegate = self

        switch oldMode {
        case is MapMainMode:            
            guard let selectedAnnotation = context.selectedAnnotation else { return }
            
            let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
            let region = MKCoordinateRegion(center: selectedAnnotation.coordinate, span: span)
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: mapVC.view.bounds.height * (2/3) - 50, right: 0)
            
            mapView.setVisibleMapRect(region.convertToMapRect(), edgePadding: insets, animated: true)

            mapVC.view.addSubviewAndStretchToFill(detailsView)
            mapVC.view.layoutIfNeeded()
            
            detailsView.show()
            detailsView.didTapOverlay = { [weak self] in
                self?.mapVC.setState(.main)
            }
            
            mapViewModel.fetchWikiArticleDetails(by: selectedAnnotation.article.pageId) { [weak self] (result) in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let details):
                    strongSelf.detailsView.fill(with: details)
                    strongSelf.mapViewModel.fetchImages(for: details) { (images) in
                        strongSelf.detailsView.images = images
                    }
                case .failure(let error):
                    strongSelf.mapVC.showError(error)
                }
                print(result)
            }
        default:
            preconditionFailure("Unknown MapMode transition")
        }
    }
    
}

extension MapArticleDetailsMode: MKMapViewDelegate {
    
}
