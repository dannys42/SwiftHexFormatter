//
//  Configuration.swift
//  
//
//  Created by Danny Sung on 5/22/23.
//

import Foundation

public extension HexFormatter {
    struct Configuration {

//        public var separator: SeparatorConfiguration
//        public var section: SectionConfiguration
//        public var symbol: SymbolConfiguration

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

        public init(offset: Offset, hex: Hex, ascii: Ascii, layout: [Layout]) {
            self.offset = offset
            self.hex = hex
            self.ascii = ascii
            self.layout = layout
        }


//        static let `default` = Configuration(separator: .default, section: .default, symbol: .default)
//
//        init(separator: SeparatorConfiguration, section: SectionConfiguration, symbol: SymbolConfiguration) {
//            self.separator = separator
//            self.section = section
//            self.symbol = symbol
//        }
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


    /*
    public struct SeparatorConfiguration {
        public var offsetToHexSectionSeparator: String
        public var hexToAsciiSectionSeparator: String
        public var hexByteSeparator: String
        public var hexWordSeparator: String

        static let `default` = SeparatorConfiguration(offsetToHexSectionSeparator: "  ",
                                                      hexToAsciiSectionSeparator: "  ",
                                                      hexByteSeparator: " ", hexWordSeparator: " - ")

        init(offsetToHexSectionSeparator: String = Self.default.offsetToHexSectionSeparator, hexToAsciiSectionSeparator: String = Self.default.hexToAsciiSectionSeparator, hexByteSeparator: String = Self.default.hexByteSeparator, hexWordSeparator: String = Self.default.hexWordSeparator) {
            self.offsetToHexSectionSeparator = offsetToHexSectionSeparator
            self.hexToAsciiSectionSeparator = hexToAsciiSectionSeparator
            self.hexByteSeparator = hexByteSeparator
            self.hexWordSeparator = hexWordSeparator
        }
    }

    public struct AttributedSeparatorConfiguration {
        public var offsetToHexSectionSeparator: AttributedString
        public var hexToAsciiSectionSeparator: AttributedString
        public var hexByteSeparator: AttributedString
        public var hexWordSeparator: AttributedString

        static let `default` = AttributedSeparatorConfiguration(separatorConfiguration: .default)

        init(offsetToHexSectionSeparator: AttributedString, hexToAsciiSectionSeparator: AttributedString, hexByteSeparator: AttributedString, hexWordSeparator: AttributedString) {
            self.offsetToHexSectionSeparator = offsetToHexSectionSeparator
            self.hexToAsciiSectionSeparator = hexToAsciiSectionSeparator
            self.hexByteSeparator = hexByteSeparator
            self.hexWordSeparator = hexWordSeparator
        }

        init(separatorConfiguration: SeparatorConfiguration) {
            self.offsetToHexSectionSeparator = AttributedString(separatorConfiguration.offsetToHexSectionSeparator)
            self.hexToAsciiSectionSeparator = AttributedString(separatorConfiguration.hexToAsciiSectionSeparator)
            self.hexByteSeparator = AttributedString(separatorConfiguration.hexByteSeparator)
            self.hexWordSeparator = AttributedString(separatorConfiguration.hexWordSeparator)
        }
    }

    public struct SymbolConfiguration {
        public var hexNoDataSymbol: String
        public var asciiNonPrintableSymbol: String
        public var asciiNoDataSymbol: String
        public var beginningOfLineSymbol: String
        public var endOfLineSymbol: String

        static let `default` = SymbolConfiguration(hexNoDataSymbol: "  ", asciiNonPrintableSymbol: ".", asciiNoDataSymbol: " ", beginningOfLineSymbol: "", endOfLineSymbol: "\n")

        init(hexNoDataSymbol: String, asciiNonPrintableSymbol: String, asciiNoDataSymbol: String, beginningOfLineSymbol: String, endOfLineSymbol: String) {
            self.hexNoDataSymbol = hexNoDataSymbol
            self.asciiNonPrintableSymbol = asciiNonPrintableSymbol
            self.asciiNoDataSymbol = asciiNoDataSymbol
            self.beginningOfLineSymbol = beginningOfLineSymbol
            self.endOfLineSymbol = endOfLineSymbol
        }
    }

    public struct OffsetSectionConfiguration {
        public var style: OffsetStyle
        public var casing: Case

        static let `default` = OffsetSectionConfiguration(style: .standard, casing: .lower)

        init(style: OffsetStyle, casing: Case) {
            self.style = style
            self.casing = casing
        }
    }

    public struct HexSectionConfiguration {
        public var bytesPerLine: Int
        public var bytesPerWord: Int
        public var casing: Case

        static let `default` = HexSectionConfiguration(bytesPerLine: 16, bytesPerWord: 8, casing: .lower)

        init(bytesPerLine: Int, bytesPerWord: Int, casing: Case) {
            self.bytesPerLine = bytesPerLine
            self.bytesPerWord = bytesPerWord
            self.casing = casing
        }
    }

    public struct AsciiSectionConfiguration {
        public var style: AsciiStyle
        public var casing: Case

        static let `default` = AsciiSectionConfiguration(style: .standard, casing: .lower)

        init(style: AsciiStyle, casing: Case) {
            self.style = style
            self.casing = casing
        }
    }

    public struct SectionConfiguration {
        public var offset: OffsetSectionConfiguration
        public var hex: HexSectionConfiguration
        public var ascii: AsciiSectionConfiguration

        static let `default` = SectionConfiguration(offset: .default, hex: .default, ascii: .default)

        init(offset: OffsetSectionConfiguration, hex: HexSectionConfiguration, ascii: AsciiSectionConfiguration) {
            self.offset = offset
            self.hex = hex
            self.ascii = ascii
        }
    }

    public enum OffsetStyle {
        case disable
        case short      // 4 characters
        case standard   // 8 characters
    }
    public enum AsciiStyle {
        case disable
        case standard
    }
    public enum Case {
        case upper
        case lower
    }
     */

}
