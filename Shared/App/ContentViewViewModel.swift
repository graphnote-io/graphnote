//
//  ContentViewViewModel.swift
//  Graphnote
//
//  Created by Hayden Pennington on 2/13/22.
//

import Foundation
import CoreData

final class ContentViewViewModel: ObservableObject {
    let moc: NSManagedObjectContext

    @Published var items: [WorkspaceManagedObject] = []
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
        fetchWorkspaces()
    }
    
    func fetchWorkspaces() {
        let fetchRequest: NSFetchRequest<WorkspaceManagedObject>
        fetchRequest = WorkspaceManagedObject.fetchRequest()
        
        if let workspaces = try? moc.fetch(fetchRequest) {
            self.items = workspaces
        }
    }
}
