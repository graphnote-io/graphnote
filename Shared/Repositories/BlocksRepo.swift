//
//  BlockRepo.swift
//  Graphnote
//
//  Created by Hayden Pennington on 3/30/22.
//

import Foundation
import CoreData

struct BlocksRepo {
    let moc: NSManagedObjectContext
    
    func fetch(id: UUID) -> Block? {
        let fetchRequest: NSFetchRequest<BlockManagedObject>
        fetchRequest = BlockManagedObject.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id.uuidString)
        
        if let block = try? moc.fetch(fetchRequest).first {
            return Block(id: block.id, createdAt: block.createdAt, modifiedAt: block.modifiedAt, text: block.text, document: block.document.id)
        } else {
            return nil
        }
    }
    
    func fetchAll(document: UUID) -> [Block]? {
        let fetchRequest: NSFetchRequest<BlockManagedObject>
        fetchRequest = BlockManagedObject.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "document.id == %@", document.uuidString)
        
        if let blocks = try? moc.fetch(fetchRequest) {
            return blocks.map {Block(id: $0.id, createdAt: $0.createdAt, modifiedAt: $0.modifiedAt, text: $0.text, document: $0.document.id)}
        } else {
            return nil
        }
    }
    
    func update(block: Block) {
        let fetchRequest: NSFetchRequest<BlockManagedObject>
        fetchRequest = BlockManagedObject.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", block.id.uuidString)
        
        if let updatedBlock = try? moc.fetch(fetchRequest).first {
            updatedBlock.text = block.text
            updatedBlock.modifiedAt = Date()
            try? save()
        }
    }
    
    func create(text: String, document: UUID) {
        let fetchRequest: NSFetchRequest<DocumentManagedObject>
        fetchRequest = DocumentManagedObject.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", document.uuidString)
        
        if let document = try? moc.fetch(fetchRequest).first {
            let now = Date()
            let newBlock = BlockManagedObject(context: moc)
            newBlock.id = UUID()
            newBlock.text = text
            newBlock.createdAt = now
            newBlock.modifiedAt = now
            newBlock.document = document
            
            try? save()
        }
    }
    
    private func save() throws {
        do {
            try moc.save()
        } catch {
            print(error)
            throw error
        }
    }
}
