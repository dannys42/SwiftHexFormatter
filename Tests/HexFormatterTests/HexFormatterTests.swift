import XCTest
@testable import HexFormatter

final class HexFormatterTests: XCTestCase {
    func testPlainText() {
        let inputValue = "Hello, World!"
        let expectedValue = "00000000  48 65 6c 6c 6f 2c 20 57  6f 72 6c 64 21           |Hello, World!|\n" // output from: hexdump -C

        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let formatter = HexFormatter.canonical
        formatter.byteIntervalSeparator = " "
        let data = inputValue.data(using: .utf8)!
        let calculatedValue = formatter.string(from: data)
        print(calculatedValue)

        XCTAssertEqual(calculatedValue, expectedValue)
//        XCTAssertEqual(HexFormatter().text, "Hello, World!")
    }

    static var allTests = [
        ("testPlainText", testPlainText),
    ]
}
