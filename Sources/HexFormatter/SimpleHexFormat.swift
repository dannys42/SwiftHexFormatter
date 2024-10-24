//
//  SimpleHexByteFormat.swift
//  HexFormatter
//
//  Created by Danny Sung on 10/24/24.
//

import Foundation

public struct SimpleHexByteFormat: FormatStyle {
    // why does this not work?
//    public typealias FormatInput = ContiguousBytes & Sequence
    public typealias FormatInput = Data

    public typealias FormatOutput = AttributedString
    
    public enum Style {
        case none
        case cStylePrefix
        case hSuffix
    }
    
    let prefix: AttributedString?
    let suffix: AttributedString?
    let byteSeparator: AttributedString?
    
    init(prefix: AttributedString?=nil, suffix: AttributedString?=nil, byteSeparator: AttributedString?=nil) {
        self.prefix = prefix
        self.suffix = suffix
        self.byteSeparator = byteSeparator
    }
    init(prefix: String?=nil, suffix: String?=nil, byteSeparator: String?=nil) {
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
    
    init() {
        self.prefix = nil
        self.suffix = nil
        self.byteSeparator = nil
    }

    init(style: Style) {
        switch style {
        case .none:
            self.init()
        case .cStylePrefix:
            self.init(prefix: "0x")
        case .hSuffix:
            self.init(suffix: "h")
        }
    }
    
    public func format(_ value: FormatInput) -> AttributedString {
        
        value.withUnsafeBytes { bufferPointer in
            let emptyString = AttributedString()
            
            var aString = prefix ?? emptyString
            
            let data = Data(bufferPointer)
            
            for (index, byte) in data.enumerated() {
                let hexByte = String(format: "%02x", byte)
                aString += AttributedString(hexByte)
                
                if let byteSeparator,
                    index < bufferPointer.count {
                    aString += byteSeparator
                }
            }

            return aString + (suffix ?? emptyString)
        }
    }
}

extension FormatStyle where Self == SimpleHexByteFormat {
    public static func simpleHexByteFormat(style: SimpleHexByteFormat.Style = .none) -> SimpleHexByteFormat {
        
        SimpleHexByteFormat(style: style)
    }
}
