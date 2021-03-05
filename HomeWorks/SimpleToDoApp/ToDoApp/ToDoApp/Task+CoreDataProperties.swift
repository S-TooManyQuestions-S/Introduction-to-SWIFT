//
//  Task+CoreDataProperties.swift
//  ToDoApp
//
//  Created by Андрей Самаренко on 05.03.2021.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var header: String
    @NSManaged public var date: Date
    @NSManaged public var status: String
    @NSManaged public var note: String
    @NSManaged public var image: Data

}

extension Task : Identifiable {

}
