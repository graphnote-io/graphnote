//
//  BlocksService.swift
//  Graphnote
//
//  Created by Hayden Pennington on 3/30/22.
//

import Foundation

struct BlocksService {
    let blockRepo: BlocksRepo
    
    func addBlock(text: String, document: Document) {
        self.blockRepo.create(text: text, document: document.id)
    }
    
    func updateText(_ text: String, id: UUID) {
        if let block = self.blockRepo.fetch(id: id) {
            let modifiedAt = Date()
            let updatedBlock = Block(id: block.id, createdAt: block.createdAt, modifiedAt: modifiedAt, text: text, document: block.document)
            self.blockRepo.update(block: updatedBlock)
        }
    }
    
    func fetchBlocks(document: UUID) -> [Block]? {
        return self.blockRepo.fetchAll(document: document)
    }
    
    func fetchBlock(id: UUID) -> Block? {
        return self.blockRepo.fetch(id: id)
    }
}
