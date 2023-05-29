//
//  HexFormatterUI.swift
//  
//
//  Created by Danny Sung on 5/29/23.
//

import Foundation
import SwiftUI
import HexFormatter

struct HexFormatterUI: View {
    var data: Data {
        didSet {
            self.formattedData = self.formatter.attributedString(from: data)
        }
    }
    @State private var formatter = HexFormatter()
    @State private var formattedData = AttributedString()

    init(data: Data) {
        self.data = data
    }

    init() {
        self.data = Data()
    }

    var body: some View {
        Text(self.formattedData)
            .font(Font.system(.body, design: .monospaced))
    }
}
