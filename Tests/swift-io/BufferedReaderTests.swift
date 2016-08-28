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

class BufferedReaderTests: XCTestCase
{

    static let TEST_STRING =
        "It was the best of times, it was the worst of times,\n" +
        "\n" +
        "it was the age of wisdom, it was the age of foolishness,\n" +
        "it was the epoch of belief, it was the epoch of incredulity,\n" +
        "it was the season of Light, it was the season of Darkness,\n" +
        "it was the spring of hope, it was the winter of despair,\n" +
        "we had everything before us, we had nothing before us\n" +
        "The End."

    func test_SimpleRead() {
        let reader = try! StringReader(BufferedReaderTests.TEST_STRING)
        let s = try! reader.readAll()
        
        XCTAssertEqual(s, BufferedReaderTests.TEST_STRING)
    }
    
    func test_BufferedRead() {
        let reader = try! BufferedReader(StringReader(BufferedReaderTests.TEST_STRING))
        var count = 0
        
        try! reader.readAllLines() { line in
            count += 1
        }
        XCTAssertEqual(count, 8)
    }

    func test_BufferedReadWithLineEndAtEnd() {
        let reader = try! BufferedReader(StringReader(BufferedReaderTests.TEST_STRING + "\n"))
        var count = 0
        
        try! reader.readAllLines() { line in
            count += 1
        }
        XCTAssertEqual(count, 8)
    }

    func test_BufferedReadEmptyString() {
        let reader = try! BufferedReader(StringReader(""))
        let line = try! reader.readLine()
        XCTAssertNil(line)
    }
    
    func test_OneLiner() {
        let reader = try! BufferedReader(StringReader("fdsfsdfs"))
        var count = 0
        
        try! reader.readAllLines() { line in
            count += 1
        }
        XCTAssertEqual(count, 1)
    }

    func test_Content() {
        let reader = try! BufferedReader(StringReader(BufferedReaderTests.TEST_STRING + "\n"))
        var buffer = String()
        
        try! reader.readAllLines() { line in
            buffer += line + "\n"
        }
        XCTAssertEqual(buffer, BufferedReaderTests.TEST_STRING + "\n")
        XCTAssertNil(try! reader.readLine())
    }

    func test_ReadFromClosed() {
        let reader = try! BufferedReader(StringReader(BufferedReaderTests.TEST_STRING + "\n"))
        
        reader.close()
        reader.close()

        do {
            _ = try reader.readLine()
            XCTFail()
        } catch IOException.StreamAlreadyClosed(_) {
            //expected
        } catch  {
            XCTFail()
        }
    }
}