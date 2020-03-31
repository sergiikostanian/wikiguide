//
//  RouteView.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 31.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import UIKit

final class RouteView: UIStackView {
    
    func fill(with routeSuggestion: RouteSuggestion) {
        arrangedSubviews.forEach({ $0.removeFromSuperview() })
        
        let startView = RouteSegmentView.loadFromNib()
        startView.fill(with: .start)
        addArrangedSubview(startView)
        
        for segment in routeSuggestion.segments {
            let segmentView = RouteSegmentView.loadFromNib()
            segmentView.fill(with: .segment(segment: segment))
            addArrangedSubview(segmentView)
        }
        
        if let lastSegment = routeSuggestion.segments.last {
            let endView = RouteSegmentView.loadFromNib()
            endView.fill(with: .end(time: lastSegment.endTime))
            addArrangedSubview(endView)
        }
    }
    
}
