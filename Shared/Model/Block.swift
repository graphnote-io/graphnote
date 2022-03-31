//
//  Block.swift
//  Graphnote
//
//  Created by Hayden Pennington on 3/30/22.
//

import Foundation

struct Block: Identifiable, Equatable {
    let id: UUID
    let createdAt: Date
    let modifiedAt: Date
    let text: String
    let document: UUID
}
