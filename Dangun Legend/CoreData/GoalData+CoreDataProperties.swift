//
//  GoalData+CoreDataProperties.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/05/25.
//
//

import Foundation
import CoreData


extension GoalData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GoalData> {
        return NSFetchRequest<GoalData>(entityName: "GoalData")
    }

    @NSManaged public var endDate: Date?
    @NSManaged public var failAllowance: Int64
    @NSManaged public var failNum: Int64
    @NSManaged public var goalDescription: String?
    @NSManaged public var goalID: String?
    @NSManaged public var shared: Bool
    @NSManaged public var startDate: Date?
    @NSManaged public var successNum: Int64
    @NSManaged public var userID: String?
    @NSManaged public var status: String?

}

extension GoalData : Identifiable {

}
