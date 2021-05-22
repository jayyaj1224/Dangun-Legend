//
//  CreateNewGoalViewModel.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/05/17.
//

import Foundation
import RxSwift
import RxCocoa

struct CaveViewModel {
    let totalGoalInfo: TotalGoalInfo!

    let goalVM: GoalViewModel
    let collectionViewVM: DaysViewModel

    init(_ totalGoalInfo: TotalGoalInfo) {
        self.totalGoalInfo = totalGoalInfo
        self.goalVM = GoalViewModel.init(totalGoalInfo.goal)
        self.collectionViewVM = DaysViewModel.init(totalGoalInfo.days)
    }
}


struct GoalViewModel {
    var goal : Goal!

    init(_ goal: Goal) {
        self.goal = goal
    }
    
    var description: Observable<String> {
        return Observable<String>.just(goal.description)
    }
    
    mutating func countSuccess(completion:(Goal)->()){
        var newGoal = self.goal
        newGoal?.numOfSuccess += 1
        self.goal = newGoal
        print("newGoal: ***** \(self.numbersOfSuccessAndFail)")
        completion(newGoal!)
    }
    
    mutating func countFail(completion:(Goal)->()){
        var newGoal = self.goal
        if goal.failAllowance-1 == goal.numOfFail {
            ///%%%%%%%%%%%%%%%%%%%%
        }
        newGoal?.numOfFail += 1
        self.goal = newGoal
        print("newGoal: ***** \(self.numbersOfSuccessAndFail)")
        completion(newGoal!)
    }
    
    
    var datePeriod : Observable<String> {
        let dateManager = DateManager()
        let start = dateManager.dateFormat(type: "yyyy년M월d일", date: goal.startDate)
        let end = dateManager.dateFormat(type: "yyyy년M월d일", date: goal.endDate)
        let period = "기간: \(start) - \(end)"
        return Observable<String>.just(period)
    }
    
    var numbersOfSuccessAndFail : Observable<String> {
        let description = "\(goal.numOfSuccess)일 실행 성공 / \(goal.numOfFail)일 불이행"
        return Observable<String>.just(description)
    }
    
    var leftFailAllowancd : Observable<Int> {
        let leftChance = goal.failAllowance-goal.numOfFail+1
        return Observable<Int>.just(leftChance)
    }
    
    var leftDays : Observable<String> {
        let daysPast = Calendar.current.dateComponents([.day], from: goal.startDate, to: Date()).day! as Int
        let description = "\(100-daysPast-1)일"
        return Observable<String>.just(description)
    }

}


struct DaysViewModel {
    
    var daysInfoVM: [SingleDayViewModel]
    
    init(_ daysInfo: [SingleDayInfo]) {
        self.daysInfoVM = daysInfo.compactMap(SingleDayViewModel.init)
    }
    
    func singleDayAt(index: Int) -> SingleDayViewModel {
        return self.daysInfoVM[index]
    }
    
    func todayAt()->Int {
        let date = DateManager().dateFormat(type: "yyyyMMdd", date: Date())
        let todayInArr = daysInfoVM.filter{ $0.singleDayInfo.date == date }
        let todayDayNum = todayInArr.first?.singleDayInfo.dayNum ?? 0
        return todayDayNum
    }
    
    var todayIsCheckedBool: Observable<Bool> {
        let todayDaynum = todayAt()
        if self.daysInfoVM[todayDaynum-1].singleDayInfo.status == DayStatus.unchecked {
            return Observable<Bool>.just(false)
        } else {
            return Observable<Bool>.just(true)
        }
    }
    
    mutating func updateSuccess(index: Int, completion:([SingleDayInfo])->()) {
        var newDaysInfo = self.daysInfoVM
        newDaysInfo[index].singleDayInfo.status = DayStatus.success
        self.daysInfoVM = newDaysInfo
        let daysArr = newDaysInfo.map { $0.singleDayInfo }
        print("daysArr: ***** \(daysArr[index])")
        completion(daysArr)
    }
    
    mutating func updateFail(index: Int, completion:([SingleDayInfo])->()) {
        var newDaysInfo = self.daysInfoVM
        newDaysInfo[index].singleDayInfo.status = DayStatus.fail
        self.daysInfoVM = newDaysInfo
        let daysArr = newDaysInfo.map { $0.singleDayInfo }
        print("daysArr: ***** \(daysArr[index])")
        completion(daysArr)
    }
    
}



struct SingleDayViewModel {
    
    var singleDayInfo : SingleDayInfo
    
    private let dateManager = DateManager()
        
    init(_ singleDay: SingleDayInfo) {
        self.singleDayInfo = singleDay
    }
    
    var todayStatus : Observable<DaySquareStatus.Today> {
        switch self.singleDayInfo.status {
        case .fail:
            return Observable<DaySquareStatus.Today>.just(DaySquareStatus.Today.failed)
        case .success:
            return Observable<DaySquareStatus.Today>.just(DaySquareStatus.Today.success)
        case .unchecked:
            return Observable<DaySquareStatus.Today>.just(DaySquareStatus.Today.unchecked)
        }
    }
    
    var pastStatus : Observable<DaySquareStatus.Past> {
        switch self.singleDayInfo.status {
        case .fail:
            return Observable<DaySquareStatus.Past>.just(DaySquareStatus.Past.failed)
        case .success:
            return Observable<DaySquareStatus.Past>.just(DaySquareStatus.Past.success)
        case .unchecked:
            return Observable<DaySquareStatus.Past>.just(DaySquareStatus.Past.unchecked)
        }
    }
    
    var futureStatus : Observable<DaySquareStatus> {
        return Observable<DaySquareStatus>.just(DaySquareStatus.future)
    }
    
}

enum DaySquareStatus {
    
    enum Today {
        case failed
        case success
        case unchecked
    }
    
    enum Past {
        case failed
        case success
        case unchecked
    }
    
    case future
}




//    if let savedData = defaults.object(forKey: keyForDf.crrGoal) as? Data {
//        let numOfSuccess = defaults.integer(forKey: keyForDf.crrNumOfSucc)
//        let numOfFail = defaults.integer(forKey: keyForDf.crrNumOfFail)
//        let decoder = JSONDecoder()
//        if let data = try? decoder.decode(Goal.self, from: savedData) {
//            self.currentGoal = data
//            let leftChance = data.failAllowance - numOfFail
//            let daysPast = Calendar.current.dateComponents([.day], from: data.startDate, to: Date()).day! as Int
//            let start = dateManager.dateFormat(type: "yyyy년M월d일", date: data.startDate)
//            let end = dateManager.dateFormat(type: "yyyy년M월d일", date: data.endDate)
//            DispatchQueue.main.async {
//                self.dateLabel.text = "기간: \(start) - \(end)"
//            }


//    var daySquareStatus : Observable<DaySquareStatus> {
//        if self.singleDayInfo.date == today {
//            switch self.singleDayInfo.status {
//            case DayStatus.failed:
//                return Observable<DaySquareStatus>.just(DaySquareStatus.todayFailed)
//            case DayStatus.success:
//                return Observable<DaySquareStatus>.just(DaySquareStatus.todaySucessed)
//            case DayStatus.unchecked:
//                return Observable<DaySquareStatus>.just(DaySquareStatus.todayUnchecked)
//            }
//        } else if self.singleDayInfo.date < today {
//            switch self.singleDayInfo.status {
//            case DayStatus.failed:
//                return Observable<DaySquareStatus>.just(DaySquareStatus.failed)
//            case DayStatus.success:
//                return Observable<DaySquareStatus>.just(DaySquareStatus.success)
//            case DayStatus.unchecked:
//                return Observable<DaySquareStatus>.just(DaySquareStatus.unchecked)
//            }
//        } else {
//            return Observable<DaySquareStatus>.just(DaySquareStatus.unchecked)
//        }
//    }
