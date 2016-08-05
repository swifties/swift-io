//
//  StringReaderTests.swift
//  swift-io
//
//  Created by Dusan Saiko on 04/08/16.
//
//

import Foundation
import XCTest
@testable import swift_io

class StringReaderTests: XCTestCase
{

    static let TEST_STRING =
        "It was the best of times, it was the worst of times,\n" +
        "\n" +
        "it was the age of wisdom, it was the age of foolishness,\n" +
        "it was the epoch of belief, it was the epoch of incredulity,\n" +
        "it was the season of Light, it was the season of Darkness,\n" +
        "it was the spring of hope, it was the winter of despair,\n" +
        "we had everything before us, we had nothing before us\n" +
        "\n"
    
    func test_SimpleRead() {
        let reader = try! StringReader(string: StringReaderTests.TEST_STRING)
        var buffer = [UInt8](repeating: 0, count: 1024 * 8)
        
        let count = reader.read(buffer: &buffer)
        XCTAssertNotNil(count)
        
        var data = Data()
        data.append(buffer, count: count!)
        let s = String(data: data, encoding: .utf8)!
        
        XCTAssertEqual(s, StringReaderTests.TEST_STRING)
    }
    
    func test_BufferedRead() {
        let reader = try! BufferedReader(StringReader(string: StringReaderTests.TEST_STRING))
        
        var line = try! reader.readLine()
        var count = 0
        while(line != nil) {
            count += 1
            line = try! reader.readLine()
        }
        
        XCTAssertEqual(count, 8)
    }
    
    func test_BufferedReadSmallBuffer() {
        let reader = try! BufferedReader(StringReader(string: StringReaderTests.TEST_STRING), bufferSize: 5)
        
        var line = try! reader.readLine()
        var count = 0
        while(line != nil) {
            count += 1
            line = try! reader.readLine()
        }
        
        XCTAssertEqual(count, 8)
    }
}
