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
    
    private var goalTextField: UITextView!
    
    private var gradientLayer: CAGradientLayer!
    
    private var dummyDismissButton: UIButton!
    
    var addButtonSpinAction: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setAddGoalView()
        self.setDummyDismissButton()
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
            make.bottom.equalToSuperview().offset(-250)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(300)
        }
        self.addGoalView = addGoalView
        
        self.setTextFieldInsideTheAddGoalView()
    }

    
    private func setTextFieldInsideTheAddGoalView() {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.tintColor = .clear
        textView.autocorrectionType = .no
        textView.text = "Trump's fist merging into Biden's face"
        textView.textColor = .systemGray
        
        textView.font = UIFont.fontSFProDisplay(size: 20, family: .Medium)
        self.addGoalView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(70)
        }
        self.goalTextField = textView
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
    
    private func setDummyDismissButton() {
        let button = UIButton()
        button.addTarget(self, action: #selector(self.buttonTap(_:)), for: .touchUpInside)
        self.view.addSubview(button)
        button.snp.makeConstraints { make in
            make.size.equalTo(80)
            make.bottom.equalToSuperview().offset(-120)
            make.trailing.equalToSuperview().offset(-20)
        }
        self.dummyDismissButton = button
    }
    
    @objc private func buttonTap(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
}

extension AddGoalViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .systemGray {
            textView.text = ""
            textView.textColor = .black
        }
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Trump's fist merging into Biden's face"
            textView.textColor = .systemGray
        }
    }
}
