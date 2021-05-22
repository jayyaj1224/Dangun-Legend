//
//  CaveAddViewController.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/03.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import RxSwift
import RxCocoa


//protocol GoalUIManagerDelegate {
//    func newGoalAddedUpdateView(_ data: Goal)
//    func newGoalAddedUpdateViewForTest(_ data: Goal)
//    func didFailwithError(error: Error)
//}

class AddNewGoalViewController: UIViewController{

    private let dateManager = DateManager()
    private let goalManager = GoalManager()
    private let dataManager = DataManager()
    
    private let disposeBag = DisposeBag()
    
    //static var delegate : GoalUIManagerDelegate?

    private var newGoalSubject = PublishSubject<TotalGoalInfo>()
    
    var newGoalSubjectObservable: Observable<TotalGoalInfo> {
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
        if goalTextView.text != "" && goalTextView.text != "도전하고 싶은 목표를 적어주세요." {
            self.createNewGoal()
        } else {
            let alert = UIAlertController.init(title: "목표 미입력", message: "목표를 입력해주세요 :-)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    private func createNewGoal() {
        let userInput = UsersInputForNewGoal(goalDescripteion: self.goalTextView.text, failAllowance: self.failAllowOutput.selectedSegmentIndex)
        
        ///let totalGoalInfo = self.goalManager.createNewGoal(userInput)
        let totalGoalInfo = self.goalManager.createNewGoalFORTEST()
        ///TESTING
        self.newGoalSubject.onNext(totalGoalInfo)
        self.dataManager.saveNewGoalOnFS(totalGoalInfo)
        
        dismiss(animated: true, completion: nil)
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
        let startDateString = dateManager.dateFormat(type: "yyyy-MM-dd", date: Date())
        let lastDate = Calendar.current.date(byAdding: .day, value: 99, to: Date())!
        let lastDateString = dateManager.dateFormat(type: "yyyy-MM-dd", date: lastDate)
        DispatchQueue.main.async {
            self.startDate.text = startDateString
            self.endDate.text = lastDateString
        }
    }
    
}
