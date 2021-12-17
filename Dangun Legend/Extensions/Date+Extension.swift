//
//  Date+Extension.swift
//  Dangun Legend
//
//  Created by Lee Jong Yun on 2021/12/17.
//

import Foundation

extension Date {
    var asString: DateToString {
        return DateToString.init(self)
    }
    
    func stringToDate(string: String, format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: string)
    }
    
    func yyMMddHHmmss_toDate(string: String) -> Date? {
        return self.stringToDate(string: string, format: "yyMMddHHmmss")
    }
    
    func asIdentifier_toDate(string: String) -> Date? {
        return self.stringToDate(string: string, format: "yyMMddHHmmss")
    }
    
    func yyMMdd_toDate(string: String) -> Date? {
        return self.stringToDate(string: string, format: "yyMMdd")
    }
    
    var daysLeftFromToday: Int {
        let distanceDay = Calendar.current.dateComponents([.day], from: Date(), to: self).day ?? 0
        return distanceDay
    }
    
    func add(_ adding: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: adding, to: self)!
    }
}

public struct DateToString {
    var date: Date
    
    init(_ date: Date) {
        self.date = date
    }
    func format(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    var yyyy년M월d일: String {
        return self.format("yyyy년M월d일")
    }
    var M월d일: String {
        return self.format("M월d일")
    }
    var e요일: String {
        let dayNumber = self.format("e")
        switch dayNumber {
        case "1": return "월요일"
        case "2": return "화요일"
        case "3": return "수요일"
        case "4": return "목요일"
        case "5": return "금요일"
        case "6": return "토요일"
        default: return "일요일"
        }
    }
    var yyyyMMdd: String {
        return self.format("yyyyMMdd")
    }
    var yyyy_MM_dd: String {
        return self.format("yyyy_MM_dd")
    }
    var yyMMddHHmmss: String {
        return self.format("yyMMddHHmmss")
    }
    var identifier: String {
        return "DG_GOAL_IDENTIFIER_" + self.format("yyMMddHHmmss")
    }
}
