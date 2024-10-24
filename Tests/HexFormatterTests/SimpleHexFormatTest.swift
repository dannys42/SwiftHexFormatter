//
//  SimpleHexFormatTest.swift
//  HexFormatter
//
//  Created by Danny Sung on 10/24/24.
//

import Testing
import Foundation
import HexFormatter

struct SimpleHexFormatTest {

    @Test func zeroBytes_WillReturn_EmptyString() async throws {
        let inputValue = Data()
        let expectedValue = ""
        
        let outputValue = inputValue.formatted(.simpleHexByteFormat())
        
        #expect(outputValue == expectedValue)
    }

    @Test func test_1Byte_WillReturn_HexValue() async throws {
        let inputValue = Data([ 0x41 ])
        let expectedValue = "41"
        
        let outputValue = inputValue.formatted(.simpleHexByteFormat())
        
        #expect(outputValue == expectedValue)
    }
    
    @Test func test_3Bytes_WillReturn_HexValues() async throws {
        let inputValue = Data([ 0x41, 0x00, 0xff ])
        let expectedValue = "4100ff"
        
        let outputValue = inputValue.formatted(.simpleHexByteFormat())
        
        #expect(outputValue == expectedValue)
    }
    
    @Test func that_17Bytes_WillReturn_HexValues() async throws {
        let inputValue = Data([ 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
                              0x10 ])
        let expectedValue = "000102030405060708090a0b0c0d0e0f10"
        
        let outputValue = inputValue.formatted(.simpleHexByteFormat())
        
        #expect(outputValue == expectedValue)
    }
}
