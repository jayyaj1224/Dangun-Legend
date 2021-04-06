//
//  GoalManager.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/05.
//

import Foundation
import UIKit

class DaysViewModel {
    
    
    func daysArray(newGoal: NewGoal) -> [SingleDayInfo] {
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
    
}
struct NewGoal: Codable {
    let userID: String
    let goalID: String
    let trialNumber : Int
    let description: String
    let startDate : DateComponents
    let endDate: DateComponents
    let failAllowance: Int
    let numOfDays: Int
}

struct SingleDayInfo: Codable {
    let date: DateComponents
    let dayNum: Int
    var success: Bool
    var userChecked : Bool
}

