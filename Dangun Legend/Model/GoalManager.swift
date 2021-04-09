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
    
    func returnSuccessAndFail(daysArray: [SingleDayInfo]) -> [String : Int] {
        var successNumber = 0
        var failNumber = 0
        for day in daysArray {
            if day.success == true {
                successNumber += 1
            } else {
                failNumber += 1
            }
        }
        let analysis = [K.success:successNumber, K.fail:failNumber]
        return analysis
    }

    
    func daysArray(newGoal: GoalStruct) -> [SingleDayInfo] {
        var daysArray : [SingleDayInfo] = []

        let numOfDays = newGoal.numOfDays
        for i in 1...37 {
            let start = newGoal.startDate
            let date = Calendar.current.date(byAdding: .day, value: (i-1), to: start)!
            if i % 11 == 0 {
                let singleDay = SingleDayInfo(date: date, dayNum: i, success: false, userChecked: true)///추후삭제
                daysArray.append(singleDay)
            } else {
                let singleDay = SingleDayInfo(date: date, dayNum: i, success: true, userChecked: true)
                daysArray.append(singleDay)
            }
        }
        for i in 38...numOfDays {
            let start = newGoal.startDate
            let date = Calendar.current.date(byAdding: .day, value: (i-1), to: start)!
            let singleDay = SingleDayInfo(date: date, dayNum: i, success: false, userChecked: false)
            daysArray.append(singleDay)
        }
        return daysArray
    }
    
    
    //3번의 시도 후, 100일 중 98일의 실행으로 목표 달성 성공
    func historyGoalAnalysis(goal : GoalStruct) -> String {
        
        let distanceday = Calendar.current.dateComponents([.day], from: goal.startDate, to: Date()).day! as Int
        
        if goal.completed {
            //성공했을 때
            if goal.goalAchieved {
                if goal.trialNumber == 1 {
                    let analysis = "단 한번의 시도로, \(goal.numOfDays)일 중 \(goal.numOfSuccess)일의 실행으로 목표 달성 성공!"
                    return analysis
                } else {
                    let analysis = "\(goal.trialNumber)번의 시도 후, \(goal.numOfDays)일 중 \(goal.numOfSuccess)일의 실행으로 목표 달성 성공!"
                    return analysis
                }
            } else {
                let analysis = "\(goal.trialNumber)번의 시도 후, \(goal.numOfDays)일 중 \(goal.numOfSuccess)일의 실행으로 목표 달성 실패"
                return analysis
            }
        } else {
            if goal.trialNumber == 1 {
                let analysis = "\(goal.numOfDays)일 중 \(goal.numOfSuccess)일의 실행으로 목표 달성 진행중 - 첫번째 시도, \(distanceday+1)일째 "
                return analysis
            } else {
                let analysis = "\(goal.numOfDays)일 중 \(goal.numOfSuccess)일의 실행으로 목표 달성 진행중 - \(goal.trialNumber)번째 시도, \(distanceday+1)일째 "
                return analysis
            }
        }
    }
    
    
    func successCount(){
        var numOfsuccess = defaults.integer(forKey: K.crrNumOfSucc) as Int
        numOfsuccess += 1
        defaults.set(numOfsuccess, forKey: K.crrNumOfSucc)
    }
    
    func failCount(){
        var numOfFail = defaults.integer(forKey: K.crrNumOfFail) as Int
        numOfFail += 1
        defaults.set(numOfFail, forKey: K.crrNumOfFail)
    }
    
}

///Firebase & UserDefault
struct GoalStruct: Codable {
    let userID: String
    let goalID: String
    let startDate : Date
    let endDate: Date
    
    let failAllowance: Int
    let trialNumber : Int
    let description: String


    let numOfDays: Int
    let completed: Bool
    let goalAchieved: Bool
    
    let numOfSuccess : Int
    let numOfFail : Int
    let progress : Int
}

///Array로 UserDefault
struct SingleDayInfo: Codable {
    let date: Date
    let dayNum: Int
    var success: Bool
    var userChecked : Bool
}

/*
 
 [User Default Data]
 firstLaunch: true or false
 currentUser: 사용자 ID or NoOne
 goalExistence: true or false

    ->>>> 삭제-->>> currentGoal: encoded goal data

 currentDaysArray : encoded days Array
 crrGoalID : currentlyRunning Goal ID
 
 crrNumOfSucc:
 crrNumOfFail:

 
 
 
 
 [ToDoList]
- 히스토리 삭제 기능 추가
- DateManager, CaveAdd 테스트 가정들 전부 삭제
 
 */
