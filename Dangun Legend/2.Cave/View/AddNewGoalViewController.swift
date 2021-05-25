//
//  AddNewGoalViewController.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/05/25.
//


import UIKit
import IQKeyboardManagerSwift
import Firebase
import RxSwift
import RxCocoa



class AddNewGoalViewController: UIViewController{

    private let goalManager = GoalManager()
    private let disposeBag = DisposeBag()
    
    private let userDefaultService = UserDefaultService()

    private var newGoalSubject = PublishSubject<TotalGoalInfoModel>()
    
    var newGoalSubjectObservable: Observable<TotalGoalInfoModel> {
        return self.newGoalSubject.asObservable()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goalTextView.delegate = self
        self.setupDateDescription()
        self.bindTextField()
    }

    @IBOutlet weak var goalTextView: UITextView!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var goalTextFieldMirror: UITextView!
    @IBOutlet weak var failAllowOutput: UISegmentedControl!
  
    @IBAction func backPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    private func bindTextField(){
        goalTextView.becomeFirstResponder()
        goalTextView.rx.text
            .bind(to: self.goalTextFieldMirror.rx.text)
            .disposed(by: disposeBag)
    }


    @IBAction func startPressed(_ sender: UIButton) {
        if goalTextView.text == "" && goalTextView.text == "도전하고 싶은 목표를 적어주세요." {
            let alert = UIAlertController.init(title: "목표 미입력", message: "목표를 입력해주세요 :-)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            
            self.createNewGoal()
        }
    }
    
    private func createNewGoal() {
        let fireStore = FireStoreService()
        let userInput = UsersInputForNewGoal(goalDescripteion: self.goalTextView.text, failAllowance: self.failAllowOutput.selectedSegmentIndex)
       
        var totalGoalInfo : TotalGoalInfoModel {
            return self.goalManager.createNewGoal(userInput)
        }
        
        self.newGoalSubject.onNext(totalGoalInfo)
        dismiss(animated: true, completion: nil)
        

        // Firestore에 저장
        fireStore.saveGoal(totalGoalInfo.goal)
        fireStore.saveDaysInfo(totalGoalInfo.days)
        fireStore.userInfoOneMoreTrial()
        
        // UserDefault 에 저장
        userDefaultService.userDefaultSettingForNewGoal(goal: totalGoalInfo.goal)
        
    }
    
 
}


extension AddNewGoalViewController: UITextViewDelegate {
    
    // TextView Place Holder
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray {
            textView.text = nil
            textView.textColor = UIColor.systemGray
        }
        
    }
    // TextView Place Holder
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "도전하고 싶은 목표를 적어주세요."
            textView.textColor = UIColor.systemGray
        }
    }
    
}


extension AddNewGoalViewController {
    
    private func setupDateDescription() {
        let dateManager = DateManager()
        let startDateString = dateManager.dateFormat(type: "yyyy-MM-dd", date: Date())
        let lastDate = Calendar.current.date(byAdding: .day, value: 99, to: Date())!
        let lastDateString = dateManager.dateFormat(type: "yyyy-MM-dd", date: lastDate)
        DispatchQueue.main.async {
            self.startDate.text = startDateString
            self.endDate.text = lastDateString
        }
    }
    
}
