//
//  DocumentView.swift
//  Graphnote
//
//  Created by Hayden Pennington on 1/23/22.
//

import SwiftUI
import Combine
import CoreData

fileprivate let scrollWidth: CGFloat = 16
fileprivate let pageMinHeightMultiplier = 1.3
fileprivate let maxBlockWidth: CGFloat = 800
fileprivate let pad: Double = 40
fileprivate let textSpacing: Double = 14.0
fileprivate let toolbarHeight: CGFloat = 28

struct DocumentView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var moc
    
    let blockRepo: BlocksRepo
    
    var open: Binding<Bool>
    
    let documentId: UUID
    let workspaceId: UUID
    
    @ObservedObject private var viewModel: DocumentViewViewModel
    
    init(moc: NSManagedObjectContext, id: UUID, workspaceId: UUID, open: Binding<Bool>) {
        self.documentId = id
        self.workspaceId = workspaceId
        self.open = open
        self.blockRepo = BlocksRepo(moc: moc)

        self.viewModel = DocumentViewViewModel(id: documentId, workspaceId: workspaceId, moc: moc, blocksService: BlocksService(blockRepo: self.blockRepo))
    }
    
    func toolbar(size: CGSize, open: Binding<Bool>) -> some View {
        ToolbarView(size: size, open: open)
            .frame(height: toolbarHeight)
    }
    
    func documentBody(size: CGSize) -> some View {
        VStack {
            #if os(macOS)
            self.toolbar(size: size, open: open)
            #endif
            ScrollView(showsIndicators: true) {
                #if os(macOS)

                VStack(alignment: .center, spacing: pad) {
                    HStack() {
                        VStack(alignment: .leading) {
                            TextField("", text: $viewModel.title)
                                .font(.largeTitle)
                                .textFieldStyle(.plain)
                            Spacer()
                                .frame(height: 20)
                            TextField("", text: $viewModel.workspaceTitle)
                                .font(.headline)
                                .textFieldStyle(.plain)
                                .onSubmit {
                                    self.viewModel.addBlock(text: "Type here")
                                }
                        }
                            .padding(open.wrappedValue ? .leading : [.leading, .trailing, .top], pad)
                            .padding(open.wrappedValue ? .top : [], pad)
                            .foregroundColor(.primary)
                    }.frame(width: maxBlockWidth)
                    
                    ForEach() {
                        HStack {
                            TextField("", text: .constant("DICKS"))
                                .font(.body)
                                .lineSpacing(textSpacing)
                                .padding(pad)
                                .foregroundColor(.primary)
                            Spacer()
                        }.frame(width: maxBlockWidth)
                    }
                    Spacer()
                }
                .frame(minWidth: size.width - scrollWidth, minHeight: size.height * pageMinHeightMultiplier)
                .background(colorScheme == .dark ? darkBackgroundColor : lightBackgroundColor)
                #else
                VStack(alignment: .leading, spacing: pad) {
                    HStack {
                        VStack(alignment: .leading) {
                            TextField("", text: $viewModel.title)
                                .font(.largeTitle)
                                .textFieldStyle(.plain)
                            Spacer()
                                .frame(height: 20)
                            TextField("", text: $viewModel.workspaceTitle)
                                .font(.headline)
                                .textFieldStyle(.plain)
                                .onSubmit {
                                    self.viewModel.addBlock(text: "Type here")
                                }
                        }
//                            .padding(open.wrappedValue ? pad / 2 : pad)
                        .padding(open.wrappedValue ? .leading : [.leading, .trailing, .top], open.wrappedValue ? pad / 2 : pad)
                        .padding(open.wrappedValue ? [.top, .bottom] : [], pad)
                            .foregroundColor(.primary)
                        
                    }
                    ForEach(viewModel.blocks) { block in
                        BlockView(blockRepo: self.blockRepo, id: block.id, open: true) {
                            self.viewModel.addBlock(text: "Type here")
                        }
                    }
                    Spacer(minLength: pad * 2)
                }
                .frame(minWidth: size.width, minHeight: size.height * pageMinHeightMultiplier)
                .background(colorScheme == .dark ? darkBackgroundColor : lightBackgroundColor)
                #endif
            }.background(colorScheme == .dark ? darkBackgroundColor : lightBackgroundColor)
    
            #if os(iOS)
            self.toolbar(size: size, open: open)
            #endif
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            #if os(macOS)
            VStack {
                documentBody(size: geometry.size)
            }
            .edgesIgnoringSafeArea([.top])
            .background(colorScheme == .dark ? darkBackgroundColor : lightBackgroundColor)
            #else
            VStack {
                documentBody(size: geometry.size)
            }
            .background(colorScheme == .dark ? darkBackgroundColor : lightBackgroundColor)
            .edgesIgnoringSafeArea(.trailing)
            #endif
        }
        .background(colorScheme == .dark ? darkBackgroundColor : lightBackgroundColor)
    }
}
