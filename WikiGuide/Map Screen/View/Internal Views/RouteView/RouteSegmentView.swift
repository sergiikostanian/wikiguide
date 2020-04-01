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
        case start
        case segment(segment: RouteSuggestion.Segment)
        case end(time: TimeInterval)
        
        var circleColor: UIColor {
            switch self {
            case .start:
                return #colorLiteral(red: 0, green: 0.4189725816, blue: 1, alpha: 1)
            case .segment:
                return #colorLiteral(red: 0.8500000238, green: 0.8500000238, blue: 0.8500000238, alpha: 1)
            case .end:
                return #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
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
        case .start:
            circleView.layer.borderWidth = 0
            titleLabel.text = "Your Location"
            detailsLabel.isHidden = true
            timeLabel.isHidden = true
            
        case .segment(let value):
            circleView.layer.borderWidth = 2
            detailsLabel.isHidden = value.details == nil
            detailsLabel.text = value.details
            timeLabel.text = Formatter.timeFormatter.string(from: Date(timeIntervalSince1970: value.startTime/1000))
            
            var distanceString = ""
            if value.distance >= 1000 {
                distanceString = "\(String(format: "%.2f", value.distance / 1000)) km"
            } else {
                distanceString = "\(Int(value.distance)) m"
            }
            titleLabel.text = "\(value.mode.title) - \(Int(value.duration / 60)) min (\(distanceString))"
            
        case .end(let time):
            circleView.layer.borderWidth = 0
            titleLabel.text = "Your Destination"
            detailsLabel.isHidden = true
            timeLabel.text = Formatter.timeFormatter.string(from: Date(timeIntervalSince1970: time/1000))
        }
    }
    
    private func setup() {
        circleView.layer.cornerRadius = circleView.bounds.height / 2
        circleView.layer.borderColor = UIColor.white.cgColor
        circleView.clipsToBounds = true
    }
}
