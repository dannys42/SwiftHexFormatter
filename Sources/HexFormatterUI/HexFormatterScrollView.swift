//
//  SwiftUIView.swift
//  
//
//  Created by Danny Sung on 5/30/23.
//

// implement a scrollable lazyvstack ?
import Foundation
import SwiftUI
import HexFormatter
import Combine

public struct HexFormatterScrollView: View {
    @StateObject private var model = HexFormatterViewModel()
    @Binding private var data: Data

    private var viewStyle: [HexFormatter.Configuration.Layout: (any View) -> (any View)]

    private var configuration: HexFormatter.Configuration

    public init(data: Binding<Data>, configuration: HexFormatter.Configuration = .default, viewStyle: [HexFormatter.Configuration.Layout: (any View) -> (any View)] = [:]) {
        self._data = data
        self.configuration = configuration
        self.viewStyle = viewStyle
    }

    public var body: some View {
        ScrollView([.horizontal, .vertical]) {
            HStack(spacing: 0) {
                ForEach(self.model.sectionViews) { view in
                    AnyView(self.viewStyle(view: view))
                    //                    AnyView(self.viewStyle(view.sectionType, view))
                    //                        .font(Font.system(.caption, design: .monospaced))
                    //                    AnyView(view)
                    //                        .background(RoundedRectangle(cornerRadius: 8).fill(.cyan))
                }
            }
        }
//        .onReceive(Just(self.$data)) { data in
//            self.model.update()
//        }
        .onAppear {
            self.model.configuration = self.configuration
            self.model.data = self.data
        }
    }

    private func viewStyle(view: HexFormatterSectionView) -> any View {
        if let viewModifier = self.viewStyle[view.sectionType] {
            return viewModifier(view
                .font(Font.system(.caption, design: .monospaced))
            )
        }
        return view
            .font(Font.system(.caption, design: .monospaced))
    }

}


fileprivate struct HexFormatterOffsetView: View {
    @State private var lines: [HexFormatter.FormattedLine] = []

    init(lines: [HexFormatter.FormattedLine]) {
        self.lines = lines
    }

    var body: some View {
        Text("")
    }

}

class HexFormatterViewModel: ObservableObject {
    private var formatter: HexFormatter
    var configuration: HexFormatter.Configuration {
        didSet {
            self.update()
        }
    }

    var data: Data {
        didSet {
            self.update()
        }
    }

    public enum SectionContent: Equatable {
        case spacer([AttributedString])
        case offset([AttributedString])
        case hex([AttributedString])
        case ascii([AttributedString])
    }

    @Published var sections: [SectionContent]
    @Published fileprivate var sectionViews: [HexFormatterSectionView]

    init(configuration: HexFormatter.Configuration = .default) {
        self.configuration = configuration
        self.formatter = HexFormatter()
        self.formatter.configuration = configuration

        self.data = Data()
        self.sections = []
        self.sectionViews = []
    }

    func update() {
        var sections: [SectionContent] = []
        var sectionViews: [HexFormatterSectionView] = []

        for (sectionNdx, section) in configuration.layout.enumerated() {
            var values: [AttributedString] = []

            self.formatter.forEachFormattedLine(data) { line in
                values.append(line.sections[sectionNdx].attributedString)
            }

            let view: HexFormatterSectionView
            switch section {
            case .offset:
                sections.append(.offset(values))

                view = HexFormatterSectionView(id: sectionNdx, sectionType: .offset, text: values)
            case .hex:
                sections.append(.hex(values))

                view = HexFormatterSectionView(id: sectionNdx, sectionType: .hex, text: values)
            case .spacer(let space):
                sections.append(.spacer(values))

                view = HexFormatterSectionView(id: sectionNdx, sectionType: .spacer(space), text: values)
            case .ascii:
                sections.append(.ascii(values))

                view = HexFormatterSectionView(id: sectionNdx, sectionType: .ascii, text: values)
            }

            sectionViews.append(view)
        }

        self.sections = sections
        self.sectionViews = sectionViews
    }
}

fileprivate struct HexFormatterSectionView: View, Identifiable {
    let id: Int
    let sectionType: HexFormatter.Configuration.Layout
    let text: [AttributedString]

    init(id: Int, sectionType: HexFormatter.Configuration.Layout, text: [AttributedString]) {
        self.id = id
        self.sectionType = sectionType
        self.text = text
    }

    var body: some View {
        HStack {
            Text(self.text.joined(separator: AttributedString("\n")))
        }
    }
}

//fileprivate struct HexFormatterLineView: View {
//    let formattedLine: HexFormatter.FormattedLine
//
//    init(formattedLine: HexFormatter.FormattedLine) {
//        self.formattedLine = formattedLine
//    }
//
//    var body: some View {
//        HStack {
//            for section in self.formattedLine.sections {
//                switch section {
//                case .offset(let aString), .hex(let aString), .ascii(let aString), .spacer(let aString):
//
//                    Text(aString)
//                }
//            }
//            Text("\(formattedLine.line.offset)")
////            Text("\(line.hex)")
////            Text("\(line.printable)")
//        }
//    }
//
//}

#if DEBUG
struct HHexFormatterScrollView_Previews: PreviewProvider {
    @State static var data = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.".data(using: .utf8)!

    static var previews: some View {
        StatefulPreviewWrapper(data) { value in
            HexFormatterScrollView(data: value)
        }
    }
}
#endif

