//
//  Workspace.swift
//  Graphnote
//
//  Created by Hayden Pennington on 2/13/22.
//

import Foundation
import CoreData

public class WorkspaceManagedObject: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkspaceManagedObject> {
        return NSFetchRequest<WorkspaceManagedObject>(entityName: "WorkspaceManagedObject")
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var documents: NSSet?
    @NSManaged public var createdAt: Date
    @NSManaged public var modifiedAt: Date
}

extension WorkspaceManagedObject : Comparable {
    public static func < (lhs: WorkspaceManagedObject, rhs: WorkspaceManagedObject) -> Bool {
        lhs.createdAt < rhs.createdAt
    }
}
