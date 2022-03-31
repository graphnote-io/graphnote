//
//  BlockViewViewModel.swift
//  Graphnote
//
//  Created by Hayden Pennington on 3/30/22.
//

import Foundation
import CoreData

extension BlockView {
    class ViewModel: ObservableObject {
        let id: UUID
        let blockRepo: BlocksRepo
        private let blocksService: BlocksService
        
        @Published var text: String = "" {
            didSet {
                blocksService.updateText(text, id: id)
            }
        }
        
        init(id: UUID, blockRepo: BlocksRepo) {
            self.id = id
            self.blockRepo = blockRepo
            self.blocksService = BlocksService(blockRepo: self.blockRepo)
            if let block = self.blocksService.fetchBlock(id: id) {
                text = block.text
            }
        }
    }
}
