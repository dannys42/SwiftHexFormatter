import Foundation

public class HexFormatter_Old: Formatter {
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

    class var canonical: HexFormatter_Old {
        let formatter = HexFormatter_Old()
        formatter.offset.suffix = "  "
        formatter.asciiLine.prefix = "  |"
        formatter.asciiLine.suffix = "|"
        formatter.asciiNoDataReplacement = ""
        formatter.byteIntervalSeparator = " "
        return formatter
    }

    public struct AttributedWrap {
        var prefix: NSAttributedString
        var suffix: NSAttributedString

        static let none = AttributedWrap(prefix: NSAttributedString(string: ""),
                                         suffix: NSAttributedString(string: ""))
    }

    public var offsetStyle: OffsetStyle = .standard

    public var attributedOffset = AttributedWrap.none
    public var offsetCase = Case.lower

    public var bytesPerLine = 16
    public var attributedByteLine = AttributedWrap.none
    public var attributedByte = AttributedWrap.none
    public var attributedByteSeparator = NSAttributedString(string: " ")
    public var attributedByteNoDataReplacement = NSAttributedString(string: "  ")
    public var bytesCase = Case.lower

    public var byteIntervalSpacing = 8
    public var attributedByteIntervalSeparator = NSAttributedString(string: " - ")

    public var asciiStyle: AsciiStyle = .standard
    public var attributedAsciiLine = AttributedWrap.none
    public var attributedAsciiPrintable = AttributedWrap.none
    public var attributedAsciiNonPrintable = AttributedWrap.none
    public var attributedAsciiNonPrintableReplacement = NSAttributedString(string: ".")
    public var attributedAsciiNoDataReplacement = NSAttributedString(string: " ")

    public var attributedLine = AttributedWrap.none
    public var attributedNewlineSeparator = NSAttributedString(string: "\n")

    public func string(from data: Data) -> String {
        return self.attributedString(from: data).string
    }

    private func formattedOffset(_ offset: Int) -> NSAttributedString {
        var sbuf = NSMutableAttributedString(attributedString: self.attributedOffset.prefix)
        let formatLength: String
        var formatCode: String
        switch self.offsetStyle {
        case .disable:
            return NSAttributedString(string: "")
        case .short:
            formatLength = "04"
        case .standard:
            formatLength = "08"
        }
        switch self.offsetCase {
        case .upper:
            formatCode = "X"
        case .lower:
            formatCode = "x"
        }
        let offsetString = String(format: "%\(formatLength)\(formatCode)", offset)
        sbuf.append(NSAttributedString(string: offsetString))
        sbuf.append(NSMutableAttributedString(attributedString: self.attributedOffset.suffix))
        return sbuf
    }

    private func formattedByteLine(_ data: Data, startOffset: Int) -> (NSAttributedString,Int) {
        let totalBytes = data.count
        let startIndex = data.startIndex
        var ndx = startOffset
        var sbuf = NSMutableAttributedString(attributedString: self.attributedByteLine.prefix)
        let format: String
        switch self.bytesCase {
        case .upper:
            format = "%02lX"
        case .lower:
            format = "%02lx"
        }

        for row in 0..<self.bytesPerLine {
            /* Mid-line separator */
            if row%(self.byteIntervalSpacing) == 0 && row != 0 {
                sbuf.append(self.attributedByteIntervalSeparator)
            }

            let byteString: String
            sbuf.append(self.attributedByte.prefix)
            if ndx < totalBytes {
                /* Hex */
                byteString = String(format: format, data[ndx+startIndex])
                sbuf.append(NSAttributedString(string: byteString))
            } else{
                sbuf.append(self.attributedByteNoDataReplacement)
            }
            sbuf.append(self.attributedByte.suffix)

            if (ndx+1) < totalBytes && (ndx+1) < self.bytesPerLine {
                sbuf.append(self.attributedByteSeparator)
            }

            ndx += 1
        }
        sbuf.append(NSMutableAttributedString(attributedString: self.attributedByteLine.suffix))

        return (sbuf, ndx)
    }

    private func formattedAsciiLine(_ data: Data, startOffset: Int) -> NSAttributedString {
        let totalBytes = data.count
        let startIndex = data.startIndex
        var ndx = startOffset
        var sbuf = NSMutableAttributedString(string: "")
        let format: String

        switch self.asciiStyle {
        case .disable:
            return NSAttributedString(string: "")
        case .standard:
            break
        }
        sbuf.append(self.attributedAsciiLine.prefix)
        for row in 0..<self.bytesPerLine {
            if ndx < totalBytes {
                let ch = data[ndx+startIndex]
                if isprint(Int32(Int(ch))) == 0 {
                    sbuf.append(self.attributedAsciiNonPrintable.prefix)
                    sbuf.append(attributedAsciiNonPrintableReplacement)
                    sbuf.append(self.attributedAsciiNonPrintable.suffix)
                } else {
                    let s = String(format: "%c", ch)
                    sbuf.append(self.attributedAsciiPrintable.prefix)
                    sbuf.append(NSAttributedString(string: s))
                    sbuf.append(self.attributedAsciiPrintable.suffix)
                }
            } else {
                sbuf.append(self.attributedAsciiNoDataReplacement)
            }
            ndx += 1
        }
        sbuf.append(self.attributedAsciiLine.suffix)
        return sbuf
    }

    public func attributedString(from data: Data) -> NSAttributedString {
        var sbuf = NSMutableAttributedString(string: "")
        let totalBytes = data.count
        var ndx = 0
        let startOffset = data.startIndex

        for offset in stride(from: 0, to: totalBytes, by: self.bytesPerLine) {
            let startNdx = ndx

            sbuf.append(self.attributedLine.prefix)

            sbuf.append(self.formattedOffset(offset))

            let (byteLine,newNdx) = self.formattedByteLine(data, startOffset: startNdx)

            sbuf.append(byteLine)

            sbuf.append(self.formattedAsciiLine(data, startOffset: startNdx))

            sbuf.append(self.attributedLine.suffix)
            sbuf.append(self.attributedNewlineSeparator)
            ndx = newNdx
        }

        return sbuf
    }
}

// MARK: Non-attributed convenience methods
extension HexFormatter_Old {
    public var byteSeparator: String {
        get {
            return self.attributedByteSeparator.string
        }
        set {
            self.attributedByteSeparator = NSAttributedString(string: newValue)
        }
    }
    public var byteIntervalSeparator: String {
        get {
            return self.attributedByteIntervalSeparator.string
        }
        set {
            self.attributedByteIntervalSeparator = NSAttributedString(string: newValue)
        }
    }

    public var asciiNonPrintableReplacement: String {
        get {
            return self.attributedAsciiNonPrintableReplacement.string
        }
        set {
            self.attributedAsciiNonPrintableReplacement = NSAttributedString(string: newValue)
        }
    }

    public var asciiNoDataReplacement: String {
        get {
            return self.attributedAsciiNoDataReplacement.string
        }
        set {
            self.attributedAsciiNoDataReplacement = NSAttributedString(string: newValue)
        }
    }

    public var newlineSeparator: String {
        get {
            return self.attributedNewlineSeparator.string
        }
        set {
            self.attributedNewlineSeparator = NSAttributedString(string: newValue)
        }
    }


    public struct Wrap {
        var prefix: String {
            didSet {
                self.didUpdatePrefix(prefix)
            }
        }
        var suffix: String {
            didSet {
                self.didUpdateSuffix(suffix)
            }
        }

        var didUpdatePrefix: (String)->Void = { _ in }
        var didUpdateSuffix: (String)->Void = { _ in }

        init(attributedWrap: AttributedWrap) {
            self.prefix = attributedWrap.prefix.string
            self.suffix = attributedWrap.suffix.string
        }
    }

    public var offset: Wrap {
        get {
            var w = Wrap(attributedWrap: self.attributedOffset)
            w.didUpdatePrefix = { prefix in
                self.attributedOffset.prefix = NSAttributedString(string: prefix)
            }
            w.didUpdateSuffix = { prefix in
                self.attributedOffset.prefix = NSAttributedString(string: prefix)
            }

            return w
        }
        set {
            self.attributedOffset.prefix = NSAttributedString(string: newValue.prefix)
            self.attributedOffset.suffix = NSAttributedString(string: newValue.suffix)
        }
    }

    public var byteLine: Wrap {
        get {
            var w = Wrap(attributedWrap: self.attributedByteLine)
            w.didUpdatePrefix = { prefix in
                self.attributedByteLine.prefix = NSAttributedString(string: prefix)
            }
            w.didUpdateSuffix = { prefix in
                self.attributedByteLine.prefix = NSAttributedString(string: prefix)
            }

            return w
        }
        set {
            self.attributedByteLine.prefix = NSAttributedString(string: newValue.prefix)
            self.attributedByteLine.suffix = NSAttributedString(string: newValue.suffix)
        }
    }

    public var byte: Wrap {
        get {
            var w = Wrap(attributedWrap: self.attributedByte)
            w.didUpdatePrefix = { prefix in
                self.attributedByte.prefix = NSAttributedString(string: prefix)
            }
            w.didUpdateSuffix = { prefix in
                self.attributedByte.prefix = NSAttributedString(string: prefix)
            }

            return w
        }
        set {
            self.attributedByte.prefix = NSAttributedString(string: newValue.prefix)
            self.attributedByte.suffix = NSAttributedString(string: newValue.suffix)
        }
    }

    public var asciiLine: Wrap {
        get {
            var w = Wrap(attributedWrap: self.attributedAsciiLine)
            w.didUpdatePrefix = { prefix in
                self.attributedAsciiLine.prefix = NSAttributedString(string: prefix)
            }
            w.didUpdateSuffix = { prefix in
                self.attributedAsciiLine.prefix = NSAttributedString(string: prefix)
            }

            return w
        }
        set {
            self.attributedAsciiLine.prefix = NSAttributedString(string: newValue.prefix)
            self.attributedAsciiLine.suffix = NSAttributedString(string: newValue.suffix)
        }
    }

    public var asciiPrintable: Wrap {
        get {
            var w = Wrap(attributedWrap: self.attributedAsciiPrintable)
            w.didUpdatePrefix = { prefix in
                self.attributedAsciiPrintable.prefix = NSAttributedString(string: prefix)
            }
            w.didUpdateSuffix = { prefix in
                self.attributedAsciiPrintable.prefix = NSAttributedString(string: prefix)
            }

            return w
        }
        set {
            self.attributedAsciiPrintable.prefix = NSAttributedString(string: newValue.prefix)
            self.attributedAsciiPrintable.suffix = NSAttributedString(string: newValue.suffix)
        }
    }

    public var asciiNonePrintable: Wrap {
        get {
            var w = Wrap(attributedWrap: self.attributedAsciiNonPrintable)
            w.didUpdatePrefix = { prefix in
                self.attributedAsciiNonPrintable.prefix = NSAttributedString(string: prefix)
            }
            w.didUpdateSuffix = { prefix in
                self.attributedAsciiNonPrintable.prefix = NSAttributedString(string: prefix)
            }

            return w
        }
        set {
            self.attributedAsciiNonPrintable.prefix = NSAttributedString(string: newValue.prefix)
            self.attributedAsciiNonPrintable.suffix = NSAttributedString(string: newValue.suffix)
        }
    }

}
