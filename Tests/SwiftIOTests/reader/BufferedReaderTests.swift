//
//  StringReaderTests.swift
//  swift-io
//
//  Created by Dusan Saiko on 04/08/16.
//
//

import Foundation
import XCTest
@testable import SwiftIO

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
        " \n" +
        " The End."

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
        XCTAssertEqual(count, 9)
        
        XCTAssertNil(try! reader.readLine())
        XCTAssertNil(try! reader.read())
    }

    func test_BufferedReadWithLineEndAtEnd() {
        let reader = try! BufferedReader(StringReader(BufferedReaderTests.TEST_STRING + "\n"))
        var count = 0
        
        try! reader.readAllLines() { line in
            count += 1
        }
        XCTAssertEqual(count, 9)
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
        XCTAssertNil(try! reader.read())
    }

    func test_ContentCombiningReadAndReadLine() {
        let reader = try! BufferedReader(StringReader(BufferedReaderTests.TEST_STRING + "\n"))
        var buffer = String()
        
        while(true) {
            if let line = try! reader.readLine() {
                buffer += line + "\n"
            } else {
                break
            }

            if let s = try! reader.read() {
                buffer += s
            } else {
                break
            }
            
            if let line = try! reader.readLine() {
                buffer += line + "\n"
            } else {
                break
            }
        }
        
        XCTAssertEqual(buffer, BufferedReaderTests.TEST_STRING + "\n")
        XCTAssertNil(try! reader.readLine())
        XCTAssertNil(try! reader.read())
    }
    
    func test_ContentCombiningReadAndReadLine2() {
        let reader = try! BufferedReader(StringReader(BufferedReaderTests.TEST_STRING + "\n", bufferSize: 1))
        var buffer = String()
        
        while(true) {
            if let s = try! reader.read() {
                buffer += s
            } else {
                break
            }

            if let line = try! reader.readLine() {
                buffer += line + "\n"
            } else {
                break
            }
            
            if let s = try! reader.read() {
                buffer += s
            } else {
                break
            }
        }
        
        XCTAssertEqual(buffer, BufferedReaderTests.TEST_STRING + "\n")
        XCTAssertNil(try! reader.readLine())
        XCTAssertNil(try! reader.read())
    }
    
    func test_ReadFromClosed() {
        let reader = try! BufferedReader(StringReader(BufferedReaderTests.TEST_STRING + "\n"))
        
        try! reader.close()
        try! reader.close()

        do {
            _ = try reader.readLine()
            XCTFail()
        } catch IOException.ErrorReadingFromStream(_) {
            //expected
        } catch  {
            XCTFail()
        }
    }
}
