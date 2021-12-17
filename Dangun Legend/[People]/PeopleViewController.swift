//
//  PeopleViewController.swift
//  Dangun Legend
//
//  Created by Lee Jong Yun on 2021/12/14.
//

import Foundation
import UIKit

class PeopleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.setPeopleiewControllerUI()
    }

    
    private func setPeopleiewControllerUI() {
        self.setBackground()
        
    }
    
    private func setBackground() {
        self.view.backgroundColor = .crayon
    }

}

