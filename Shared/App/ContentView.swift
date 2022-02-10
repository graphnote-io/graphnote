//
//  ContentView.swift
//  Shared
//
//  Created by Hayden Pennington on 1/22/22.
//

import SwiftUI
import CoreData
import SwiftyJSON

fileprivate let documentWidth: CGFloat = 800
fileprivate let treeLayourPriority: CGFloat = 100

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject private var dataController: DataController
    
    @State private var menuOpen = true
    
    @StateObject private var workspaces = Workspaces()
    
    let moc: NSManagedObjectContext

    init(moc: NSManagedObjectContext) {
        self.moc = moc

//        dropDatabase()
//        seed()

    }
    
    var body: some View {
        HStack(alignment: .top) {
            if menuOpen {
                #if os(macOS)
                ZStack() {
                    EffectView()
                    TreeView(workspaces: workspaces)
                        .padding()
                }
                .frame(width: treeWidth)
                .edgesIgnoringSafeArea([.bottom])
                #else
                ZStack() {
                    EffectView()
                    TreeView(workspaces: workspaces)
                        .layoutPriority(treeLayourPriority)
                }
                .frame(width: mobileTreeWidth)
                .edgesIgnoringSafeArea([.top, .bottom])
                #endif
            }
        }
    }
    
    func dropDatabase() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Workspace.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try! self.moc.execute(deleteRequest)
    }
    
    func seed() {
        let workspaceTitles = [
            "SwiftBook",
            "DarkTorch",
            "NSSWitch",
            "Kanception",
        ]

        let documentTitles = [
            "Design Doc",
            "Project Kickoff",
            "Technical Specification",
        ]


        for title in workspaceTitles {
            let workspace = Workspace(context: moc)
            let createdAt = Date.now
            workspace.createdAt = createdAt
            workspace.modifiedAt = createdAt
            workspace.id = UUID()
            workspace.title = title

            for docTitle in documentTitles {
                let document = Document(context: moc)
                document.id = UUID()
                document.createdAt = createdAt
                document.modifiedAt = createdAt
                document.title = docTitle
                document.workspace = workspace
            }
        }

        try? moc.save()
    }
    
}
