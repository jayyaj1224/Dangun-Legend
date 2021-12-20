//
//  CaveViewController.swift
//  Dangun Legend
//
//  Created by Lee Jong Yun on 2021/12/14.
//

import Foundation
import UIKit

protocol CaveViewDelegate {
    func addGoal(_ newGoal: GoalModel)
    
    func addGoalViewDisappeared()
}

class CaveViewController: UIViewController {
    //UI
    private var caveMainScrollView: CaveMainScrollView!
    private var mainStackView: UIStackView!
    private var addGoalButton: UIButton!
    
    private var bottomHideView: UIView!
    
    //Data
    private var userInfo: UserInfo?
    
    private var currentIndex: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userInfo = CS.userInfo
        self.setCaveViewUserInterface()
    }
    
    @objc private func addGoalTapped() {
        self.rotate()
        let addGoalVc = AddGoalViewController()
        addGoalVc.caveDelegate = self
        self.present(addGoalVc, animated: true, completion: nil)
    }
    
    func deleteGoalAt(_ index: Int) {
        guard var info = CS.userInfo else { return }
        info.usersGoalData.remove(at: index)
        CS.saveUserInfo(info: info)
        
        self.userInfo = info
        self.updateScrollView()
    }
    
    func updateScrollView() {
        self.mainStackView.subviews.forEach { self.mainStackView.removeArrangedSubview($0) }
        self.caveMainScrollView.removeFromSuperview()
        self.addGoalButton.removeFromSuperview()
        self.setCaveViewUserInterface()
    }
    
    private func rotate() {
        self.bottomHideView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now()+0.6) {
            for n in 1...225 {
                Timer.scheduledTimer(withTimeInterval: 0.002*Double(n), repeats: false) { (timer) in
                    self.addGoalButton.transform = CGAffineTransform(rotationAngle: (1*n).pi.cgFloat)
                }
            }
        }
    }
}

extension CaveViewController: CaveViewDelegate {
    func addGoal(_ newGoal: GoalModel) {
        guard var info = self.userInfo else { return }
        info.usersGoalData.insert(newGoal, at: 0)
        info.totalTrialCount+=1
        
        CS.saveUserInfo(info: info)
        self.userInfo = info
        
        self.updateScrollView()
    }
    
    func addGoalViewDisappeared() {
        self.bottomHideView.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
            for n in 1...180 {
                Timer.scheduledTimer(withTimeInterval: 0.002*Double(n), repeats: false) { (timer) in
                    self.addGoalButton.transform = CGAffineTransform(rotationAngle: (1*n).pi.cgFloat)
                }
            }
        }
    }
}

// MARK: - UI Setting
extension CaveViewController {
    private func setCaveViewUserInterface() {
        self.view.backgroundColor = .crayon
        self.setupMainScrollView()
        self.setGoalsScrollView()
        self.setupAddGoalButton()
        self.hideBottomView()
    }
    
    private func setupMainScrollView() {
        let scrollView = CaveMainScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.clipsToBounds = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(-50)
            make.trailing.equalToSuperview()
            make.height.equalTo(CS.screenWidth+20)
            make.centerY.equalToSuperview()
        }
        self.caveMainScrollView = scrollView
    }
    
    private func setGoalsScrollView() {
        guard let goalDataArray = self.userInfo?.usersGoalData else { return }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 60
        
        if !goalDataArray.isEmpty {
            goalDataArray
                .enumerated()
                .forEach { (i, goalData) in
                    let singleCaveView = SingleCaveView.init()
                    singleCaveView.tag = i
                    stackView.addArrangedSubview(singleCaveView)
                    singleCaveView.snp.makeConstraints { make in
                        make.height.equalTo(singleCaveView.selfHeight)
                        make.width.equalToSuperview()
                    }
                    singleCaveView.setGoalInfo(goalData)
                }
        } else {
            let singleCaveView = SingleCaveView.init()
            singleCaveView.isScrollEnabled = false
            stackView.addArrangedSubview(singleCaveView)
            singleCaveView.snp.makeConstraints { make in
                make.height.equalTo(singleCaveView.selfHeight)
                make.width.equalToSuperview()
            }
            singleCaveView.setGoalInfo(CS.dummyGoal)
        }

        self.caveMainScrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.width.equalToSuperview()
        }
        self.mainStackView = stackView
    }
    
    private func setupAddGoalButton() {
        let button = UIButton()
        button.addTarget(self, action: #selector(self.addGoalTapped), for: .touchUpInside)
        
        let imageView = UIImageView.init(image: UIImage(systemName: "plus.circle.fill"))
        imageView.tintColor = .black
        
        button.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.center.equalToSuperview()
        }
        
        self.view.addSubview(button)
        button.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.bottom.equalToSuperview().offset(-155)
            make.trailing.equalToSuperview()
        }
        self.addGoalButton = button
    }
    
    private func setupBottomDimView() {
        let bottomDimView = UIView()
        bottomDimView.backgroundColor = .lightGray
        bottomDimView.alpha = 0.3

        self.view.addSubview(bottomDimView)
        bottomDimView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
    }
    
    private func hideBottomView() {
        let view = UIView()
        view.backgroundColor = .crayon
        view.isHidden = true
        self.view.addSubview(view)
        view.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
            make.height.equalTo(400)
            make.trailing.equalToSuperview().offset(-75)
        }
        self.bottomHideView = view
    }
}

extension CaveViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //Calculate ScrollView Page
        let pageHeight = scrollView.frame.height
        let targetYContentOffset = Float(targetContentOffset.pointee.y)
        let contentHeight = CGFloat(scrollView.contentSize.height)
        var newPage = self.currentIndex
        
        if velocity.y == 0 {
            newPage = floor((CGFloat(targetYContentOffset) - pageHeight / 2) / pageHeight) + 1.0
        } else {
            newPage = velocity.y > 0 ? newPage + 1 : newPage - 1
            if newPage < 0 {
                newPage = 0
            }
            if (newPage > contentHeight / pageHeight) {
                newPage = ceil(contentHeight / pageHeight) - 1.0
            }
        }
        if newPage != self.currentIndex {
            self.resetOldPageIfSameAs(newPage)
        }
        self.currentIndex = newPage
        let point = CGPoint (x: targetContentOffset.pointee.x, y: CGFloat(newPage * pageHeight))
        targetContentOffset.pointee = point
    }
    
    private func resetOldPageIfSameAs(_ newPage: CGFloat) {
        guard let sinlgeCaveView = self.mainStackView.subviews[Int(self.currentIndex)] as? SingleCaveView else {
            return
        }
        sinlgeCaveView.setContentOffset(.zero, animated: true)
    }
}
