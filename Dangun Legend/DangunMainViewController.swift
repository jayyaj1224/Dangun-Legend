//
//  DangunMainViewController.swift
//  Dangun Legend
//
//  Created by Lee Jong Yun on 2021/12/17.
//

import Foundation
import UIKit

class DangunMainViewController: UIViewController {
    
    private var pageContainingView: UIView!
    
    private var pageSegmentView: UIView!
    private var pageSegmentController: UISegmentedControl!
    private var segmentIndicator: UIView!
    
    private var pageController: UIPageViewController!
    private var viewControllers: [UIViewController] = []
    
    private var caveViewController: UIViewController!
    private var peopleViewController: UIViewController!

    private typealias AttKey = NSAttributedString.Key
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setDangunMainViewInterface()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.pageSegmentController.selectedSegmentIndex = 0
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        self.indicatorLocate()
        
        let selectedIndex = sender.selectedSegmentIndex
        if self.viewControllers[selectedIndex] != self.pageController.viewControllers?[0] {
            self.pageController.setViewControllers([self.viewControllers[selectedIndex]], direction: .forward, animated: false)
        }
        UIView.animate(withDuration: 0.2) {
            self.pageSegmentView.layoutIfNeeded()
        }
        
//        switch selectedIndex {
//        case 0:
//            print("cave vc")
//            if let id = self.awardId {
//                UserDefaults.standard.set(id, forKey: "HOME_AWARD_IS_NEW_BADGE")
//                self.awardUpdateBadge.isHidden = true
//                self.awardId = nil
//            }
//        case 1:
//            print("people vc")
//            if let id = self.collectionId {
//                UserDefaults.standard.set(id, forKey: "HOME_COLLECTION_IS_NEW_BADGE")
//                self.collectionUpdateBadge.isHidden = true
//                self.collectionId = nil
//            }
//        default:
//            return
//        }
    }
    
    
    // MARK: - UI Setting
    private func setDangunMainViewInterface() {
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        self.setPageController()
        self.setPageSegmentController()
        self.setPageViewControllers()
        self.setSegmentIndicator()
    }
    
    private func setPageController() {
        self.pageContainingView = {
            let view = UIView()
            self.view.addSubview(view)
            view.snp.makeConstraints { make in
                make.leading.trailing.top.bottom.equalToSuperview()
            }
            return view
        }()
        
        self.pageController = {
            return UIPageViewController(
                transitionStyle: .scroll,
                navigationOrientation: .horizontal,
                options: nil)
        }()
        
        self.addChild(self.pageController)
        self.pageContainingView.addSubview(self.pageController.view)
        self.pageController.view.frame = self.pageContainingView.bounds
        self.pageController.didMove(toParent: self)
        self.pageController.delegate = self
        self.pageController.dataSource = self
    }
    
    private func setPageSegmentController() {
        self.pageSegmentView = {
            let view = UIView()
            self.view.addSubview(view)
            view.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.bottom.equalToSuperview().offset(-30)
                make.height.equalTo(50)
            }
            return view
        }()

        self.pageSegmentController = {
            let segmentController = UISegmentedControl(items: ["나의 동굴", "사람들"])
            segmentController.selectedSegmentTintColor = .clear
            segmentController.setBackgroundImage(UIImage(color: .clear), for: .normal, barMetrics: .default)
            segmentController.setDividerImage(UIImage(color: .clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
            segmentController.addTarget(self, action: #selector(self.segmentChanged), for: .valueChanged)
            
            let normal: [AttKey : Any] = [
                AttKey.font : UIFont.fontSFProDisplay(size: 20, family: .Regular),
                AttKey.foregroundColor: UIColor.lightGray
            ]
            let selected:[AttKey : Any]  = [
                AttKey.font : UIFont.fontSFProDisplay(size: 20, family: .Heavy),
                AttKey.foregroundColor: UIColor.black
            ]
            segmentController.setTitleTextAttributes(normal, for: .normal)
            segmentController.setTitleTextAttributes(selected, for: .selected)

            self.pageSegmentView.addSubview(segmentController)
            segmentController.snp.makeConstraints { make in
                make.leading.trailing.top.bottom.equalToSuperview()
            }

            return segmentController
        }()
    }
    
    private func setPageViewControllers() {
        self.caveViewController = CaveViewController()
        self.peopleViewController = PeopleViewController()
        self.viewControllers = [self.caveViewController, self.peopleViewController]
        self.pageController.setViewControllers([self.caveViewController], direction: .forward, animated: true)
    }
    
    private func setSegmentIndicator() {
        let indicator = UIView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.backgroundColor = .black
//        indicator.layer.cornerRadius = 1
        
        self.pageSegmentView.addSubview(indicator)
        self.segmentIndicator = indicator
        self.indicatorLocate()
    }
    
    private func indicatorLocate() {
        let selectedIndex = self.pageSegmentController.selectedSegmentIndex

        self.segmentIndicator.snp.remakeConstraints { (make) in
            make.top.equalTo(self.pageSegmentController.snp.bottom).offset(-10)
            make.height.equalTo(3)
            make.width.equalTo(120)
            
            if selectedIndex < 0 {
                make.centerX.equalTo(self.view).offset(-CS.screenWidth/4)
            } else {
                make.centerX.equalTo(self.pageSegmentController.segmentAt(selectedIndex))
            }
           
        }
    }
    
}

extension DangunMainViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = self.viewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = index - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        return self.viewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = self.viewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = index + 1
        
        guard nextIndex < self.viewControllers.count else {
            return nil
        }
        
        return self.viewControllers[nextIndex]
    }
}

extension DangunMainViewController : UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentViewController = pageViewController.viewControllers?[0],
               let currentIndex = self.viewControllers.firstIndex(of: currentViewController) {
                self.pageSegmentController.selectedSegmentIndex = currentIndex
                self.segmentChanged(self.pageSegmentController)
                
            }
        }
    }
}
