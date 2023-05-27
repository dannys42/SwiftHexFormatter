//
//  HexFormatter.swift
//  
//
//  Created by Danny Sung on 5/22/23.
//

import Foundation

public class HexFormatter: Formatter {
    public var configuration: Configuration = .default

    public struct Line: Identifiable, Codable, Equatable {
        public var id: Int { offset }

        public let lineNumber: Int
        public let offset: Int
        public let hex: [Int?]
        public let printable: [String?]
    }

    public func attributedString(from data: Data) -> AttributedString {
        var returnString = AttributedString()

        self.forEachLine(data) { attributedString, _ in
            returnString.append(attributedString)
        }

        return returnString
    }


    public func string(from data: Data) -> String {
        return String(self.attributedString(from: data).characters)
    }

    public func forEachLine(_ data: Data, startOffset requestedStartOffset: Int=0, endOffset requestedEndOffset: Int?=nil, _ block: (AttributedString, Line) throws -> Void) rethrows {

        try self.forEachLine(data, startOffset: requestedStartOffset, endOffset: requestedEndOffset) { line in
            var attributedString = AttributedString()
            for section in self.configuration.layout {
                switch section {
                case .spacer(let spacer):
                    attributedString.append(spacer.space)
                case .offset:
                    attributedString.append(line.formattedOffset(configuration: self.configuration.offset))
                case .hex:
                    attributedString.append(line.formattedHex(configuration: self.configuration.hex))
                case .ascii:
                    attributedString.append(line.formattedAscii(configuration: self.configuration.ascii))
                }
            }
            try block(attributedString, line)
        }

    }

    public func forEachLine(_ data: Data, startOffset requestedStartOffset: Int=0, endOffset requestedEndOffset: Int?=nil, _ block: (Line) throws -> Void) rethrows {
        let bytesPerLine = self.configuration.hex.bytesPerLine
        let startIndex = data.startIndex
        let startLine = requestedStartOffset / bytesPerLine
        let startOffset = startLine * bytesPerLine // bound ensure we're bounded to bytesPerLine

        var ndx = startOffset

        let endOffset: Int
        if let requestedEndOffset,
           requestedEndOffset < data.count
        {
            endOffset = requestedEndOffset
        } else {
            endOffset = data.count
        }

        var lineNumber: Int = startLine
        while ndx < endOffset {
            var hex: [Int?] = []
            var printables: [String?] = []

            for rowIndex in ndx..<(ndx+bytesPerLine) {
                if rowIndex < requestedStartOffset {
                    hex.append(nil)
                    printables.append(nil)
                } else if rowIndex >= endOffset {
                    hex.append(nil)
                    printables.append(nil)
                } else {
                    let ch = data[startIndex+rowIndex]
                    hex.append(Int(ch))

                    if isprint(Int32(Int(ch))) == 0 {
                        printables.append(nil)
                    } else {
                        let s = String(format: "%c", ch)
                        printables.append(s)
                    }
                }
            }

            let line = Line(lineNumber: lineNumber,
                            offset: ndx,
                            hex: hex,
                            printable: printables)

            try block(line)

            ndx += bytesPerLine
            lineNumber += 1
        }
    }

}

internal extension HexFormatter.Line {
    func formattedOffset(configuration: HexFormatter.Configuration.Offset) -> AttributedString {
        let formatLength: String
        var formatCode: String
        var returnString = AttributedString()

        switch configuration.style {
        case .short:
            formatLength = "04"
        case .standard:
            formatLength = "08"
        }
        switch configuration.casing {
        case .upper:
            formatCode = "X"
        case .lower:
            formatCode = "x"
        }
        let offsetString = String(format: "%\(formatLength)\(formatCode)", offset)
        returnString.append(AttributedString(offsetString))
        return returnString
    }

    func formattedHex(configuration: HexFormatter.Configuration.Hex) -> AttributedString {
        let format: String
        var returnString = AttributedString()

        switch configuration.casing {
        case .upper:
            format = "%02lX"
        case .lower:
            format = "%02lx"
        }

        for (ndx,byte) in self.hex.enumerated() {
            let isLast = (ndx >= self.hex.count-1)
            if let byte {
                let byteString = String(format: format, byte)
                returnString.append(AttributedString(byteString))

            } else {
                returnString.append(configuration.symbols.noData)
            }

            if !isLast {
                if ((ndx+1) % configuration.bytesPerWord) == 0 {
                    returnString.append(configuration.symbols.wordSeparator)
                } else {
                    returnString.append(configuration.symbols.byteSeparator)
                }
            }
        }

        return returnString
    }

    func formattedAscii(configuration: HexFormatter.Configuration.Ascii) -> AttributedString {
        var returnString = AttributedString()

        var lastCharacterWasInDataRange = false
        var didBeginData = false
        var didEndData = false

        for character in self.printable {
            if let character,
               let byte = character.data(using: .utf8)?.first
            {
                didBeginData = true
                if !lastCharacterWasInDataRange {
                    returnString.append(configuration.symbols.beginValidData)
                }
                lastCharacterWasInDataRange = true
                let ch = Int32(byte)
                if isprint(ch) == 0 {
                    returnString.append(configuration.symbols.nonPrintable)
                } else {
                    returnString.append( AttributedString(character) )
                }
            } else {
                if lastCharacterWasInDataRange {
                    returnString.append(configuration.symbols.endValidData)
                    didEndData = true
                } else {
//                    returnString.append(configuration.symbols.noData)
                }

                lastCharacterWasInDataRange = false
            }
        }

        if !didBeginData {
            returnString.append(configuration.symbols.endValidData)
        }
        if !didEndData {
            returnString.append(configuration.symbols.endValidData)
        }

        return returnString
    }
}
