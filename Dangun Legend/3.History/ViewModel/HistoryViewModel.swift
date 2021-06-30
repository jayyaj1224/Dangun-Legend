//
//  HistoryViewModel.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/05/18.
//

    
import Foundation
import RxSwift
import RxCocoa

class HistoryListViewModel {
    var historyList: [HistoryViewModel]
    var goals = [GoalModel]()
    
    
    init(_ historyList: [GoalModel]) {
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
    
    func clearHistory() {
        let newHistory = self.historyList.filter { $0.history.status == Status.none }
        self.historyList = newHistory
    }
    
}

enum ShareButtonAppearance {
    case invisible
    case enabled
    case unabled
}

class HistoryViewModel {
    
    let history: GoalModel
    private let dateManager = DateCalculate()
    
    init(_ history: GoalModel) {
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
    
    var status: Observable<Status> {
        return Observable<Status>.just(history.status)
    }
    
    var progressLabel: Observable<Status> {
        if history.status == Status.success {
            return Observable<Status>.just(Status.success)
            
        } else if history.status == Status.fail {
            return Observable<Status>.just(Status.fail)
            
        } else {
            return Observable<Status>.just(Status.none)
        }
    }

    var shareBoardButtonAppearance: Observable<ShareButtonAppearance> {
        let currentUserID = defaults.string(forKey: UDF.userID)!
        if history.userID == currentUserID && history.status == Status.success {
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

class UpperBoxGeneralInfoViewModel {
    let generalInfo : UserInfoModel
    
    init(_ info: UserInfoModel) {
        self.generalInfo = info
    }
    
    var successPerTrial : Observable<String> {
        var totalTrial : Int {
            return generalInfo.totalTrial <= 0 ? 0 : generalInfo.totalTrial
        }
        
        var totalAchievement : Int {
            return generalInfo.totalAchievements <= 0 ? 0 : generalInfo.totalAchievements
        }
        
        let successPerTrialDescription = "총 \(totalTrial)번의 시도, \(totalAchievement)번의 목표달성에 성공"
        return Observable<String>.just(successPerTrialDescription)
    }

    var averageSuccessPerGoal : Observable<String> {
        var ability : Double {
            if generalInfo.totalSuccess <= 0 || generalInfo.totalTrial <= 0 {
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
            if generalInfo.totalTrial <= 0 || generalInfo.totalSuccess <= 0 {
                return 0
            } else {
                return Double(generalInfo.totalSuccess)/Double(generalInfo.totalTrial)
            }
        }
        let abilityString = String(format: "%.1f", ability)
        return Observable<String>.just("나의 성공확률 \(abilityString)%")
    }
    
}

