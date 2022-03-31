//
//  Document.swift
//  Graphnote
//
//  Created by Hayden Pennington on 3/30/22.
//

import Foundation

struct Document: Identifiable, Equatable {
    let id: UUID
    let createdAt: Date
    let modifiedAt: Date
    let title: String
    let workspace: UUID
    let blocks: [UUID]
}
