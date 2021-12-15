//
//  CaveViewController.swift
//  Dangun Legend
//
//  Created by Lee Jong Yun on 2021/12/14.
//

import Foundation
import UIKit

class CaveViewController: UIViewController {
    
    //UI
    private var mainScrollView: CaveScrollView!
    private var mainStackView: UIStackView!
    private var addGoalButton: UIButton!
    
    //Data
    private var userInfo: UserInfo?
    
    private var currentIndex: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCaveViewUserInterface()
        
        self.userInfo = DangunManager.userInfo
    }
    
    
    // MARK: - UI Setting
    private func setCaveViewUserInterface() {
        self.view.backgroundColor = .white
        self.setupMainScrollView()
        self.setupMainStackView()
        self.setupDimView()
        self.setupAddGoalButton()
    }
    
    private func setupMainScrollView() {
        let scrollView = CaveScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.clipsToBounds = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        
        self.view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
            make.height.equalTo(260)
            make.centerY.equalToSuperview()
        }
        self.mainScrollView = scrollView
    }
    
    private func setupMainStackView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 60
        
        self.userInfo?.usersGoalData
            .enumerated()
            .forEach { (i, goalData) in
                let view = CaveScrollDetailView()
                view.index = i
                view.setCaveScrollViewDetail(with: goalData)
                
                stackView.addArrangedSubview(view)
                view.snp.makeConstraints { make in
                    make.height.equalTo(200)
                    make.width.equalTo(self.view.frame.width)
                }
            }
        
        self.mainScrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.width.equalToSuperview()
        }
        self.mainStackView = stackView
    }
    
    private func setupAddGoalButton() {
        let button = UIButton()
        button.addTarget(self, action: #selector(self.addGoalTapped), for: .touchUpInside)
        
        let imageView = UIImageView.init(image: UIImage(systemName: "plus.app.fill"))
        imageView.tintColor = .black
        button.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.center.equalToSuperview()
        }
        
        self.view.addSubview(button)
        button.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.bottom.equalToSuperview().offset(-90)
            make.trailing.equalToSuperview().offset(-10)
        }
        self.addGoalButton = button
    }
    
    private func setupDimView() {
        let topDimView = DimView()
        let bottomDimView = DimView()

        self.view.addSubview(topDimView)
        topDimView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.mainScrollView.snp_top).offset(-30)
        }
        
        self.view.addSubview(bottomDimView)
        bottomDimView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(self.mainScrollView.snp_bottom).offset(-30)
        }
    }
    
    // MARK: - Actions
    @objc private func addGoalTapped() {
        self.rotate()
        let vc = AddGoalViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    private func rotate() {
        DispatchQueue.main.async {
            for n in 1...180 {
                Timer.scheduledTimer(withTimeInterval: 0.003*Double(n), repeats: false) { (timer) in
                    self.addGoalButton.transform = CGAffineTransform(rotationAngle: (1*n).pi.cgFloat)
                }
            }
        }
    }
}

extension CaveViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        //Calculate ScrollView Page
        let pageHeight = scrollView.frame.height
        let targetYContentOffset = Float(targetContentOffset.pointee.y)
        let contentHeight = CGFloat(scrollView.contentSize.height)
        
        var newPage = self.currentIndex
        if velocity.x == 0 {
            newPage = floor((CGFloat(targetYContentOffset) - pageHeight / 2) / pageHeight) + 1.0
        } else {
            newPage = velocity.x > 0 ? newPage + 1 : newPage - 1
            if newPage < 0 {
                newPage = 0
            }
            if (newPage > contentHeight / pageHeight) {
                newPage = ceil(contentHeight / pageHeight) - 1.0
            }
        }
        
        self.resetOldPageIfSameAs(newPage)
    }
    
    private func resetOldPageIfSameAs(_ newPage: CGFloat) {
        if self.currentIndex != newPage {
            guard let scrollViewCell = self.mainStackView.subviews[Int(self.currentIndex)] as? CaveScrollDetailView else { return
            }
            scrollViewCell.refreshScroll()
            self.currentIndex = newPage
        }
    }
}
