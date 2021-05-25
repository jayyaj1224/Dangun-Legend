
//  CreateNewGoalViewModel.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/05/17.
//

import Foundation
import RxSwift
import RxCocoa



struct CaveViewModel {
    let totalGoalInfo: TotalGoalInfoModel!

    let goalVM: GoalViewModel
    let collectionViewVM: DaysViewModel

    init(_ totalGoalInfo: TotalGoalInfoModel) {
        self.totalGoalInfo = totalGoalInfo
        self.goalVM = GoalViewModel.init(totalGoalInfo.goal)
        self.collectionViewVM = DaysViewModel.init(totalGoalInfo.days)
    }
}


struct GoalViewModel {
    var goal : GoalModel!

    init(_ goal: GoalModel) {
        self.goal = goal
    }

    var description: Observable<String> {
        return Observable<String>.just(goal.description)
    }

    mutating func countSuccess(completion: ()->()){
        var newGoal = self.goal
        newGoal?.numOfSuccess += 1
        self.goal = newGoal
        completion()
    }

    mutating func countFail(completion: ()->()){
        var newGoal = self.goal
        newGoal?.numOfFail += 1
        self.goal = newGoal
        completion()
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

    init(_ daysInfo: [DayModel]) {
        self.daysInfoVM = daysInfo.compactMap(SingleDayViewModel.init)
    }

    func singleDayAt(index: Int) -> SingleDayViewModel {
        return self.daysInfoVM[index]
    }

    func todayAt()->Int {
        let date = DateManager().dateFormat(type: "yyyyMMdd", date: Date())
        let todayInArr = daysInfoVM.filter{ $0.singleDayInfo.date == date }
        let todayDayNum = todayInArr.first?.singleDayInfo.dayIndex ?? 0
        return todayDayNum
    }

    var todayIsCheckedBool: Observable<Bool> {
        let todayDaynum = todayAt()
        if self.daysInfoVM[todayDaynum-1].singleDayInfo.status == Status.none {
            return Observable<Bool>.just(false)
        } else {
            return Observable<Bool>.just(true)
        }
    }

    mutating func updateSuccess(index: Int, completion: ()->()) {
        var newDaysInfo = self.daysInfoVM
        newDaysInfo[index].singleDayInfo.status = Status.success
        self.daysInfoVM = newDaysInfo
        completion()
    }

    mutating func updateFail(index: Int, completion: ()->()) {
        var newDaysInfo = self.daysInfoVM
        newDaysInfo[index].singleDayInfo.status = Status.fail
        self.daysInfoVM = newDaysInfo
        completion()
    }

}



struct SingleDayViewModel {

    var singleDayInfo : DayModel

    private let dateManager = DateManager()

    init(_ singleDay: DayModel) {
        self.singleDayInfo = singleDay
    }

    var todayStatus : Observable<DaySquareStatus.Today> {
        switch self.singleDayInfo.status {
        case .fail:
            return Observable<DaySquareStatus.Today>.just(DaySquareStatus.Today.failed)
        case .success:
            return Observable<DaySquareStatus.Today>.just(DaySquareStatus.Today.success)
        case .none:
            return Observable<DaySquareStatus.Today>.just(DaySquareStatus.Today.unchecked)
        }
    }

    var pastStatus : Observable<DaySquareStatus.Past> {
        switch self.singleDayInfo.status {
        case .fail:
            return Observable<DaySquareStatus.Past>.just(DaySquareStatus.Past.failed)
        case .success:
            return Observable<DaySquareStatus.Past>.just(DaySquareStatus.Past.success)
        case .none:
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


