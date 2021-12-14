//
//  CaveViewController.swift
//  Dangun Legend
//
//  Created by Lee Jong Yun on 2021/12/14.
//

import Foundation
import UIKit

class CaveViewController: UIViewController {
    
    private var mainScrollView: CaveScrollView!
    private var mainStackView: UIStackView!
    
    private var addGoalButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureCaveView()
        
        self.setupMainScrollView()
        
        self.setupMainStackView()
        
        self.setupAddGoalButton()
    }
    
    // MARK: - UI Setting
    private func configureCaveView() {
        self.view.backgroundColor = .white
    }
    
    private func setupMainScrollView() {
        let scrollView = CaveScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.clipsToBounds = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        
        self.view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
            make.height.equalTo(230)
            make.centerY.equalToSuperview()
        }
        self.mainScrollView = scrollView
    }
    
    private func setupMainStackView() {
        let stackView = UIStackView()
        
        [1,2,3,4,5]
            .map { _ in
                return CaveScrollViewCell()
            }
            .forEach { view in
                stackView.addArrangedSubview(view)
                view.layer.cornerRadius = 100
                view.snp.makeConstraints { make in
                    make.height.equalTo(200)
                    make.width.equalTo(self.view.frame.width)
                }
            }
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 30
        
        self.mainScrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
        }
        self.mainStackView = stackView
    }
    
    private func setupAddGoalButton() {
        let button = UIButton()
        button.addTarget(self, action: #selector(self.addGoalTapped), for: .touchUpInside)
        button.setImage(UIImage(systemName: "plus.app.fill"), for: .normal)
        button.tintColor = .black
        
        self.view.addSubview(button)
        button.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.bottom.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(20)
        }
        self.addGoalButton = button
    }
    
//    private func colourViews() -> [UIView] {
//        var colours: [UIColor] = [.green, .red, .blue, .yellow, .orange, .brown]
//
//        for _ in 0...3 {
//            colours.append(contentsOf: colours)
//        }
//
//        let coulourViews = colours
//            .map { colour -> UIView in
//                let view = UIView()
//                view.backgroundColor = colour
//
//                let label = UILabel()
//                if #available(iOS 14.0, *) {
//                    label.text = colour.accessibilityName
//                } else {
//                    label.text = colour.description
//                }
//                label.font = .fontSFProDisplay(size: 20, family: .Medium)
//                view.addSubview(label)
//                label.snp.makeConstraints { make in
//                    make.center.equalToSuperview()
//                }
//                return view
//            }
//        return coulourViews
//    }
    
//    private func setupContentStackViewType1() {
//        let stackView = UIStackView()
//
//        self.colourViews()
//            .forEach { view in
//                stackView.addArrangedSubview(view)
//                view.layer.cornerRadius = 100
//                view.alpha = 0.2
//                view.snp.makeConstraints { make in
//                    make.height.equalTo(200)
//                    make.width.equalTo(200)
//                }
//            }
//        stackView.axis = .vertical
//        stackView.alignment = .leading
//        stackView.distribution = .equalSpacing
//        stackView.spacing = 30
//
//        self.mainScrollView.addSubview(stackView)
//        stackView.snp.makeConstraints { make in
//            make.top.bottom.equalToSuperview()
//            make.trailing.equalToSuperview()
//            make.leading.equalToSuperview()
//            make.width.equalToSuperview()
//        }
//        self.mainStackView = stackView
//    }
    
    
    
    // MARK: - Actions
    @objc private func addGoalTapped() {
        
    }
}

