//
//  RouteSegmentView.swift
//  WikiGuide
//
//  Created by Serhii Kostanian on 31.03.2020.
//  Copyright © 2020 Serhii Kostanian. All rights reserved.
//

import UIKit

final class RouteSegmentView: UIView {
    
    enum Mode {
        case start(time: String)
        case segment(segment: RouteSuggestion.Segment)
        case end(time: String)
        
        var circleColor: UIColor {
            switch self {
            case .start:
                return #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            case .segment:
                return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            case .end:
                return #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            }
        }
    }
    
    @IBOutlet private weak var circleView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailsLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func fill(with mode: Mode) {
        circleView.backgroundColor = mode.circleColor

        switch mode {
        case .start(let time):
            circleView.layer.borderWidth = 0
            titleLabel.text = "Your Location"
            detailsLabel.isHidden = true
            timeLabel.text = time
            
        case .segment(let value):
            circleView.layer.borderWidth = 2
            detailsLabel.isHidden = value.details == nil
            detailsLabel.text = value.details
            timeLabel.text = "12:55"
            
            var distanceString = ""
            if value.distance >= 1000 {
                distanceString += "\(Int(value.distance / 1000)) km"
            }
            let meters = value.distance.truncatingRemainder(dividingBy: 1000)
            if meters > 0 {
                distanceString += "\(Int(meters)) m"
            }
            titleLabel.text = "\(value.mode.title) - \(Int(value.duration / 60)) min (\(distanceString))"
            
        case .end(let time):
            circleView.layer.borderWidth = 0
            titleLabel.text = "Your Destination"
            detailsLabel.isHidden = true
            timeLabel.text = time
        }
    }
    
    private func setup() {
        circleView.layer.cornerRadius = circleView.bounds.height / 2
        circleView.layer.borderColor = UIColor.white.cgColor
        circleView.clipsToBounds = true
    }
}
