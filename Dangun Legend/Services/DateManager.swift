//
//  DateManager.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/07.
//

import Foundation


class DateManager {

//    func subtractionDays(start: Date, end: Date) -> Int {
//        let a = Int(dateFormat(type: "yyyyMMdd", date: start))!
//        let b = Int(dateFormat(type: "yyyyMMdd", date: end))!
//        return b-a
//    }
    
    func howManyDaysBetween(start: Date, end: Date) -> Int {
        let distanceDay = Calendar.current.dateComponents([.day], from: start, to: end).day ?? 0
        return distanceDay
    }

    func yyMMddHHmmss_toDate(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMddHHmmss"
        if let aDate = dateFormatter.date(from: string) {
            return aDate
        } else {
            print("-->>> dateManager.dateFromString failed")
            return Date()
        }
    }
    
    func yyMMdd_toDate(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMdd"
        if let aDate = dateFormatter.date(from: string) {
            return aDate
        } else {
            print("-->>> dateManager.dateFromString failed")
            return Date()
        }
    }
    
    func dateFormat(type: String, dateComponets: DateComponents) -> String {
        let yearMonthDay = DateFormatter()
        yearMonthDay.dateFormat = "yyyy년M월d일"
        let monthDay = DateFormatter()
        monthDay.dateFormat = "M월d일"
        let whichDay = DateFormatter()
        whichDay.dateFormat = "e"
        let yearMonthDay2 = DateFormatter()
        yearMonthDay2.dateFormat = "yyyyMMdd"
        let yearToSeconds = DateFormatter()
        yearToSeconds.dateFormat = "yyMMddHHmmss"
        
        switch type {
        case "yearToSeconds":
            return yearToSeconds.string(from: (Calendar.current.date(from: dateComponets)!))
        case "yyyyMMdd":
            return yearMonthDay2.string(from: (Calendar.current.date(from: dateComponets)!))
        case "yyyy년M월d일":
            return yearMonthDay.string(from: (Calendar.current.date(from: dateComponets)!))
        case "M월d일":
            return monthDay.string(from: (Calendar.current.date(from: dateComponets)!))
        case "e":
            let whatDay = whichDay.string(from: (Calendar.current.date(from: dateComponets)!))
            switch whatDay {
            case "1": return "월요일"
            case "2": return "화요일"
            case "3": return "수요일"
            case "4": return "목요일"
            case "5": return "금요일"
            case "6": return "토요일"
            default: return "일요일"
            }
        default:
            return ""
        }
    }
    
    func dateFormat(type: String, date: Date) -> String {
        
        let yearMonthDay = DateFormatter()
        yearMonthDay.dateFormat = "yyyy년M월d일"
        let monthDay = DateFormatter()
        monthDay.dateFormat = "M월d일"
        let whichDay = DateFormatter()
        whichDay.dateFormat = "e"
        let yearMonthDay2 = DateFormatter()
        yearMonthDay2.dateFormat = "yyyyMMdd"
        let yearMonthDay3 = DateFormatter()
        yearMonthDay3.dateFormat = "yyyy-MM-dd"
        let yearToSeconds = DateFormatter()
        yearToSeconds.dateFormat = "yyMMddHHmmss"
        
        let mmdd = DateFormatter()
        mmdd.dateFormat = "MM월dd일"
            
        switch type {
        case "yyyy-MM-dd":
            return yearMonthDay3.string(from: date)
        case "yyyyMMdd":
            return yearMonthDay2.string(from: date)
        case "yyyy년M월d일":
            return yearMonthDay.string(from :date)
        case "M월d일":
            return monthDay.string(from: date)
        case "yearToSeconds":
            return yearToSeconds.string(from: date)
            
        case "MM월dd일" :
            return mmdd.string(from: date)
            
        case "e":
            let whatDay = whichDay.string(from: date)
            switch whatDay {
            case "1": return "월요일"
            case "2": return "화요일"
            case "3": return "수요일"
            case "4": return "목요일"
            case "5": return "금요일"
            case "6": return "토요일"
            default: return "일요일"
            }
        default:
            return ""
        }
  
    }
}
