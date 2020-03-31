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
        startView.fill(with: .start(time: "11:45"))
        addArrangedSubview(startView)
        
        for segment in routeSuggestion.segments {
            let segmentView = RouteSegmentView.loadFromNib()
            segmentView.fill(with: .segment(segment: segment))
            addArrangedSubview(segmentView)
        }
        
        let endView = RouteSegmentView.loadFromNib()
        endView.fill(with: .end(time: "12:59"))
        addArrangedSubview(endView)
    }
    
}
