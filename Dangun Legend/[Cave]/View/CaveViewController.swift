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
    
    // MARK: - Actions
    @objc private func addGoalTapped() {
        self.rotate()
        let vc = AddGoalViewController()
        vc.caveViewAddNewGoalClosure = { [weak self] newGoal in
            guard let self = self, var info = self.userInfo else { return }
            info.usersGoalData.insert(newGoal, at: 0)
            info.totalTrialCount+=1
            
            CS.saveUserInfo(info: info)
            self.userInfo = info
            
            self.updateScrollView()
        }
        
        vc.caveViewAddButtonSpinActionClosure = { [weak self] in
            guard let self = self else { return }
            self.rotateBack()
        }
        self.present(vc, animated: true, completion: nil)
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
    private func rotateBack() {
        self.bottomHideView.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
            for n in 1...180 {
                Timer.scheduledTimer(withTimeInterval: 0.002*Double(n), repeats: false) { (timer) in
                    self.addGoalButton.transform = CGAffineTransform(rotationAngle: (1*n).pi.cgFloat)
                }
            }
        }
    }
    
    // MARK: - UI Setting
    private func setCaveViewUserInterface() {
        self.view.backgroundColor = .crayon
        self.setupMainScrollView()
        self.setGoalsScrollView()
        self.setupTopDimview()
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
            make.leading.equalToSuperview().offset(-60)
            make.trailing.equalToSuperview()
            make.height.equalTo(CS.screenWidth)
            make.centerY.equalToSuperview()
        }
        self.caveMainScrollView = scrollView
    }
    
    private func setGoalsScrollView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 40

        self.userInfo?.usersGoalData
            .forEach { goalData in
                
                let singleCaveView = SingleCaveView()
                stackView.addArrangedSubview(singleCaveView)
                singleCaveView.snp.makeConstraints { make in
                    make.height.equalTo(CS.screenWidth-40)
                    make.width.equalToSuperview()
                }
                singleCaveView.delegate = self
                singleCaveView.setGoalInfo(goalData)
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
    
    private func setupTopDimview() {
        let dimViewHeight: CGFloat = 200
        let frame = CGRect(x: 0, y: 0, width: CS.screenWidth, height: dimViewHeight)
        
        let topDimView = DimView(
            topToBotom: false,
            at: self,
            gradientLocation: [0.0,0.25],
            frame: frame,
            colours: [
                .crayon.withAlphaComponent(0),
                .crayon
            ]
        )
        self.view.addSubview(topDimView)
        topDimView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(dimViewHeight)
        }
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
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let caveScrollView = scrollView as? SingleCaveView else { return }
        let xOffset = caveScrollView.contentOffset.x
        switch xOffset {
        case ...10:
            caveScrollView.caveImageView.alpha = 0
        case 10...800:
            caveScrollView.caveImageView.alpha = xOffset*0.001
        default:
            caveScrollView.caveImageView.alpha = 0.8
        }
    }
    
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
        
//        self.resetOldPageIfSameAs(newPage)
        self.currentIndex = newPage
        let point = CGPoint (x: targetContentOffset.pointee.x, y: CGFloat(newPage * pageHeight))
        targetContentOffset.pointee = point
    }
    
    private func resetOldPageIfSameAs(_ newPage: CGFloat) {
//        guard let scrollViewCell = self.mainStackView.subviews[Int(self.currentIndex)] as? CaveScrollDetailView else {
//            return
//        }
//        scrollViewCell.refreshScroll()
    }
}
