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
    
    private var goalTextView: UITextView!
    
    private var failCapPickerView: UIPickerView!
    
    private var gradientLayer: CAGradientLayer!
    
    private var dummyDismissButton: UIButton!
    
    private var failCapArray: [String] = Array(0...10).map { "\($0)회" }
    
    var caveViewAddNewGoalClosure: ((_ goal: GoalModel)->Void)?
    
    var caveViewAddButtonSpinActionClosure: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setAddGoalView()
        self.setDummyDismissButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.caveViewAddButtonSpinActionClosure?()
    }
    
    // MARK: - Action
    @objc private func goalSaveButtonTap(_ sender: UIButton) {
        let newGoal = GoalModel.init(
            goal: self.goalTextView.text,
            failCap: self.failCapPickerView.selectedRow(inComponent: 0)
        )
        self.caveViewAddNewGoalClosure?(newGoal)
    }
    
    @objc private func buttonTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
        
        textView.backgroundColor = .lightGray
        
        textView.font = UIFont.fontSFProDisplay(size: 20, family: .Medium)
        self.addGoalView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(100)
        }
        self.goalTextView = textView
        self.goalTextView.delegate = self
        
        self.setDivisionView()
    }
    
    private func setDivisionView() {
        let divisionView = UIView()
        divisionView.backgroundColor = .black
        
        self.goalTextView.addSubview(divisionView)
        divisionView.snp.makeConstraints { make in
            make.height.equalTo(0.2)
            make.width.centerX.equalToSuperview()
            make.top.equalTo(self.goalTextView.snp.bottom)
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
    
    private func setupFailCapPicker() {
        let pickerView = UIPickerView()
        self.addGoalView.addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-80)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(50)
        }
        pickerView.delegate = self
        pickerView.dataSource = self
        self.failCapPickerView = pickerView
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

extension AddGoalViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.failCapArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.failCapArray[row]
    }
    
    
}
