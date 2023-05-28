//
//  HexFormatter.swift
//  
//
//  Created by Danny Sung on 5/22/23.
//

import Foundation

public class HexFormatter: Formatter {
    // MARK: Configuration
    public var configuration: Configuration = .default

    // MARK: Attributed Strings

    public func attributedString(from data: Data, offset: Int=0) -> AttributedString {
        return self.attributedString(from: data, startOffset: offset, endOffset: nil)
    }

    public func attributedString(from data: Data, offset: PartialRangeFrom<Int>) -> AttributedString {
        return self.attributedString(from: data, startOffset: offset.lowerBound, endOffset: nil)
    }

    public func attributedString(from data: Data, offset: ClosedRange<Int>) -> AttributedString {
        return self.attributedString(from: data, startOffset: offset.lowerBound, endOffset: offset.upperBound)
    }


    // MARK: Strings

    public func string(from data: Data, offset: Int=0) -> String {
        return self.string(from: data, startOffset: offset, endOffset: nil)
    }

    public func string(from data: Data, offset: PartialRangeFrom<Int>) -> String {
        return self.string(from: data, startOffset: offset.lowerBound, endOffset: nil)
    }

    public func string(from data: Data, offset: ClosedRange<Int>) -> String {
        return self.string(from: data, startOffset: offset.lowerBound, endOffset: offset.upperBound)
    }


    // MARK: - Private Methods

    private func attributedString(from data: Data, startOffset: Int, endOffset: Int?=nil) -> AttributedString {
        var returnString = AttributedString()

        self.forEachLine(data, startOffset: startOffset, endOffset: endOffset) { attributedString, _ in
            returnString.append(attributedString)
        }

        return returnString
    }


    private func string(from data: Data, startOffset: Int, endOffset: Int?=nil) -> String {
        return String(self.attributedString(from: data, startOffset: startOffset, endOffset: endOffset).characters)
    }


}
