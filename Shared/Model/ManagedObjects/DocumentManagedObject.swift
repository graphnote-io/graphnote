//
//  Document.swift
//  Graphnote
//
//  Created by Hayden Pennington on 2/13/22.
//

import Foundation
import CoreData

public class DocumentManagedObject: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DocumentManagedObject> {
        return NSFetchRequest<DocumentManagedObject>(entityName: "DocumentManagedObject")
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var workspace: WorkspaceManagedObject
    @NSManaged public var blocks: NSSet?
    @NSManaged public var createdAt: Date
    @NSManaged public var modifiedAt: Date
}

extension DocumentManagedObject : Comparable {
    public static func < (lhs: DocumentManagedObject, rhs: DocumentManagedObject) -> Bool {
        lhs.createdAt < rhs.createdAt
    }
}
