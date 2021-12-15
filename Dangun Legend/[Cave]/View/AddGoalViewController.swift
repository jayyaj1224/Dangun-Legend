//
//  AddGoalViewController.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/12/14.
//

import Foundation
import UIKit

class AddGoalViewController: UIViewController {
    
    private var gradientLayer: CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setBackGroundGradient()
    }
    
    private func setBackGroundGradient() {
        self.gradientLayer = CAGradientLayer()
        self.gradientLayer.frame = self.view.bounds
        self.gradientLayer.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
        self.view.layer.addSublayer(self.gradientLayer)
    }
    
}

