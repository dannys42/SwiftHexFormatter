//
//  MinimalStringTests.swift
//  
//
//  Created by Danny Sung on 5/26/23.
//

import XCTest
@testable import HexFormatter

final class MinimalStringTests: XCTestCase {

    func testThat_Multiline_IsCorrect() {
        let inputValue = "The quick brown fox jumps over the lazy dog."

        let expectedValue = "54686520717569636b2062726f776e20666f78206a756d7073206f76657220746865206c617a7920646f672e"

        let formatter = HexFormatter()
        formatter.configuration = .minimal

        let data = inputValue.data(using: .utf8)!
        let observedValue = formatter.string(from: data)

        XCTAssertEqual(observedValue, expectedValue)

    }

}
