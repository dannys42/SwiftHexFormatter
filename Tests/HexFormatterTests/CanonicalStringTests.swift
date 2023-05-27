//
//  CanonicalStringTests.swift
//  
//
//  Created by Danny Sung on 5/24/23.
//

import XCTest
@testable import HexFormatter

final class CanonicalStringTests: XCTestCase {

    func testThat_Multiline_IsCorrect() {
        let inputValue = "The quick brown fox jumps over the lazy dog."

        let expectedValue = """
            00000000  54 68 65 20 71 75 69 63  6b 20 62 72 6f 77 6e 20  |The quick brown |
            00000010  66 6f 78 20 6a 75 6d 70  73 20 6f 76 65 72 20 74  |fox jumps over t|
            00000020  68 65 20 6c 61 7a 79 20  64 6f 67 2e              |he lazy dog.|
            
            """

        let formatter = HexFormatter()
        let data = inputValue.data(using: .utf8)!
        let observedValue = formatter.string(from: data)

        let expectedLines = expectedValue.split(separator: "\n")
        let observedLines = observedValue.split(separator: "\n")

        XCTAssertEqual(observedLines.count, expectedLines.count)

        for i in 0..<observedLines.count {
            XCTAssertEqual(observedLines[i], expectedLines[i])
        }
        XCTAssertEqual(observedValue, expectedValue)

    }
//    func testThat_SingleLine_IsCorrect() {
//        let inputValue = "Hello, World!"
//        let expectedValue = "00000000  48 65 6c 6c 6f 2c 20 57  6f 72 6c 64 21  |Hello, World!|\n" // output from: hexdump -C
//
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct
//        // results.
//        let formatter = HexFormatter.canonical
//        formatter.byteIntervalSeparator = " "
//        let data = inputValue.data(using: .utf8)!
//        let observedValue = formatter.string(from: data)
//        print(observedValue)
//
//        XCTAssertEqual(observedValue, expectedValue)
////        XCTAssertEqual(HexFormatter().text, "Hello, World!")
//    }
}
