//
//  HistoryViewModel.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/05/18.
//

//
//@IBOutlet weak var goalDescriptionLabel: UILabel!
//@IBOutlet weak var goalResultLabel: UILabel!
//@IBOutlet weak var dateLabel: UILabel!
//@IBOutlet weak var progressLabel: UILabel!
//@IBOutlet weak var shareOutlet: UIButton!
//@IBAction func sharePressed(_ sender: Any) {
    
import Foundation
import RxSwift
import RxCocoa

struct HistoryListViewModel {
    var historyList: [HistoryViewModel]
    var goals = [Goal]()
    
    
    init(_ historyList: [Goal]) {
        self.historyList = historyList.compactMap(HistoryViewModel.init)
        self.goals = historyList
    }

    func historyAt(_ index: Int) -> HistoryViewModel {
        return self.historyList[index]
    }
    
    func historyEmpty() -> Observable<Bool> {
        return Observable.just(historyList.count)
            .map { $0 == 0 ? true : false}
    }
    
    mutating func clearHistory() {
        let newHistory = self.historyList.filter { $0.history.completed == false }
        self.historyList = newHistory
    }
    
}

struct HistoryViewModel {
    
    let history: Goal
    private let dateManager = DateManager()
    
    init(_ history: Goal) {
        self.history = history
    }
    
    var userID : Observable<String> {
        return Observable<String>.just(history.userID)
    }
    
    var goalID: Observable<String> {
        return Observable<String>.just(history.goalID)
    }
    
    var goalDescription: Observable<String> {
        return Observable<String>.just(history.description)
    }
    
    var dateDescription: Observable<String> {
        let startDate = dateManager.dateFormat(type: "yyyy년M월d일", date: history.startDate)
        let endDate = dateManager.dateFormat(type: "yyyy년M월d일", date: history.endDate)
        return Observable<String>.just("\(startDate) - \(endDate)")
    }
    
    var endDate: Observable<Date> {
        return Observable<Date>.just(history.endDate)
    }
    
    var numOfSuccess: Observable<Int> {
        return Observable<Int>.just(history.numOfSuccess)
    }
    
    var completed: Observable<Bool> {
        return Observable<Bool>.just(history.completed)
    }
    
    var progressLabel: Observable<GoalProgressStatus> {
        if history.completed && history.goalAchieved == true {
            return Observable<GoalProgressStatus>.just(GoalProgressStatus.success)
            
        } else if history.completed && history.goalAchieved == false {
            return Observable<GoalProgressStatus>.just(GoalProgressStatus.fail)
            
        } else {
            return Observable<GoalProgressStatus>.just(GoalProgressStatus.onProgress)
        }
    }

    var shareBoardButtonAppearance: Observable<ShareButtonAppearance> {
        let currentUserID = defaults.string(forKey: keyForDf.crrUser)!
        if history.userID == currentUserID && history.goalAchieved {
            if history.shared {
                return Observable<ShareButtonAppearance>.just(ShareButtonAppearance.unabled)
            } else {
                return Observable<ShareButtonAppearance>.just(ShareButtonAppearance.enabled)
            }
        } else {
            return Observable<ShareButtonAppearance>.just(ShareButtonAppearance.invisible)
        }
    }
    
}

struct UpperBoxGeneralInfoViewModel {
    let generalInfo : UsersGeneralInfo
    
    init(_ info: UsersGeneralInfo) {
        self.generalInfo = info
    }
    
    var successPerTrial : Observable<String> {
        let successPerTrialDescription = "총 \(generalInfo.totalTrial)번의 시도, \(generalInfo.totalAchievement)번의 목표달성에 성공"
        return Observable<String>.just(successPerTrialDescription)
    }
    
    var averageSuccessPerGoal : Observable<String> {
        var ability : Double {
            if generalInfo.totalSuccess == 0 || generalInfo.totalTrial == 0 {
                return 0
            } else {
                return Double(generalInfo.totalSuccess)/Double(generalInfo.totalTrial)
            }
        }
        let abilityString = String(format: "%.f", ability)
        let averageSuccessPerGoalDescription = "목표한 100일 중 평균 \(abilityString)일 성공"
        return Observable<String>.just(averageSuccessPerGoalDescription)
    }
    
    var successPerctage : Observable<String> {
        var ability : Double {
            if generalInfo.totalTrial == 0 || generalInfo.totalSuccess == 0 {
                return 0
            } else {
                return Double(generalInfo.totalSuccess)/Double(generalInfo.totalTrial)
            }
        }
        let abilityString = String(format: "%.1f", ability)
        return Observable<String>.just("나의 성공확률 \(abilityString)%")
        
    }
    
}
