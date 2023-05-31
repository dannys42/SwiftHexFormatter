//
//  HexFormatterUI.swift
//  
//
//  Created by Danny Sung on 5/29/23.
//

import Foundation
import SwiftUI
import HexFormatter

public struct HexFormatterView: View {
    @State private var formatter = HexFormatter()
    @Binding private var data: Data
    
    public init(data: Binding<Data>, configuration: HexFormatter.Configuration = .default) {
        self.formatter = HexFormatter()
        self._data = data

        self.formatter.configuration = configuration
    }

    public var body: some View {
        Text(self.formatter.string(from: self.data))
            .lineLimit(.none)
            .font(Font.system(.caption, design: .monospaced))
    }
}

#if DEBUG
struct HexFormatterUI_Previews: PreviewProvider {
    @State static var data = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.".data(using: .utf8)!

    static var previews: some View {
        StatefulPreviewWrapper(data) { value in
            HexFormatterView(data: value)
        }
    }
}
#endif

