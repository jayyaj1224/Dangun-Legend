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
        let update = defaults.integer(forKey: UserInfoKey.totalSuccess)+1
        defaults.set(update,forKey: UserInfoKey.totalSuccess)
    }
    
    func oneMoreFail(){
        let update = defaults.integer(forKey: UserInfoKey.totalFail)+1
        defaults.set(update,forKey: UserInfoKey.totalFail)
    }
    
    func oneMoreAchievement(){
        let update = defaults.integer(forKey: UserInfoKey.totalAchievements)+1
        defaults.set(update,forKey: UserInfoKey.totalAchievements)
    }
    
    func oneMoreTrial(){
        let update = defaults.integer(forKey: UserInfoKey.totalTrial)+1
        defaults.set(update,forKey: UserInfoKey.totalTrial)
    }
    
    

}
