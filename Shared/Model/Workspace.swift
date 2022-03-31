//
//  Workspace.swift
//  Graphnote
//
//  Created by Hayden Pennington on 3/30/22.
//

import Foundation

struct Workspace: Identifiable, Equatable {
    let id: UUID
    let createdAt: Date
    let modifiedAt: Date
    let title: String
    let documents: [UUID]
}
