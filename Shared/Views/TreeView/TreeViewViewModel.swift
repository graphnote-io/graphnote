//
//  TreeViewViewModel.swift
//  Graphnote
//
//  Created by Hayden Pennington on 2/9/22.
//

import Foundation
import CoreData

final class TreeViewViewModel: ObservableObject {
    let moc: NSManagedObjectContext

    @Published var workspaces: [WorkspaceManagedObject] = []
    @Published var documents: [DocumentManagedObject] = []
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
        fetchWorkspaces()
        fetchDocuments()
    }
    
    func fetchWorkspaces() {
        let fetchRequest: NSFetchRequest<WorkspaceManagedObject>
        fetchRequest = WorkspaceManagedObject.fetchRequest()
        
        if let workspaces = try? moc.fetch(fetchRequest) {
            self.workspaces = workspaces.sorted()
        }
    }
    
    func fetchDocuments() {
        let fetchRequest: NSFetchRequest<DocumentManagedObject>
        fetchRequest = DocumentManagedObject.fetchRequest()
        
        if let documents = try? moc.fetch(fetchRequest) {
            self.documents = documents
        }
    }
    
    func addWorkspace() {
        let now = Date.now
        let newWorkspace = WorkspaceManagedObject(context: moc)
        newWorkspace.id = UUID()
        newWorkspace.createdAt = now
        newWorkspace.modifiedAt = now
        newWorkspace.title = "New Workspace"
        
        try? moc.save()
        
        fetchWorkspaces()
    }
}
