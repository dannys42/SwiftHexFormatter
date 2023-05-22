import XCTest
@testable import HexFormatter

final class HexFormatterTests: XCTestCase {

    func testThat_ForEach_OneLine_IsCorrect() {
        let inputValue = "Hello, World!"
        let expectedValue = HexFormatter.Line(
            lineNumber: 0,
            offset: 0,
            hex: [0x48, 0x65, 0x6c, 0x6c, 0x6f, 0x2c, 0x20, 0x57, 0x6f, 0x72, 0x6c, 0x64, 0x21, nil, nil, nil],
            printable: ["H", "e", "l", "l", "o", ",", " ", "W", "o", "r", "l", "d", "!", nil, nil, nil])

        let formatter = HexFormatter.canonical
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

        let formatter = HexFormatter.canonical
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

        let formatter = HexFormatter.canonical
        let data = inputValue.data(using: .utf8)!

        var observedValue: [HexFormatter.Line] = []
        formatter.forEachLine(data, startOffset: 0) { line in
            observedValue.append(line)
        }

        XCTAssertEqual(observedValue, expectedValue)
    }


    func testThat_Multiline_IsCorrect() {
        let inputValue = "The quick brown fox jumps over the lazy dog."

        let expectedValue = """
            00000000  54 68 65 20 71 75 69 63  6b 20 62 72 6f 77 6e 20  |The quick brown |
            00000010  66 6f 78 20 6a 75 6d 70  73 20 6f 76 65 72 20 74  |fox jumps over t|
            00000020  68 65 20 6c 61 7a 79 20  64 6f 67 2e              |he lazy dog.|
            """

        let formatter = HexFormatter.canonical
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
    func testThat_SingleLine_IsCorrect() {
        let inputValue = "Hello, World!"
        let expectedValue = "00000000  48 65 6c 6c 6f 2c 20 57  6f 72 6c 64 21  |Hello, World!|\n" // output from: hexdump -C

        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let formatter = HexFormatter.canonical
        formatter.byteIntervalSeparator = " "
        let data = inputValue.data(using: .utf8)!
        let observedValue = formatter.string(from: data)
        print(observedValue)

        XCTAssertEqual(observedValue, expectedValue)
//        XCTAssertEqual(HexFormatter().text, "Hello, World!")
    }

    static var allTests = [
        ("testThat_SingleLine_IsCorrect", testThat_SingleLine_IsCorrect),
        ("testThat_Multiline_IsCorrect", testThat_Multiline_IsCorrect),
    ]
}
