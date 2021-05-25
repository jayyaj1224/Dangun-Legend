//
//  DayData+CoreDataProperties.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/05/25.
//
//

import Foundation
import CoreData


extension DayData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DayData> {
        return NSFetchRequest<DayData>(entityName: "DayData")
    }

    @NSManaged public var date: String?
    @NSManaged public var index: Int64
    @NSManaged public var status: String?

}

extension DayData : Identifiable {

}
