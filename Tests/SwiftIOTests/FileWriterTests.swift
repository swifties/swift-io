//
//  FileWriterTests.swift
//  swift-io
//
//  Created by Dusan Saiko on 21/09/16.
//
//

import Foundation
import XCTest
@testable import SwiftIO

class FileWriterTests: XCTestCase
{
    
    func test_SimpleWriter() {
        let url = URL(fileURLWithPath: NSTemporaryDirectory() + "file_simpleWriter1.txt")
        
        let reader = try! StringReader(InputStreamReaderTests.LONG_TEXT, bufferSize: 1)
        let writer = try! FileWriter(url)
        
        var count = 0
        
        try! reader.readAll() {
            try! writer.write($0)
            count += 1
        }
        
        let result = try! String(contentsOf: url, encoding: .utf8)
        
        writer.close()
        
        XCTAssertTrue(count > 0)
        XCTAssertEqual(InputStreamReaderTests.LONG_TEXT, result)
        
        do {
            //writer already closed
            try writer.write("aaa")
            XCTFail()
        } catch {
            //OK ErrorWritingIntoStream
        }
    }
    
    
    func test_Append() {
        let url = URL(fileURLWithPath: NSTemporaryDirectory() + "file_testAppend.txt")
        try? FileManager.default.removeItem(at: url)
        
        let reader = try! StringReader(InputStreamReaderTests.LONG_TEXT, bufferSize: 1)
        
        var count = 0
        
        try! reader.readAll() {
            let writer = try! FileWriter(url, append: true)
            try! writer.write($0)
            writer.close()
            //double close is ok
            writer.close()
            count += 1
        }
        
        let result = try! String(contentsOf: url, encoding: .utf8)
        
        XCTAssertTrue(count > 0)
        XCTAssertEqual(InputStreamReaderTests.LONG_TEXT, result)
    }
    
    
    func test_NotWritable() {
        let url = URL(fileURLWithPath: "/root1/test.txt")
        do {
            let writer = try FileWriter(url, append: true)
            try writer.write("aaaa")
            XCTFail()
        } catch {
            //OK
        }
    }
    
    func test_NotWritable2() {
        let url = URL(string: "http://")!
        do {
            _ = try FileWriter(url)
            XCTFail()
        } catch {
            //OK
        }
    }

    func test_WrongEncoding() {
        let writer = try! FileWriter(URL(fileURLWithPath: "/root1/test.txt"), encoding: .ascii)
        do {
            try writer.write("ČŘŠŤĎŇ")
            XCTFail()
        } catch {
            //OK
        }
    }
    func test_Description() {
        let w1 = try! FileWriter(URL(fileURLWithPath: "/root1/test.txt"))
        XCTAssertEqual("FileWriter: file:///root1/test.txt", "\(w1)")
        
        let w2 = try! FileWriter(URL(fileURLWithPath: "/root1/test.txt"), description: "MyFile")
        XCTAssertEqual("FileWriter: MyFile", "\(w2)")
    }
}

