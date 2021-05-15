//
//  BoardModel.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/05/15.
//

import Foundation


struct BoardList {
    let boardList : [Board]
    
}

struct Board {
    let achievementTitle: String
    let goal: String
    let badgeAppearance: Bool
    let achievmentDescription: String
    let date: String
}
