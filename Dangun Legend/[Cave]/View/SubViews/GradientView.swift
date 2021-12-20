//
//  GradientView.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/12/14.
//

import Foundation
import UIKit

class GradientView: UIView {
    var gradientLayer: CAGradientLayer!
    
    init(colours: [UIColor], frame: CGRect, gradientLocation: [NSNumber]? = nil, start: CGPoint? = nil, end: CGPoint? = nil) {
        super.init(frame: frame)
        self.gradientLayer = CAGradientLayer()
        self.gradientLayer.frame = frame
        self.gradientLayer.colors = colours.map { $0.cgColor }
        if let gradientLocation = gradientLocation {
            self.gradientLayer.locations = gradientLocation
        }
        if let start = start, let end = end {
            self.gradientLayer.startPoint = start
            self.gradientLayer.endPoint = end
        }
        
        self.layer.addSublayer(self.gradientLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TouchThroughView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView: UIView? = super.hitTest(point, with: event)
        if (self == hitView) { return nil }
        return hitView
    }
}


