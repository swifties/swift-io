//
//  FileWriterTests.swift
//
//  Created by Dusan Saiko on 06/07/16.

import XCTest
@testable import swift_io 

class FileWriterTests: XCTestCase
{
    func test_Closing() {
        let writer = try! FileWriter(NSTemporaryDirectory() + "file.txt")
        defer {
            try! writer.close()
        }
        try! writer.close()
        try! writer.close()
    }
    
    func test_Write() {
        let url = URL(fileURLWithPath: NSTemporaryDirectory() + "file.txt")
        
        let writer = try! FileWriter(url, appendFile: false)

        let strings = ["Test\n", "Text!", "    ", "\n", "1234567890"]

        for s in strings {
            try! writer.write(s)
        }
        try! writer.close()
        
        //test write after close
        do {
            try writer.write("?")
            XCTFail() //unreachable - flush after close will fail
        } catch IOException.StreamAlreadyClosed {
            //expected
        } catch {
            XCTFail()
        }
        
        let s = try! String(contentsOf: url)
        XCTAssertEqual(s, strings.joined(separator: ""))
    }
    
    func test_Append() {
        let url = URL(fileURLWithPath: NSTemporaryDirectory() + "file.txt")
        
        let writer1 = try! FileWriter(url, appendFile: false)
        try! writer1.write("Hello ")
        try! writer1.close()

        let writer2 = try! FileWriter(url, appendFile: true)
        try! writer2.write("World!")
        try! writer2.close()

        let s = try! String(contentsOf: url)
        XCTAssertEqual(s, "Hello World!")
    }
    
    func test_Unwritable() {
        var writer = try! FileWriter("/rootX/file.sh", appendFile: false)
        do {
            try writer.write("AAAAA")
            XCTFail()
        } catch IOException.ErrorWritingIntoStream(_, _) {
            //expected
        } catch {
            XCTFail()
        }
        
        do {
            writer = try FileWriter(URL(string: "unknown://rootX/file.sh")!)
            try writer.write("AAAAA")
            XCTFail()
        } catch IOException.FileIsNotWritable(_) {
            //expected
        } catch {
            XCTFail()
        }

    }
    
    func test_InvalidEncoding() {
        let writer = try! FileWriter(URL(fileURLWithPath: NSTemporaryDirectory() + "file.txt"), appendFile: false)

        do {
            try writer.write("ČŘŠŤĎŇ", dataEncoding: .ascii)
            XCTFail()
        } catch Exception.InvalidStringEncoding(_, _) {
            //expected
        } catch {
            XCTFail()
        }
    }
}
