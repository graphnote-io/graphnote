//
//  Block.swift
//  Graphnote
//
//  Created by Hayden Pennington on 3/30/22.
//

import Foundation
import CoreData

public class BlockManagedObject: NSManagedObject, Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<BlockManagedObject> {
        return NSFetchRequest<BlockManagedObject>(entityName: "BlockManagedObject")
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var text: String
    @NSManaged public var document: DocumentManagedObject
    @NSManaged public var createdAt: Date
    @NSManaged public var modifiedAt: Date
}

extension BlockManagedObject : Comparable {
    public static func < (lhs: BlockManagedObject, rhs: BlockManagedObject) -> Bool {
        lhs.createdAt < rhs.createdAt
    }
}
