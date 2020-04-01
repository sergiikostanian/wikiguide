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

    var detailsView = WikiArticleDetailsView.loadFromNib()
    
    private weak var mapVC: MapVC!
    private weak var mapView: MKMapView!
    private var mapViewModel: MapViewModeling

    private let closeButton = UIButton(frame: .zero)
    private var closeButtonHidingConstraint: NSLayoutConstraint?

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
            setupDetailsViewEventHandlers()
            detailsView.show()

        case let oldMode as MapNavigationMode:
            guard let selectedAnnotation = context.selectedAnnotation else { return }
            
            let annotationsToAdd = context.annotations.filter({ $0 != context.selectedAnnotation })
            mapView.addAnnotations(annotationsToAdd)
            mapView.removeOverlays(mapView.overlays)

            detailsView = oldMode.detailsView
            detailsView.hide { [weak self] in 
                self?.detailsView.mode = .allDetails
                self?.detailsView.show()
            }

            oldMode.hideAndRemoveCloseButton()
            
            updateVisibleMapRect(with: selectedAnnotation.coordinate)
            setupDetailsViewEventHandlers()

        default:
            preconditionFailure("Unknown MapMode transition")
        }
        
        addCloseButton(to: mapVC.view)
        showCloseButton()
    }
    
    // MARK: - DetailsView Helpers
    private func addDetailsView(with article: WikiArticle) {
        mapVC.view.addSubviewAndStretchToFill(detailsView)
        mapVC.view.layoutIfNeeded()
        
        if let articleDetails = context.articleDetails,
            let routeSuggestion = context.routeSuggestion {
            detailsView.fill(with: articleDetails)
            detailsView.routeSuggestion = routeSuggestion
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
        
        guard let userLocation = context.userLocation else { return }
        guard let selectedAnnotation = context.selectedAnnotation else { return }
        
        mapViewModel.fetchRouteSuggestion(from: userLocation, to: (latitude: selectedAnnotation.coordinate.latitude, longitude: selectedAnnotation.coordinate.longitude)) { [weak self] result in
            guard let value = try? result.get() else { return }
            self?.detailsView.routeSuggestion = value
            self?.context.routeSuggestion = value
        }
    }
    
    private func setupDetailsViewEventHandlers() {
        detailsView.didTapOpenInWiki = { [weak self] in
            guard let article = self?.context.selectedAnnotation?.article else { return }
            self?.mapViewModel.openWikiArticleInSafari(article)
        }
        detailsView.didTapGetThere = { [weak self] in
            self?.mapVC.setState(.navigation)
        }
    }
    
    // MARK: - Close Button Helpers
    func hideAndRemoveCloseButton() {
        closeButtonHidingConstraint?.isActive = true
        UIView.animate(withDuration: 0.3, animations: { 
            self.closeButton.superview?.layoutIfNeeded()
        }) { _ in
            self.closeButton.removeFromSuperview()
        }
    }
    
    private func showCloseButton() {
        closeButtonHidingConstraint?.isActive = false
        UIView.animate(withDuration: 0.3) { 
            self.closeButton.superview?.layoutIfNeeded()
        }
    }

    private func addCloseButton(to rootView: UIView) {
        closeButton.setImage(UIImage(named: "CloseButtonIcon"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        rootView.addSubview(closeButton)
        closeButton.leadingAnchor.constraint(equalTo: rootView.leadingAnchor, constant: 16).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 56).isActive = true
        
        let topAnchor = closeButton.topAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.topAnchor, constant: 16)
        topAnchor.priority = .defaultHigh
        topAnchor.isActive = true
        
        closeButtonHidingConstraint = rootView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 16)
        closeButtonHidingConstraint?.isActive = true
        
        rootView.layoutIfNeeded()
    }
    
    @objc private func closeButtonTapped() {
        context.articleDetails = nil
        context.routeSuggestion = nil
        context.articleImages = []
        mapVC.setState(.main)
    }

    // MARK: - Map Helpers 
    private func updateVisibleMapRect(with center: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        let region = MKCoordinateRegion(center: center, span: span)
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: mapVC.view.bounds.height * (2/3) - 50, right: 0)
        
        mapView.setVisibleMapRect(region.convertToMapRect(), edgePadding: insets, animated: true)
    }
}
