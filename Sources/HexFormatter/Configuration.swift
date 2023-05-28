//
//  Configuration.swift
//  
//
//  Created by Danny Sung on 5/22/23.
//

import Foundation

public extension HexFormatter {
    struct Configuration {

        public var offset: Offset
        public var hex: Hex
        public var ascii: Ascii

        public enum Layout {
            case offset
            case hex
            case ascii
            case spacer(Spacer)
        }

        public var layout: [Layout]


        public static let `default` = Configuration(offset: .default, hex: .default, ascii: .default, layout: .default)

        public static let minimal = Configuration(offset: .default,
                                                  hex: .init(bytesPerLine: 32, bytesPerWord: 32, casing: .lower, symbols: .init(noData: .init(), byteSeparator: .init(), wordSeparator: .init())),
                                                  ascii: .default, layout: [.hex])

        public init(offset: Offset, hex: Hex, ascii: Ascii, layout: [Layout]) {
            self.offset = offset
            self.hex = hex
            self.ascii = ascii
            self.layout = layout
        }

    }
}

public extension Array where Element == HexFormatter.Configuration.Layout {
    static let `default`: [HexFormatter.Configuration.Layout] = [.offset, .spacer(.default), .hex, .spacer(.default), .ascii, .spacer(.newline)]
    static let canonical = `default`

    static let minimal: [HexFormatter.Configuration.Layout] = [.hex]
}

public extension HexFormatter.Configuration {
    struct Spacer {
        public var space: AttributedString

        public static let none = Spacer(spacer: AttributedString(""))
        public static let `default` = Spacer(spacer: AttributedString("  "))
        public static let newline = Spacer(spacer: AttributedString("\n"))
        public static let verticalBar = Spacer(spacer: AttributedString("|"))

        public init(spacer: AttributedString) {
            self.space = spacer
        }

        public init(spacer: [AttributedString]) {
            self.space = spacer.joined()
        }

        public init(spacer: AttributedString...) {
            self.init(spacer: spacer)
        }
    }

    enum Case {
        case upper
        case lower
    }

    // MARK: Offset Section
    struct Offset {
        public enum Style {
            case short      // 4 characters
            case standard   // 8 characters
        }

        public var style: Style
        public var casing: Case

        public static let `default` = Offset(style: .standard, casing: .lower)

        public init(style: Style = Self.default.style, casing: Case = Self.default.casing) {
            self.style = style
            self.casing = casing
        }
    }

    // MARK: Hex Section
    struct Hex {
        public struct Symbols {
            public var noData: AttributedString
            public var byteSeparator: AttributedString
            public var wordSeparator: AttributedString

            public static let `default` = Symbols(noData: AttributedString("  "), byteSeparator: AttributedString(" "), wordSeparator: AttributedString("  "))

            public init(noData: AttributedString = Self.default.noData, byteSeparator: AttributedString = Self.default.byteSeparator, wordSeparator: AttributedString = Self.default.wordSeparator) {
                self.noData = noData
                self.byteSeparator = byteSeparator
                self.wordSeparator = wordSeparator
            }
        }

        public var bytesPerLine: Int
        public var bytesPerWord: Int
        public var casing: Case
        public var symbols: Symbols

        public static let `default` = Hex(bytesPerLine: 16, bytesPerWord: 8, casing: .lower, symbols: .default)

        public init(bytesPerLine: Int = Self.default.bytesPerLine, bytesPerWord: Int = Self.default.bytesPerWord, casing: Case = Self.default.casing, symbols: Symbols = Self.default.symbols) {
            self.bytesPerLine = bytesPerLine
            self.bytesPerWord = bytesPerWord
            self.casing = casing
            self.symbols = symbols
        }
    }

    // MARK: ASCII Section
    struct Ascii {
        public enum Style {
            case standard
        }
        public struct Symbols {
            public var noData: AttributedString
            public var nonPrintable: AttributedString
            public var beginValidData: AttributedString
            public var endValidData: AttributedString

            public static let `default` = Symbols(noData: AttributedString(" "), nonPrintable: AttributedString(stringLiteral: "."), beginValidData: AttributedString("|"), endValidData: AttributedString("|"))

            public init(noData: AttributedString = Self.default.noData, nonPrintable: AttributedString, beginValidData: AttributedString = Self.default.beginValidData, endValidData: AttributedString = Self.default.endValidData) {
                self.noData = noData
                self.nonPrintable = nonPrintable
                self.beginValidData = beginValidData
                self.endValidData = endValidData
            }
        }

        public var style: Style
        public var symbols: Symbols

        static let `default` = Ascii(style: .standard, symbols: .default)

        public init(style: Style, symbols: Symbols) {
            self.style = style
            self.symbols = symbols
        }
    }
}
