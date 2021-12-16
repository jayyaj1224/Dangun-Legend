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
    private func setTextField() {
        let textField = UITextField()
        
        self.view.addSubview(textField)
        textField.snp.makeConstraints { make in
            
        }
        
        self.goalTextField = textField
    }
    
    private func setAddGoalView() {
        let addGoalView = UIView()
        addGoalView.backgroundColor = .white
        addGoalView.layer.cornerRadius = 30
        
        self.view.addSubview(addGoalView)
        addGoalView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(300)
        }
        self.addGoalView = addGoalView
    }
    
    private func setTextFieldView() {
        let textView = UIView()
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 30
        
        self.view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(200)
        }
        
        let textField = UITextView()
        textView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-80)
            make.height.equalTo(200)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
        }
    }
    
}

