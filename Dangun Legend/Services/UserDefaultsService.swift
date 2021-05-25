//
//  UserDefaultsService.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/05/25.
//

import Foundation


struct UserDefaultService {

//    private let encoder = JSONEncoder()
//    private let decoder = JSONDecoder()
//
//    func encodingSaveAtUserDefault<T: Codable>(data: T, key: String) {
//        if let encoded = try? encoder.encode(data) {
//            defaults.set(encoded, forKey: key)
//        }
//    }
//
//    func decodingLoadFromUserDefault<T: Codable>(key: String, completion: @escaping (T)->()){
//        if let data = defaults.data(forKey: key) {
//            if let decoded = try? decoder.decode(T.self, from: data) {
//                completion(decoded)
//            }
//        }
//    }
    
    func oneMoreSuccess(){
        let update = defaults.integer(forKey: KeyForDf.totalSuccess)+1
        defaults.set(update,forKey: KeyForDf.totalSuccess)
    }
    
    func oneMoreFail(){
        let update = defaults.integer(forKey: KeyForDf.totalFail)+1
        defaults.set(update,forKey: KeyForDf.totalFail)
    }
    
    func oneMoreAchievement(){
        let update = defaults.integer(forKey: KeyForDf.totalAchievements)+1
        defaults.set(update,forKey: KeyForDf.totalAchievements)
    }
    
    func oneMoreTrial(){
        let update = defaults.integer(forKey: KeyForDf.totalTrial)+1
        defaults.set(update,forKey: KeyForDf.totalTrial)
    }
    
    

}
