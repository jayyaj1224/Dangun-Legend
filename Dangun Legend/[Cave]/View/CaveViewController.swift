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
        
        self.setupDimView()
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
            make.height.equalTo(260)
            make.centerY.equalToSuperview()
        }
        self.mainScrollView = scrollView
    }
    
    private func setupMainStackView() {
        let stackView = UIStackView()
        
        [1,2,3,4,5]
            .forEach { _ in
                let view = CaveScrollViewCell()
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
        stackView.spacing = 60
        
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
            make.bottom.equalToSuperview().offset(-100)
            make.trailing.equalToSuperview().offset(-10)
        }
        self.addGoalButton = button
    }
    
    private func setupDimView() {
        let topDimView = DimView()
        let bottomDimView = DimView()

        [topDimView, bottomDimView].forEach { view in
            view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            view.alpha = 0.3
            self.view.addSubview(view)
        }

        topDimView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.mainScrollView.snp_top).offset(-30)
        }

        bottomDimView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(self.mainScrollView.snp_bottom).offset(-30)
        }
    }
    
    // MARK: - Actions
    @objc private func addGoalTapped() {
        print("  taptap --!  \n")
        self.rotate()
    }
    
    private func rotate() {
        DispatchQueue.main.async {
            for n in 1...90 {
                Timer.scheduledTimer(withTimeInterval: 0.005*Double(n), repeats: false) { (timer) in
                    self.addGoalButton.transform = CGAffineTransform(rotationAngle: (1*n).pi.cgFloat)
                }
            }
        }
    }
}

extension CaveViewController: UIScrollViewDelegate {
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        <#code#>
//    }
}


class DimView: UIView {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView: UIView? = super.hitTest(point, with: event)
        if (self == hitView) { return nil }
        return hitView
    }
}
