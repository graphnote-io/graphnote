//
//  FileIconView.swift
//  Graphnote
//
//  Created by Hayden Pennington on 1/22/22.
//

import SwiftUI

struct FileIconView: View {
    var body: some View {
        Image(systemName: "doc.plaintext")
            .foregroundColor(.purple)
    }
}

struct FileIconView_Previews: PreviewProvider {
    static var previews: some View {
        FileIconView()
    }
}