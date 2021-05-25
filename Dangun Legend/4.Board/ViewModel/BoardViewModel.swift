//
//  BoardViewModel.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/05/15.
//

import Foundation
import RxSwift
import RxCocoa



struct BoardListViewModel {
    private let boardList: [BoardViewModel]
    let count : Int
    
    init(_ goalStructForBoardArr: [BoardData]) {
        self.boardList = goalStructForBoardArr.compactMap(BoardViewModel.init)
        self.count = goalStructForBoardArr.count
    }
    
    func achievementAt(_ index: Int) -> BoardViewModel {
        return self.boardList[index]
    }
}


struct BoardViewModel {
    
    private let achievement: Achievement
    
    init(_ goal: BoardData) {
        let startDate = DateCalculate().dateFormat(type: "yyyy년M월d일", date: goal.startDate)
        let endDate = DateCalculate().dateFormat(type: "yyyy년M월d일", date: goal.endDate)
        let title = "\(goal.nickName) 님의 업적"
        let goalDescription = goal.description
        let numOfSuccess = goal.numOfSuccess
        let date = "\(startDate) - \(endDate)"
        let userID = goal.userID
        let goalID = goal.goalID
        
        let achievement = Achievement(title: title, goal: goalDescription, numOfSuccess: numOfSuccess, date: date, userID: userID, goalID: goalID)
        
        self.achievement = achievement
    }
    
    
    var title: Observable<String> {
        return Observable<String>.just(achievement.title)
    }
    
    var goal: Observable<String> {
        return Observable<String>.just(achievement.goal)
    }
    
    var numOfSuccess: Observable<Int> {
        return Observable<Int>.just(achievement.numOfSuccess)
    }
    
    var date: Observable<String> {
        return Observable<String>.just(achievement.date)
    }
    
    var userID: Observable<String> {
        return Observable<String>.just(achievement.userID)
    }
    
    var goalID: Observable<String> {
        return Observable<String>.just(achievement.goalID)
    }
    
}

