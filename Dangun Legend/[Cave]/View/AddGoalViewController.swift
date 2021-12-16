//
//  AddGoalViewController.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/12/14.
//

import Foundation
import UIKit

class AddGoalViewController: UIViewController {
    
    private var addGoalView: UIView!
    
    private var goalTextField: UITextField!
    
    private var gradientLayer: CAGradientLayer!
    
    var addButtonSpinAction: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setAddGoalView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.addButtonSpinAction?()
    }
    
    // MARK: - UI Setting
    private func setAddGoalView() {
        let addGoalView = UIView()
        addGoalView.backgroundColor = .white
        addGoalView.layer.cornerRadius = 30
        
        self.view.addSubview(addGoalView)
        addGoalView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(300)
        }
        self.addGoalView = addGoalView
        
        self.setTextFieldInsideTheAddGoalView()
    }
    
    private func setTextFieldInsideTheAddGoalView() {
        let textField = UITextField()
        textField.placeholder = "도전하고 싶은 목표를 입력해주세요."
        textField.backgroundColor = .clear
        textField.tintColor = .clear
        
        textField.font = UIFont.fontSFProDisplay(size: 20, family: .Medium)
        self.addGoalView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(80)
        }
        self.goalTextField = textField
        self.goalTextField.delegate = self
        
        self.setDivisionView()
    }
    
    private func setDivisionView() {
        let divisionView = UIView()
        divisionView.backgroundColor = .black
        
        self.goalTextField.addSubview(divisionView)
        divisionView.snp.makeConstraints { make in
            make.height.equalTo(0.2)
            make.width.centerX.equalToSuperview()
            make.top.equalTo(self.goalTextField.snp_bottom)
        }
    }
}

extension AddGoalViewController: UITextFieldDelegate {

}

