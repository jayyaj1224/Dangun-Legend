//
//  DateManager.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/07.
//

import Foundation


class DateManager {

    func dateFormat(type: String, dateComponets: DateComponents) -> String {
        let yearMonthDay = DateFormatter()
        yearMonthDay.dateFormat = "yyyy년M월d일"
        let monthDay = DateFormatter()
        monthDay.dateFormat = "M월d일"
        let whichDay = DateFormatter()
        whichDay.dateFormat = "e"
        let yearMonthDay2 = DateFormatter()
        yearMonthDay2.dateFormat = "yyyyMMdd"
        switch type {
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
        let yearMonthDay4 = DateFormatter()
        yearMonthDay4.dateFormat = "yyMMddHHmmss"
            
        switch type {
        case "yyyy-MM-dd":
            return yearMonthDay3.string(from: date)
        case "yyyyMMdd":
            return yearMonthDay2.string(from: date)
        case "yyyy년M월d일":
            return yearMonthDay.string(from :date)
        case "M월d일":
            return monthDay.string(from: date)
        case "yyMMddHHmmss":
            return yearMonthDay4.string(from: date)
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
