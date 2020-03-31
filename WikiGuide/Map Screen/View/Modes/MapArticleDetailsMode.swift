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

    private let detailsView = WikiArticleDetailsView.loadFromNib()

    init(mapVC: MapVC, mapView: MKMapView, mapViewModel: MapViewModeling) {
        self.mapVC = mapVC
        self.mapView = mapView
        self.mapViewModel = mapViewModel
    }

    func performTransition(from oldMode: MapMode?, animated: Bool) {
        mapView.delegate = nil

        switch oldMode {
        case is MapMainMode:            
            guard let selectedAnnotation = context.selectedAnnotation else { return }
            
            updateVisibleMapRect(with: selectedAnnotation.coordinate)
            addDetailsView(with: selectedAnnotation.article)
            detailsView.show()

        case let oldMode as MapNavigationMode:
            guard let selectedAnnotation = context.selectedAnnotation else { return }
            
            let annotationsToAdd = context.annotations.filter({ $0 != context.selectedAnnotation })
            mapView.addAnnotations(annotationsToAdd)
            mapView.removeOverlays(mapView.overlays)

            oldMode.hideAndRemoveCloseButton()
            
            updateVisibleMapRect(with: selectedAnnotation.coordinate)
            addDetailsView(with: selectedAnnotation.article)
            detailsView.show()

        default:
            preconditionFailure("Unknown MapMode transition")
        }
    }
    
    func hideAndRemoveDetailsView() {
        detailsView.hide {
            self.detailsView.removeFromSuperview()
        }
    }

    private func addDetailsView(with article: WikiArticle) {
        mapVC.view.addSubviewAndStretchToFill(detailsView)
        mapVC.view.layoutIfNeeded()

        detailsView.didTapOverlay = { [weak self] in
            self?.context.articleDetails = nil
            self?.context.articleImages = []
            self?.mapVC.setState(.main)
        }
        detailsView.didTapOpenInWiki = { [weak self] in
            self?.mapViewModel.openWikiArticleInSafari(article)
        }
        detailsView.didTapGetThere = { [weak self] in
            self?.mapVC.setState(.navigation)
        }
        
        if let articleDetails = context.articleDetails {
            detailsView.fill(with: articleDetails)
            detailsView.images = context.articleImages
            detailsView.layoutIfNeeded()
            return
        } 
        
        mapViewModel.fetchWikiArticleDetails(by: article.pageId) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let details):
                strongSelf.context.articleDetails = details
                strongSelf.detailsView.fill(with: details)
                strongSelf.mapViewModel.fetchImages(for: details) { (images) in
                    strongSelf.context.articleImages = images
                    strongSelf.detailsView.images = images
                }
            case .failure(let error):
                strongSelf.mapVC.showError(error)
            }
        }
    }
    
    private func updateVisibleMapRect(with center: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        let region = MKCoordinateRegion(center: center, span: span)
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: mapVC.view.bounds.height * (2/3) - 50, right: 0)
        
        mapView.setVisibleMapRect(region.convertToMapRect(), edgePadding: insets, animated: true)
    }
}
