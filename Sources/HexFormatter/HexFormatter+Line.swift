//
//  HexFormatter+ForEach.swift
//  
//
//  Created by Danny Sung on 5/28/23.
//

import Foundation

public extension HexFormatter {
    /// A semantic breakdown of the contents of one line of formatted text
    struct Line: Identifiable, Codable, Equatable {
        public var id: Int { offset }

        public let lineNumber: Int
        public let offset: Int
        public let hex: [Int?]
        public let printable: [String?]
    }

    // MARK: Iterate through each line and provided formatted hex as `AttributedString`s

    /// Iterate through each line of a hexdump
    /// - Parameters:
    ///   - data: The data to read
    ///   - offset: Starting offset to read from
    ///   - block: block to call for every line of formatted hex
    func forEachLine(_ data: Data, offset: Int=0, _ block: (AttributedString, Line) throws -> Void) rethrows {
        try self.forEachLine(data, startOffset: offset, endOffset: nil, block)
    }

    /// Iterate through each line of a hexdump
    /// - Parameters:
    ///   - data: The data to read
    ///   - offset: range specifying starting offset to read from
    ///   - block: block to call for every line of formatted hex
    func forEachLine(_ data: Data, offset: PartialRangeFrom<Int>, _ block: (AttributedString, Line) throws -> Void) rethrows {
        try self.forEachLine(data, startOffset: offset.lowerBound, block)
    }

    /// Iterate through each line of a hexdump
    /// - Parameters:
    ///   - data: The data to read
    ///   - offset: range specifying starting and ending offset to read
    ///   - block: block to call for every line of formatted hex
    func forEachLine(_ data: Data, offset: ClosedRange<Int>, _ block: (AttributedString, Line) throws -> Void) rethrows {
        try self.forEachLine(data, startOffset: offset.lowerBound, endOffset: offset.upperBound, block)
    }

    // MARK: Line

    /// Iterate through each line of a hexdump
    /// - Parameters:
    ///   - data: The data to read
    ///   - offset: Starting offset to read from
    ///   - block: block to call for every line of formatted hex
    func forEachLine(_ data: Data, offset: Int=0, _ block: (Line) throws -> Void) rethrows {
        try self.forEachLine(data, startOffset: offset, endOffset: nil, block)
    }

    /// Iterate through each line of a hexdump
    /// - Parameters:
    ///   - data: The data to read
    ///   - offset: range specifying starting offset to read from
    ///   - block: block to call for every line of formatted hex
    func forEachLine(_ data: Data, offset: PartialRangeFrom<Int>, _ block: (Line) throws -> Void) rethrows {
        try self.forEachLine(data, startOffset: offset.lowerBound, block)
    }

    /// Iterate through each line of a hexdump
    /// - Parameters:
    ///   - data: The data to read
    ///   - offset: range specifying starting and ending offset to read
    ///   - block: block to call for every line of formatted hex
    func forEachLine(_ data: Data, offset: ClosedRange<Int>, _ block: (Line) throws -> Void) rethrows {
        try self.forEachLine(data, startOffset: offset.lowerBound, endOffset: offset.upperBound, block)
    }


    // MARK: - Internal Methods

    internal func forEachLine(_ data: Data, startOffset requestedStartOffset: Int=0, endOffset requestedEndOffset: Int?=nil, _ block: (AttributedString, Line) throws -> Void) rethrows {

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


    // MARK: - Private Methods

    private func forEachLine(_ data: Data, startOffset: Int=0, endOffset requestedEndOffset: Int?=nil, _ block: (Line) throws -> Void) rethrows {
        let bytesPerLine = self.configuration.hex.bytesPerLine
        let startIndex = data.startIndex + startOffset

        let endOffset: Int
        if let requestedEndOffset,
           requestedEndOffset < data.count
        {
            endOffset = requestedEndOffset
        } else {
            endOffset = data.count
        }
        var ndx = 0
        var lineNumber = 0

        while (ndx + startOffset) < endOffset {
            var hex: [Int?] = []
            var printables: [String?] = []

            for rowIndex in 0..<bytesPerLine {
                if (startOffset + rowIndex + ndx) >= endOffset {
                    hex.append(nil)
                } else {
                    let ch = data[startIndex + rowIndex + ndx]
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
                            offset: ndx + startOffset,
                            hex: hex,
                            printable: printables)

            try block(line)

            ndx += bytesPerLine
            lineNumber += 1
        }
    }

}

fileprivate extension HexFormatter.Line {
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
