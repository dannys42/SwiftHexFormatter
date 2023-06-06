//
//  ContentView.swift
//  HexFormatterExample
//
//  Created by Danny Sung on 5/29/23.
//

import SwiftUI
import HexFormatterUI

struct ContentView: View {
    @State var data = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.".data(using: .utf8)!

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")

            ScrollView(.horizontal) {
                HexFormatterView(data: self.$data)
                    .padding(8)
                    .border(.red)
            }

            Text("Pardon me")

            HexFormatterScrollView(data: self.$data, viewStyle: [
                // https://coolors.co/palette/90f1ef-ffd6e0-ffef9f
                // 90f1ef, ffd6e0, ffef9f
                //
                .offset: { view in
                    view
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 8)
                            .fill(Color(red: 0.565, green: 0.945, blue: 0.937))) // #90f1ef
                },
                .hex: { view in
                    view
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 8)
                            .fill(Color(red: 1, green: 0.839, blue: 0.878))) // #ffd6e0
                },
                .ascii : { view in
                    view
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 8)
                            .fill(Color(red: 1, green: 0.937, blue: 0.624))) // #ffef9f
                },
            ])
//                .style { sectionType, view in
//                    switch sectionType {
//                    case .offset:
//                        return view
//                            .padding(8)
//                            .background(RoundedRectangle(cornerRadius: 8).fill(.cyan))
//                    case .spacer(_):
//                        return view
//                    case .hex:
//                        return view
//                            .padding(8)
//                            .background(RoundedRectangle(cornerRadius: 8).fill(.yellow))
//                    case .ascii:
//                        return view
//                            .padding(8)
//                            .background(RoundedRectangle(cornerRadius: 8).fill(.orange))
//                    }
//                }
                .padding(8)

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
