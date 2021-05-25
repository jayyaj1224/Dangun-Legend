//
//  CoreDataService.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/05/24.
//

import Foundation
import UIKit
import CoreData


struct CoreDataService {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
//MARK: - Create
    
    func saveGoalInfo(_ goal: GoalModel){
        let newGoalData = GoalData(context: context)
        newGoalData.endDate = goal.endDate
        newGoalData.startDate = goal.startDate
        newGoalData.shared = goal.shared
        newGoalData.goalDescription = goal.description
        newGoalData.failNum = Int64(goal.numOfFail)
        newGoalData.successNum = Int64(goal.numOfSuccess)
        newGoalData.goalID = goal.goalID
        newGoalData.userID = goal.userID
        newGoalData.status = goal.status.rawValue
        newGoalData.failAllowance = Int64(goal.failAllowance)
        do {
            try context.save()
        } catch {
            print("CoreDataService: couldn't save new goal info")
        }
    }
    
    
    func saveDayInfo(_ dayModelArray: [DayModel]){
        for dayModel in dayModelArray {
            let newDayData = DayData(context: context)
            newDayData.date = dayModel.date
            newDayData.index = Int64(dayModel.dayIndex)
            newDayData.status = dayModel.status.rawValue
            do {
                try context.save()
            } catch {
                print("CoreDataService: couldn't save new day info")
            }
        }
    }
    
    
    
    



//MARK: - Load




    func loadGoal(completion: @escaping (GoalModel)->()) {
        do {
            let request = GoalData.fetchRequest() as NSFetchRequest<GoalData>
            let goalData = try context.fetch(request).first!
            let goalModel = self.goalModelConversion(goalData)
            completion(goalModel)
        }
        catch {
            print("CoreDataService: couldn't load goal info")
        }
        
    }
    
    
    func loadDays(completion: @escaping ([DayModel])->()){
        do{
            
            let request = DayData.fetchRequest() as NSFetchRequest<DayData>
            let dayDataArray = try context.fetch(request)
            
            let serialQueue = DispatchQueue.init(label: "serialQueue")
            var dayModelArray = [DayModel]()
            
            serialQueue.async {
                for dayData in dayDataArray {
                    let newday = DayModel(dayIndex: Int(dayData.index), status: Status(rawValue: dayData.status!)!, date: dayData.date!)
                    dayModelArray.append(newday)
                }
            }
            serialQueue.async {
                completion(dayModelArray)
            }
        }
        catch {
            print("CoreDataService: couldn't load days info")
        }
        
    }
    

//do {
//    let request = Person.fetchRequest() as NSFetchRequest<Person>
//
////            let pred = NSPredicate(format: "name CONTAINS 'Ted'")
////            let pred = NSPredicate(format: "name CONTAINS %@", "Ted")
////            request.predicate = pred
//
//
////            let sort = NSSortDescriptor(key: "name", ascending: true)
////            request.sortDescriptors = [sort]
////
////
//    self.items = try context.fetch(request)
////            self.items = try context.fetch(Person.fetchRequest())
//
//
//    DispatchQueue.main.async {
//        self.tableVIew.reloadData()
//    }
//}
//catch {
//
//}



//MARK: - Update
    
    func updateDayData(index: Int, bool: Bool){
        let index64 = Int64(index)
        
        let request = DayData.fetchRequest() as NSFetchRequest<DayData>
        let pred = NSPredicate(format: "index CONTAINS %@", "\(index64)")
        
        request.predicate = pred
        
        let dayDataArr = try! context.fetch(request)
        
        var status : String {
            if bool {
                return Status.success.rawValue
            } else {
                return Status.fail.rawValue
            }
        }
        
        dayDataArr[0].status! = status
        
        try! context.save()
    }







//MARK: - Delete


    
    func deletData(_ entity:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                context.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
    
}





extension CoreDataService {
    
    private func goalModelConversion(_ goalData: GoalData) -> GoalModel {
        
        let failAllwnc = Int(goalData.failAllowance)
        let sucNum = Int(goalData.successNum)
        let failNum = Int(goalData.failNum)
        let shared = goalData.shared
        
        guard let userID = goalData.userID,
              let goalID = goalData.goalID,
              let start = goalData.startDate,
              let end = goalData.endDate,
              let descr = goalData.goalDescription,
              let goalDataStatus = goalData.status
        else {
            fatalError("data load failed")
        }
        
        let status = Status(rawValue: goalDataStatus) ?? Status.none
              
        let newGoal = GoalModel(userID: userID, goalID: goalID, startDate: start, endDate: end, failAllowance: failAllwnc, description: descr, status: status , numOfSuccess: sucNum, numOfFail: failNum, shared: shared)
        
        return newGoal
    }
    
}
