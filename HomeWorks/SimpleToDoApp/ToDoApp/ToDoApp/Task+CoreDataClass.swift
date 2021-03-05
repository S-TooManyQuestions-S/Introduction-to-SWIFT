//
//  Task+CoreDataClass.swift
//  ToDoApp
//
//  Created by Андрей Самаренко on 05.03.2021.
//
//

import Foundation
import CoreData

@objc(Task)
public class Task: NSManagedObject {
    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }
}
