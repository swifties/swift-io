//
//  FileWriterTests.swift
//
//  Created by Dusan Saiko on 06/07/16.

import XCTest
@testable import swift_io 

class FileWriterTests: XCTestCase
{
    func test_closing() {
        let writer = try! FileWriter(file: NSTemporaryDirectory()+"file.txt")
        defer {
            try! writer.close()
        }
        try! writer.close()
        try! writer.close()
    }
    
    func test_write() {
        let url = URL(fileURLWithPath: NSTemporaryDirectory()+"file.txt")
        
        let writer = try! FileWriter(url: url, appendFile: false, bufferSize: 5)
        defer {
            try! writer.close()
        }
        
        let strings = ["Test\n", "Text!", "    ", "\n", "1234567890"]

        for s in strings {
            try! writer.write(string: s)
        }
        try! writer.close()
        
        do {
            try writer.flush()
            XCTAssertTrue(false) //unreachable - flush after close will fail
        } catch IOException.StreamAlreadyClosed {
            XCTAssertTrue(true) //this is fine
        } catch {
            XCTAssertTrue(false) //unknown exception?
        }
        
        //test write after close
        do {
            try writer.write(string: "?")
            XCTAssertTrue(false) //unreachable - flush after close will fail
        } catch IOException.StreamAlreadyClosed {
            XCTAssertTrue(true) //this is fine
        } catch {
            XCTAssertTrue(false) //unknown exception?
        }
        
        
        let s = try! String(contentsOf: url)
        XCTAssertEqual(s, strings.joined(separator: ""))
    }
    
    func test_append() {
        let url = URL(fileURLWithPath: NSTemporaryDirectory()+"file.txt")
        
        let writer1 = try! FileWriter(url: url, appendFile: false)
        try! writer1.write(string: "Hello ")
        try! writer1.close()

        let writer2 = try! FileWriter(url: url, appendFile: true)
        try! writer2.write(string: "World!")
        try! writer2.close()

        let s = try! String(contentsOf: url)
        XCTAssertEqual(s, "Hello World!")
    }
    
    func test_unwritable() {
        let writer = try? FileWriter(file: "/rootX/file.sh", appendFile: false, bufferSize: 5)
        XCTAssertNil(writer)
    }
}
