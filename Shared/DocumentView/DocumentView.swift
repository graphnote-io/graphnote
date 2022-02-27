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
    
    @State private var title = ""
    @State private var workspaceTitle = ""
    @State private var blockText = ""
    
    var open: Binding<Bool>
    
    let documentId: UUID
    let workspaceId: UUID
    
    @ObservedObject private var viewModel: DocumentViewViewModel
    
    init(moc: NSManagedObjectContext, id: UUID, workspaceId: UUID, open: Binding<Bool>) {
        self.documentId = id
        self.workspaceId = workspaceId
        self.open = open

        self.viewModel = DocumentViewViewModel(id: documentId, workspaceId: workspaceId, moc: moc)
        self._title = State(initialValue: viewModel.title)
        self._workspaceTitle = State(initialValue: viewModel.workspaceTitle)
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
                            TextField("", text: $title)
                                .font(.largeTitle)
                                .textFieldStyle(.plain)
                            Spacer()
                                .frame(height: 20)
                            TextField("", text: $workspaceTitle)
                                .font(.headline)
                                .textFieldStyle(.plain)
                        }
                            .padding(open.wrappedValue ? .leading : [.leading, .trailing, .top], pad)
                            .padding(open.wrappedValue ? .top : [], pad)
                            .foregroundColor(.primary)
                    }.frame(width: maxBlockWidth)
                    HStack {
                        InputField(lineSpacing: textSpacing, text: $blockText)
                            .padding(pad)
                    }.frame(width: maxBlockWidth)
                    Spacer()
                }
                .frame(minWidth: size.width - scrollWidth, minHeight: size.height * pageMinHeightMultiplier)
                .background(colorScheme == .dark ? darkBackgroundColor : lightBackgroundColor)
                #else
                VStack(alignment: .leading, spacing: pad) {
                    HStack {
                        VStack(alignment: .leading) {
                            TextField("", text: $title)
                                .font(.largeTitle)
                                .textFieldStyle(.plain)
                            Spacer()
                                .frame(height: 20)
                            TextField("", text: $workspaceTitle)
                                .font(.headline)
                                .textFieldStyle(.plain)
                        }
//                            .padding(open.wrappedValue ? pad / 2 : pad)
                        .padding(open.wrappedValue ? .leading : [.leading, .trailing, .top], open.wrappedValue ? pad / 2 : pad)
                        .padding(open.wrappedValue ? [.top, .bottom] : [], pad)
                            .foregroundColor(.primary)
                        
                    }
                    HStack {
                        InputField(lineSpacing: textSpacing, text: $blockText)
                            .padding(pad)
                    }
                    Spacer()
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
        .onChange(of: title) { newValue in
            viewModel.setTitle(title: newValue, workspaceId: workspaceId, documentId: documentId)
        }
        .onChange(of: workspaceTitle) { newValue in
            viewModel.setWorkspaceTitle(title: newValue, workspaceId: workspaceId)
        }
        .onChange(of: viewModel.title) { newValue in
            if title != newValue {
                title = newValue
            }
        }
        .onChange(of: viewModel.workspaceTitle) { newValue in
            if workspaceTitle != newValue {
                workspaceTitle = newValue
            }
        }

    }
}
