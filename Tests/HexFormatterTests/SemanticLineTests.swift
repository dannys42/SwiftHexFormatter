import XCTest
@testable import HexFormatter

final class SemanticLineTests: XCTestCase {

    func testThat_ForEach_OneLine_IsCorrect() {
        let inputValue = "Hello, World!"
        let expectedValue = HexFormatter.Line(
            lineNumber: 0,
            offset: 0,
            hex: [0x48, 0x65, 0x6c, 0x6c, 0x6f, 0x2c, 0x20, 0x57, 0x6f, 0x72, 0x6c, 0x64, 0x21, nil, nil, nil],
            printable: ["H", "e", "l", "l", "o", ",", " ", "W", "o", "r", "l", "d", "!", nil, nil, nil])

        let formatter = HexFormatter()
        let data = inputValue.data(using: .utf8)!

        formatter.forEachLine(data) { line in
            XCTAssertEqual(line, expectedValue)
        }
    }

    func testThat_ForEach_OneLineOffset_IsCorrect() {
        let inputValue = "Hello, World!"
        let expectedValue = HexFormatter.Line(
            lineNumber: 0,
            offset: 0,
            hex: [nil, 0x65, 0x6c, 0x6c, 0x6f, 0x2c, 0x20, 0x57, 0x6f, 0x72, 0x6c, 0x64, 0x21, nil, nil, nil],
            printable: [nil, "e", "l", "l", "o", ",", " ", "W", "o", "r", "l", "d", "!", nil, nil, nil])

        let formatter = HexFormatter()
        let data = inputValue.data(using: .utf8)!

        formatter.forEachLine(data, startOffset: 1) { line in
            XCTAssertEqual(line, expectedValue)
        }
    }

    func testThat_ForEach_TwoLine_IsCorrect() {
        let inputValue = "Goodbye, cruel world!"
        let expectedValue: [HexFormatter.Line] = [
            .init(
                lineNumber: 0,
                offset: 0x0000,
                hex: [0x47, 0x6f, 0x6f, 0x64, 0x62, 0x79, 0x65, 0x2c, 0x20, 0x63, 0x72, 0x75, 0x65, 0x6c, 0x20, 0x77],
                printable: ["G", "o", "o", "d", "b", "y", "e", ",", " ", "c", "r", "u", "e", "l", " ", "w" ]),
            .init(
                lineNumber: 1,
                offset: 0x0010,
                hex: [0x6f, 0x72, 0x6c, 0x64, 0x21, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil ],
                printable: [ "o", "r", "l", "d", "!",  nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil ]),
        ]

        let formatter = HexFormatter()
        let data = inputValue.data(using: .utf8)!

        var observedValue: [HexFormatter.Line] = []
        formatter.forEachLine(data, startOffset: 0) { line in
            observedValue.append(line)
        }

        XCTAssertEqual(observedValue, expectedValue)
    }


//
//    static var allTests = [
//        ("testThat_SingleLine_IsCorrect", testThat_SingleLine_IsCorrect),
//        ("testThat_Multiline_IsCorrect", testThat_Multiline_IsCorrect),
//    ]
}
