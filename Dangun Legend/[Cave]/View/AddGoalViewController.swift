//
//  AddGoalViewController.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/12/14.
//

import Foundation
import UIKit
import Kingfisher

class AddGoalViewController: UIViewController {
    
    private var addGoalView: UIView!
    
    private var goalTextView: UITextView!
    
    private var totalDaysPicker: UIPickerView!
    private var targetDaysPicker: UIPickerView!
    
    private var gradientLayer: CAGradientLayer!
    
    private var challengeButton: UIButton!
    private var challengeButtonLabel: UILabel!
    
    private var dummyDismissButton: UIButton!
    
    private var totalDaysArray: [String] = Array(1...100).map { "\($0*10)일 중" }
    
    var caveViewAddNewGoalClosure: ((_ goal: GoalModel)->Void)?
    
    var caveViewAddButtonSpinActionClosure: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setAddGoalView()
        self.setDummyDismissButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupCloseLabel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.caveViewAddButtonSpinActionClosure?()
    }
    
    // MARK: - Action
    @objc private func goalSaveButtonTap(_ sender: UIButton) {
        let totalDays: Int = {
            let selectedRow = self.totalDaysPicker.selectedRow(inComponent: 0)
            return (selectedRow+1)*10
        }()
        let title = "< 새로운 \(totalDays)일 목표 >\n  \n\(self.goalTextView.text!)\n   "
        let message = "목표한 일 수 만큼 미실행 시\n도전은 실패로 종료됩니다"
        let alerView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default) { action in
            self.saveNewGoal()
        }
        let cancel = UIAlertAction(title: "취소", style: .destructive) { _ in }
        alerView.addAction(confirm)
        alerView.addAction(cancel)
        self.present(alerView, animated: true, completion: nil)
    }
    
    @objc private func buttonTap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    private func saveNewGoal() {
        let totalDays: Int = {
            let selectedRow = self.totalDaysPicker.selectedRow(inComponent: 0)
            return (selectedRow+1)*10
        }()
        let targetDays: Int = {
            return totalDays - self.targetDaysPicker.selectedRow(inComponent: 0)
        }()
        
        let newGoal = GoalModel.init(
            goal: self.goalTextView.text,
            failCap: totalDays - targetDays
        )
        self.caveViewAddNewGoalClosure?(newGoal)
        self.dismiss(animated: true)
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
        let textView: UITextView = {
            let textView = UITextView()
            textView.backgroundColor = .clear
            textView.tintColor = .lightGray.withAlphaComponent(0.5)
            textView.textAlignment = .center
            textView.autocorrectionType = .no
            textView.text = "탭하여 목표를 입력해주세요"
            textView.textColor = .systemGray
            textView.font = UIFont.fontSFProDisplay(size: 22, family: .Semibold)
            self.addGoalView.addSubview(textView)
            textView.snp.makeConstraints { make in
                make.width.equalToSuperview().offset(-30)
                make.centerX.equalToSuperview()
                make.height.equalTo(70)
                make.bottom.equalToSuperview().offset(-170)
            }
            self.goalTextView = textView
            self.goalTextView.delegate = self
            return textView
        }()
        
        let _ = {
            let view = UIView()
            view.backgroundColor = .black
            self.addGoalView.addSubview(view)
            view.snp.makeConstraints { make in
                make.height.equalTo(0.5)
                make.width.centerX.bottom.equalTo(textView)
            }
        }()
        self.setupFailCapPickerStackView()
    }
    
    private func setupFailCapPickerStackView() {
        let stackView: UIStackView = {
            let view = UIStackView()
            view.axis = .horizontal
            view.distribution = .fillEqually
            view.spacing = 5
            self.addGoalView.addSubview(view)
            view.snp.makeConstraints { make in
                make.width.equalTo(300)
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(124)
                make.height.equalTo(90)
            }
            return view
        }()
        
        let _ = {
            let totalDaysPick = UIPickerView()
            totalDaysPick.tag = 0
            totalDaysPick.backgroundColor = .clear
            totalDaysPick.delegate = self
            totalDaysPick.dataSource = self
            totalDaysPick.backgroundColor = .clear
            stackView.addArrangedSubview(totalDaysPick)
            self.totalDaysPicker = totalDaysPick
        }()
        let _ = {
            let targetDaysPick = UIPickerView()
            targetDaysPick.tag = 1
            targetDaysPick.backgroundColor = .clear
            targetDaysPick.delegate = self
            targetDaysPick.dataSource = self
            targetDaysPick.backgroundColor = .clear
            stackView.addArrangedSubview(targetDaysPick)
            self.targetDaysPicker = targetDaysPick
        }()
        self.setChallengButton()
    }
    
    private func setChallengButton() {
        let _ = {
            let label = UILabel()
            label.text = "도전!"
            label.textAlignment = .center
            label.textColor = .lightGray.withAlphaComponent(0.5)
            label.font = .fontSFProDisplay(size: 20, family: .Heavy)
            self.addGoalView.addSubview(label)
            label.snp.makeConstraints { make in
                make.width.equalTo(200)
                make.height.equalTo(40)
                make.bottom.equalToSuperview().offset(-24)
                make.centerX.equalToSuperview()
            }
            self.challengeButtonLabel = label
        }()
       
        let _ = {
            let button = UIButton()
            button.layer.cornerRadius = 14
            button.backgroundColor = .clear
            button.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
            button.layer.borderWidth = 1
            button.isEnabled = false
            button.addTarget(self, action: #selector(self.goalSaveButtonTap(_:)), for: .touchUpInside)
            
            self.addGoalView.addSubview(button)
            button.snp.makeConstraints { make in
                make.width.equalTo(200)
                make.height.equalTo(40)
                make.bottom.equalToSuperview().offset(-24)
                make.centerX.equalToSuperview()
            }
            self.challengeButton = button
        }()
    }
    
    private func setDummyDismissButton() {
        let button = UIButton()
        button.addTarget(self, action: #selector(self.buttonTap(_:)), for: .touchUpInside)
        self.view.addSubview(button)
        button.snp.makeConstraints { make in
            make.size.equalTo(80)
            make.bottom.equalToSuperview().offset(-177)
            make.trailing.equalToSuperview().offset(-43)
        }
        self.dummyDismissButton = button
    }
    
    private func setupCloseLabel() {
        let label = UILabel()
        label.text = "취소"
        label.font = .fontSFProDisplay(size: 15, family: .Bold)
        label.alpha = 0
        self.view.addSubview(label)
        label.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-177)
            make.trailing.equalToSuperview().offset(-43)
        }
        DispatchQueue.main.async {
            for n in 1...100 {
                Timer.scheduledTimer(withTimeInterval: 0.005*Double(n), repeats: false) { (timer) in
                    label.alpha = 0.01*CGFloat(n)
                }
            }
        }
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
    
    func textViewDidChange(_ textView: UITextView) {
        let text = textView.text.filter { $0 != " " }
        let placeHolder = "탭하여 목표를 입력해주세요"
        if text.count < 3 || textView.text == placeHolder {
            self.challengeButton.isEnabled = false
            self.challengeButton.layer.borderColor = UIColor.lightGray.cgColor
            self.challengeButtonLabel.textColor = .lightGray
        } else {
            self.challengeButton.isEnabled = true
            self.challengeButton.layer.borderColor = UIColor.black.cgColor
            self.challengeButtonLabel.textColor = .black
        }
        
    }
}

extension AddGoalViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return self.totalDaysArray.count
        } else {
            return 10
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as? UILabel
        
        if label == nil {
            label = UILabel()
            label?.textAlignment = .center
        }
        if pickerView.tag == 0 {
            label?.font = .fontSFProDisplay(size: 23, family: .Medium)
            label?.text = self.totalDaysArray[row]
        } else {
            label?.font = .fontSFProDisplay(size: 23, family: .Bold)
            label?.text = "\((self.totalDaysPicker.selectedRow(inComponent: 0)+1)*10-row)일 실행"
        }
        return label!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            self.targetDaysPicker.reloadComponent(0)
        }
    }
}


