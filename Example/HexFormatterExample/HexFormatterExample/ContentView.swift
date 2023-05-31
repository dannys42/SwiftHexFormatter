//
//  ContentView.swift
//  HexFormatterExample
//
//  Created by Danny Sung on 5/29/23.
//

import SwiftUI
import HexFormatterUI

struct ContentView: View {
    @State var data = "Hello, world!".data(using: .utf8)!

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")

            HexFormatterView(data: self.$data)
                .padding(8)
                .border(.red)
            Text("Goodbye")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
