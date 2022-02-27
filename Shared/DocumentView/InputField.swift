//
//  InputField.swift
//  Graphnote
//
//  Created by Hayden Pennington on 2/20/22.
//

import SwiftUI

struct InputField: View {
    let lineSpacing: CGFloat
    var text: Binding<String>
    
    var body: some View {
        ZStack(alignment: .leading) {
            TextEditor(text: text)
                .textFieldStyle(.plain)
                .onChange(of: text.wrappedValue) { _ in
                    if !text.wrappedValue.filter({ $0.isNewline }).isEmpty {
                        print("Found new line character")
                    }
                }
                .font(.body)
                .lineSpacing(lineSpacing)
                .foregroundColor(.primary)
                .cornerRadius(4)
                .fixedSize(horizontal: false, vertical: true)
                
            if text.wrappedValue == "" {
                Text(" Press '/' for commands")
                    .foregroundColor(.gray)
            }
        }
        
    }
}
