//
//  AttributedSimpleHexByteFormat.swift
//  HexFormatter
//
//  Created by Danny Sung on 10/24/24.
//

import Foundation

public struct AttributedSimpleHexByteFormat: FormatStyle {
    // why does this not work?
//    public typealias FormatInput = ContiguousBytes & Sequence
    public typealias FormatInput = Data

    public typealias FormatOutput = AttributedString
    
    public enum Style {
        case none
        case cStylePrefix
        case hSuffix
    }
    public struct CustomStyle: Codable, Equatable, Hashable {
        public var prefix: AttributedString?
        public var suffix: AttributedString?
        public var byteSeparator: AttributedString?
        
        public init() {
            self.prefix = nil
            self.suffix = nil
            self.byteSeparator = nil
        }

        public init(prefix: AttributedString?, suffix: AttributedString?, byteSeparator: AttributedString?) {
            self.prefix = prefix
            self.suffix = suffix
            self.byteSeparator = byteSeparator
        }
        
        public init(prefix: String?=nil, suffix: String?=nil, byteSeparator: String?=nil) {
            if let prefix {
                self.prefix = AttributedString(prefix)
            } else {
                self.prefix = nil
            }
            if let suffix {
                self.suffix = AttributedString(suffix)
            } else {
                self.suffix = nil
            }
            if let byteSeparator {
                self.byteSeparator = AttributedString(byteSeparator)
            } else {
                self.byteSeparator = nil
            }
        }
    }
    
    var customStyle: CustomStyle
    
    public init(_ customStyle: CustomStyle) {
        self.customStyle = customStyle
    }
    
    public init(style: Style) {
        switch style {
        case .none:
            self.init(CustomStyle())
        case .cStylePrefix:
            self.init(CustomStyle(prefix: "0x"))
        case .hSuffix:
            self.init(CustomStyle(suffix: "h"))
        }
    }
    
    public func format(_ value: FormatInput) -> AttributedString {
        
        value.withUnsafeBytes { bufferPointer in
            let emptyString = AttributedString()
            
            var aString = self.customStyle.prefix ?? emptyString
            
            let data = Data(bufferPointer)
            
            for (index, byte) in data.enumerated() {
                let hexByte = String(format: "%02x", byte)
                aString += AttributedString(hexByte)
                
                if let byteSeparator = self.customStyle.byteSeparator,
                    index < bufferPointer.count {
                    aString += byteSeparator
                }
            }

            return aString + (self.customStyle.suffix ?? emptyString)
        }
    }
}

extension FormatStyle where Self == AttributedSimpleHexByteFormat {
    public static func simpleHexByteFormat(style: AttributedSimpleHexByteFormat.Style = .none) -> AttributedSimpleHexByteFormat {
        
        AttributedSimpleHexByteFormat(style: style)
    }
    
    public static func simpleHexByteFormat(customStyle: AttributedSimpleHexByteFormat.CustomStyle) -> AttributedSimpleHexByteFormat {
        
        AttributedSimpleHexByteFormat(customStyle)
    }

}
