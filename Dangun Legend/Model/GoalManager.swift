//
//  GoalManager.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/05.
//

import Foundation
import UIKit

class GoalManager {
    
    let dateManager = DateManager()
    
    func daysArray(newGoal: GoalStruct) -> [SingleDayInfo] {
        var daysArray : [SingleDayInfo] = []
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyyMMdd"
        let numOfDays = newGoal.numOfDays
        for i in 1...numOfDays {
            let start = newGoal.startDate
            let date = DateComponents(year: start.year, month: start.month, day: start.day!+(i-1))
//            let date = Calendar.current.date(from: dayAfter)!
//            let theDate = formatter.string(from: date)
            let singleDay = SingleDayInfo(date: date, dayNum: i, success: false, userChecked: false)
            daysArray.append(singleDay)
        }
        return daysArray
    }
    
    
    //3번의 시도 후, 100일 중 98일의 실행으로 목표 달성 성공
    func historyGoalAnalysis(goal : GoalStruct) -> String {
        
        let startDate = Calendar.current.date(from: goal.startDate) ?? Date()
        let distanceday = Calendar.current.dateComponents([.day], from: startDate, to: Date()).day! as Int
        
        if goal.completed {
            //성공했을 때
            if goal.success {
                if goal.trialNumber == 1 {
                    let analysis = "단 한번의 시도로, \(goal.numOfDays)일 중 \(goal.executedDays)일의 실행으로 목표 달성 성공!"
                    return analysis
                } else {
                    let analysis = "\(goal.trialNumber)번의 시도 후, \(goal.numOfDays)일 중 \(goal.executedDays)일의 실행으로 목표 달성 성공!"
                    return analysis
                }
            } else {
                let analysis = "\(goal.trialNumber)번의 시도 후, \(goal.numOfDays)일 중 \(goal.executedDays)일의 실행으로 목표 달성 실패"
                return analysis
            }
        } else {
            if goal.trialNumber == 1 {
                let analysis = "\(goal.numOfDays)일 중 \(goal.executedDays)일의 실행으로 목표 달성 진행중 - 첫번째 시도, \(distanceday+1)일째 "
                return analysis
            } else {
                let analysis = "\(goal.numOfDays)일 중 \(goal.executedDays)일의 실행으로 목표 달성 진행중 - \(goal.trialNumber)번째 시도, \(distanceday+1)일째 "
                return analysis
            }
        }
    }
    
    
}
struct GoalStruct: Codable {
    let userID: String
    let goalID: String
    let executedDays : Int
    let trialNumber : Int
    let description: String
    let startDate : DateComponents
    let endDate: DateComponents
    let failAllowance: Int
    let numOfDays: Int
    let completed: Bool
    let success: Bool
}

struct SingleDayInfo: Codable {
    let date: DateComponents
    let dayNum: Int
    var success: Bool
    var userChecked : Bool
}

