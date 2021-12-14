//
//  TabBarViewController.swift
//  Dangun Legend
//
//  Created by Lee Jong Yun on 2021/12/14.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController {
    
    lazy var subViewControllers: [UIViewController] = [
        self.caveViewController, self.bearViewController
    ]
    
    let caveViewController = CaveViewController()
    let bearViewController = BearsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTabBar()
        
        self.setupViewController(
            vc: self.caveViewController,
            title: "Cave",
            uiImage: "circle.square",
            selectedImage: "circle.square.fill"
        )
        self.setupViewController(
            vc: self.bearViewController,
            title: "Bears",
            uiImage: "rectangle.on.rectangle",
            selectedImage: "rectangle.fill.on.rectangle.fill"
        )
        self.setViewControllers(self.subViewControllers, animated: false)
    }
    
    private func setupViewController(vc: UIViewController, title: String, uiImage: String, selectedImage: String) {
        vc.title = title
        vc.navigationItem.largeTitleDisplayMode = .always
        let uiImage = UIImage(systemName: uiImage)
        let selectedImage = UIImage(systemName: selectedImage)
        let tabBarItem = UITabBarItem(title: title, image: uiImage, selectedImage: selectedImage)
        vc.tabBarItem = tabBarItem
    }
    
    private func configureTabBar() {
        self.tabBar.tintColor = .black
        let isTransparent = UIImage()
        self.tabBar.backgroundImage = isTransparent
        self.tabBar.shadowImage = isTransparent
    }
}

extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected \(viewController.title!)")
    }
}
