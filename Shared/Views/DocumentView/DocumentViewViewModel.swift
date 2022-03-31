//
//  Documents.swift
//  Graphnote
//
//  Created by Hayden Pennington on 2/9/22.
//

import Foundation
import CoreData

final class DocumentViewViewModel: ObservableObject {
    let moc: NSManagedObjectContext
    
    private let blocksService: BlocksService
    
    let id: UUID
    let workspaceId: UUID
    var document: Document?
    
    @Published var title: String = "" {
        didSet {
//            setTitle(title: title, workspaceId: workspaceId, documentId: id)
        }
    }
    
    @Published var workspaceTitle: String = "" {
        didSet {
            setWorkspaceTitle(title: workspaceTitle, workspaceId: workspaceId)
        }
    }
    
    @Published var blocks: [Block] = [] {
        didSet {
            print("didSet blocks")
        }
    }
    
    init(id: UUID, workspaceId: UUID, moc: NSManagedObjectContext, blocksService: BlocksService) {
        self.id = id
        self.workspaceId = workspaceId
        self.moc = moc
        self.blocksService = blocksService
        
        if let document = self.fetchDocument(workspaceId: workspaceId, documentId: id) {
            self.document = document
            self.title = document.title
//            self.workspaceTitle = document.workspace.title
        }
        
        if let blocks = blocksService.fetchBlocks(document: id) {
            self.blocks = blocks
        }
    }
    
    func addBlock(text: String) {
        if let document = document {
            self.blocksService.addBlock(text: text, document: document)
            if let blocks = blocksService.fetchBlocks(document: id) {
                self.blocks = blocks
            }
        }
    }
    
    private func fetchDocument(workspaceId: UUID, documentId: UUID) -> Document? {
        let fetchRequest: NSFetchRequest<DocumentManagedObject>
        fetchRequest = DocumentManagedObject.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "workspace.id == %@ && id == %@", workspaceId.uuidString, documentId.uuidString)
        
        if let d = try? moc.fetch(fetchRequest).first {
            return Document(id: d.id, createdAt: d.createdAt, modifiedAt: d.modifiedAt, title: d.title, workspace: d.workspace.id, blocks: (d.blocks?.allObjects as? [DocumentManagedObject])?.map {$0.id} ?? [])
        }
        
        return nil
    }
    
    private func fetchWorkspace(workspaceId: UUID) -> WorkspaceManagedObject? {
        let fetchRequest: NSFetchRequest<WorkspaceManagedObject>
        fetchRequest = WorkspaceManagedObject.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", workspaceId.uuidString)
        
        if let workspace = try? moc.fetch(fetchRequest).first {
            return workspace
        }
        
        return nil
    }
    
//    private func setTitle(title: String, workspaceId: UUID, documentId: UUID) {
//        if let document = fetchDocument(workspaceId: workspaceId, documentId: documentId) {
//            document.title = title
//            document.modifiedAt = Date.now
//            self.save()
//        }
//
//    }
    
    private func setWorkspaceTitle(title: String, workspaceId: UUID) {
        if let workspace = fetchWorkspace(workspaceId: workspaceId) {
            workspace.title = title
            workspace.modifiedAt = Date.now
            self.save()
        }
        
    }
    
    private func save() {
        do {
            try self.moc.save()
        } catch let error {
            print("Error saving managed object context. Error: \(error)")
        }
    }
}
