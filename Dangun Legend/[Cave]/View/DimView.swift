//
//  DimView.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/12/14.
//

import Foundation
import UIKit

class DimView: UIView {
    
    var gradientLayer: CAGradientLayer!
    
    init(topToBotom: Bool, at vc: UIViewController, gradientLocation: [NSNumber], frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        self.gradientLayer = CAGradientLayer()
        self.gradientLayer.frame = frame
        self.gradientLayer.locations = gradientLocation
        self.gradientLayer.colors = [
//            UIColor.white.cgColor,
            UIColor.lightGray.withAlphaComponent(0.8).cgColor,
            UIColor.lightGray.withAlphaComponent(0.15).cgColor,
            UIColor.white.withAlphaComponent(0.0).cgColor
        ]
        if !topToBotom {
            self.gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
            self.gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        }
        self.layer.addSublayer(self.gradientLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView: UIView? = super.hitTest(point, with: event)
        if (self == hitView) { return nil }
        return hitView
    }
    
}
