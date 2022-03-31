//
//  BlockView.swift
//  Graphnote
//
//  Created by Hayden Pennington on 3/30/22.
//

import SwiftUI

struct BlockView: View {
    let blockRepo: BlocksRepo
    let id: UUID
    let open: Bool
    let onSubmit: () -> ()
    let pad: Double = 40
    let textSpacing: Double = 14.0
    
    @ObservedObject private var viewModel: ViewModel
    
    init(blockRepo: BlocksRepo, id: UUID, open: Bool, onSubmit: @escaping () -> ()) {
        self.blockRepo = blockRepo
        self.id = id
        self.open = open
        self.onSubmit = onSubmit
        self.viewModel = ViewModel(id: id, blockRepo: blockRepo)
    }
    
    var body: some View {
        HStack {
            TextField("", text: $viewModel.text)
                .onSubmit {
                    onSubmit()
                }
                .font(.body)
                .lineSpacing(textSpacing)
                .padding(open ? pad / 2 : pad)
                .foregroundColor(.primary)
            Spacer()
        }
        
    }
}

//struct BlockView_Previews: PreviewProvider {
//    static var previews: some View {
//        BlockView(id: UUID(), text: .constant("Value"), open: true)
//    }
//}
