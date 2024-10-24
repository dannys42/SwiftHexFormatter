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
        let expectedValue = AttributedString()
        
        let outputValue = inputValue.formatted(.simpleHexByteFormat())
        
        #expect(outputValue == expectedValue)
    }

    @Test func oneByte_WillReturn_HexValue() async throws {
        let inputValue = Data([ 0x41 ])
        let expectedValue = AttributedString("41")
        
        let outputValue = inputValue.formatted(.simpleHexByteFormat())
        
        #expect(outputValue == expectedValue)
    }
    
    @Test func manyBytes_WillReturn_HexValues() async throws {
        let inputValue = Data([ 0x41, 0x00, 0xff ])
        let expectedValue = AttributedString("4100ff")
        
        let outputValue = inputValue.formatted(.simpleHexByteFormat())
        
        #expect(outputValue == expectedValue)
    }
}
