//
//  PreviewHelper.swift
//  
//
//  Created by Danny Sung on 5/30/23.
//

import Foundation
import SwiftUI

#if DEBUG
internal struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State var value: Value
    var content: (Binding<Value>) -> Content

    public var body: some View {
        content($value)
    }

    public init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        self._value = State(wrappedValue: value)
        self.content = content
    }
}

#endif

