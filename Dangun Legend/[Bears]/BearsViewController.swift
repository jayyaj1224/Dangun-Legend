//
//  BearsViewController.swift
//  Dangun Legend
//
//  Created by Lee Jong Yun on 2021/12/14.
//

import Foundation
import UIKit

class BearsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.setBearsViewControllerUI()
    }

    
    private func setBearsViewControllerUI() {
        self.setBackground()
        
    }
    
    private func setBackground() {
        self.view.backgroundColor = .white
    }

}

