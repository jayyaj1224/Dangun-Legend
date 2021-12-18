//
//  CaveViewController.swift
//  Dangun Legend
//
//  Created by Lee Jong Yun on 2021/12/14.
//

import Foundation
import UIKit

class CaveMainTableView: UIViewController {
    
    //UI
    private var mainTableView: UITableView!
    private var mainStackView: UIStackView!
    private var addGoalButton: UIButton!
    
    //Data
    private var userInfo: UserInfo?
    
    private var currentIndex: CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCaveViewUserInterface()
        
        self.userInfo = CS.userInfo
    }
    
    
    // MARK: - UI Setting
    private func setCaveViewUserInterface() {
        self.view.backgroundColor = .crayon
//        self.setupBottomDimView()
        self.setupMainScrollView()
        self.setGoalsScrollView()
        self.setupTopDimview()
        self.setupAddGoalButton()
    }
    
    private func setupMainScrollView() {
        let tableview = CaveTableView()
        tableview.showsHorizontalScrollIndicator = false
        tableview.clipsToBounds = false
        tableview.showsVerticalScrollIndicator = false
        tableview.delegate = self
        tableview.dataSource = self
//        tableview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        
        self.view.addSubview(tableview)
        
        tableview.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-40)
            make.leading.equalToSuperview().offset(-60)
            make.trailing.equalToSuperview()
            make.height.equalTo(CS.screenWidth)
            make.centerY.equalToSuperview()
        }
        self.mainTableView = tableview
    }
    
//    private func setGoalsScrollView() {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.alignment = .leading
//        stackView.distribution = .equalSpacing
//        stackView.spacing = 40
//
//        self.userInfo?.usersGoalData
//            .enumerated()
//            .forEach { (i, goalData) in
//                let view = CaveScrollDetailView()
//                view.index = i
//                view.setCaveScrollViewDetail(with: goalData)
//
//                stackView.addArrangedSubview(view)
//                view.snp.makeConstraints { make in
//                    make.height.equalTo(200)
//                    make.width.equalTo(self.view.frame.width)
//                }
//            }

//        self.mainScrollView.addSubview(stackView)
//        stackView.snp.makeConstraints { make in
//            make.top.bottom.leading.trailing.width.equalToSuperview()
//        }
//        self.mainStackView = stackView
//    }
    
//    private func DUMMY___setupMainStackView() {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.alignment = .leading
//        stackView.distribution = .equalSpacing
//        stackView.spacing = 40
//
//        let colours : [UIColor] = [.ganziGreen, .red, .ganziGreen, .yellow, .ganziGreen, .brown]
//
//        colours.forEach { colour in
//            let view = UIView()
//            view.backgroundColor = colour
//            view.layer.cornerRadius = (CS.screenWidth-40)/2
//            view.alpha = 0.5
//
//            stackView.addArrangedSubview(view)
//            view.snp.makeConstraints { make in
//                make.height.width.equalTo(CS.screenWidth-40)
//            }
//        }

//        self.mainScrollView.addSubview(stackView)
//        stackView.snp.makeConstraints { make in
//            make.top.bottom.leading.trailing.width.equalToSuperview()
//        }
//        self.mainStackView = stackView
//    }
    
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
            make.bottom.equalToSuperview().offset(-90)
            make.trailing.equalToSuperview().offset(-10)
        }
        self.addGoalButton = button
    }
    
    private func setupTopDimview() {
        let dimViewHeight: CGFloat = 300
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
    
    // MARK: - Actions
    @objc private func addGoalTapped() {
        self.rotate()
        let vc = AddGoalViewController()
        vc.caveViewAddNewGoalClosure = { [weak self] newGoal in
            guard let self = self, var info = self.userInfo else { return }
            info.usersGoalData.append(newGoal)
            info.totalTrialCount+=1
            self.userInfo = info
            self.updateUserInfo()
        }
        
        vc.caveViewAddButtonSpinActionClosure = { [weak self] in
            guard let self = self else { return }
            self.rotateBack()
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    private func updateUserInfo() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(self.userInfo), forKey: CS.UDKEY_USERINFO)
    }
    
    private func rotate() {
        DispatchQueue.main.async {
            for n in 1...225 {
                Timer.scheduledTimer(withTimeInterval: 0.002*Double(n), repeats: false) { (timer) in
                    self.addGoalButton.transform = CGAffineTransform(rotationAngle: (1*n).pi.cgFloat)
                }
            }
        }
    }
    private func rotateBack() {
        DispatchQueue.main.async {
            for n in 1...180 {
                Timer.scheduledTimer(withTimeInterval: 0.002*Double(n), repeats: false) { (timer) in
                    self.addGoalButton.transform = CGAffineTransform(rotationAngle: (1*n).pi.cgFloat)
                }
            }
        }
    }
}

extension CaveViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userInfo?.usersGoalData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
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
