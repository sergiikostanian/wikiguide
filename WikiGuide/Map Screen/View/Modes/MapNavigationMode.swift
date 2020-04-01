//
//  MapNavigationMode.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 30.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import Foundation
import MapKit

final class MapNavigationMode: NSObject, MapMode {
    
    var context = MapModeContext()
    
    var detailsView: WikiArticleDetailsView!
    
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
        mapView.delegate = self

        switch oldMode {
        case let oldMode as MapArticleDetailsMode:
            guard let userLocation = context.userLocation else { return }
            guard let selectedCoordinate = context.selectedAnnotation?.coordinate else { return }
            
            detailsView = oldMode.detailsView
            detailsView.hide { [weak self] in 
                self?.detailsView.mode = .routeSuggestionOnly
                self?.detailsView.show()
            }
            
            oldMode.hideAndRemoveCloseButton()

            let userCoordinate = CLLocationCoordinate2D(latitude: userLocation.latitude, longitude: userLocation.longitude)
            addRoute(from: userCoordinate, to: selectedCoordinate)
            
            addCloseButton(to: mapVC.view)
            showCloseButton()
            
            let annotationsToRemove = context.annotations.filter({ $0 != context.selectedAnnotation })
            mapView.removeAnnotations(annotationsToRemove)
            
        default:
            preconditionFailure("Unknown MapMode transition")
        }
    }
    
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
        closeButton.setImage(UIImage(named: "BackButtonIcon"), for: .normal)
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
        mapVC.setState(.articleDetails)
    }
    
    private func addRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: source))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .walking

        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let route = response?.routes.first else { return }
            
            var insets = self.mapVC.view.safeAreaInsets
            insets.bottom += 100
            insets.top += 50
            insets.left += 50
            insets.right += 50

            self.mapView.addOverlay(route.polyline)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: insets, animated: true)
        }
    }
}

// MARK: - MKMapViewDelegate
extension MapNavigationMode: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = #colorLiteral(red: 0, green: 0.5066667199, blue: 1, alpha: 1)
        renderer.alpha = 0.9
        renderer.lineWidth = 5
        renderer.lineCap = .round
        renderer.lineDashPattern = [6, 6]
        return renderer
    }
}
