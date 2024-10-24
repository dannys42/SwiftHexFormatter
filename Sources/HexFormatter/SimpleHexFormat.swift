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

    public typealias FormatOutput = String
    
    let attributedFormatter: AttributedSimpleHexByteFormat
    
    init(customStyle: AttributedSimpleHexByteFormat.CustomStyle) {
        self.attributedFormatter = AttributedSimpleHexByteFormat(customStyle)
    }
    
    init(style: AttributedSimpleHexByteFormat.Style) {
        self.attributedFormatter = AttributedSimpleHexByteFormat(style: style)
    }
    
    public func format(_ value: FormatInput) -> String {
        let aString = self.attributedFormatter.format(value)
        
        let string = String(aString.characters)
        
        return string
    }
}

extension FormatStyle where Self == AttributedSimpleHexByteFormat {
    public static func simpleHexByteFormat(style: AttributedSimpleHexByteFormat.Style = .none) -> SimpleHexByteFormat {
        
        SimpleHexByteFormat(style: style)
    }
    
    public static func simpleHexByteFormat(customStyle: AttributedSimpleHexByteFormat.CustomStyle) -> SimpleHexByteFormat {
        
        SimpleHexByteFormat(customStyle: customStyle)
    }

}
