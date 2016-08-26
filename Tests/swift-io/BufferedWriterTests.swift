////
////  BufferedWriterTests.swift
////  swift-io
////
////  Created by Dusan Saiko on 04/08/16.
////
////
//
//import Foundation
//
//import XCTest
//@testable import swift_io
//
//class BufferedWriterTests: XCTestCase
//{
//
//    func test_BufferedWriteTrough() {
//        let stringWriter = StringWriter()
//        let writer = BufferedWriter(stringWriter, bufferSize: 0)
//        try! writer.write("1")
//        XCTAssertEqual(stringWriter.stringBuffer, "1")
//    }
// 
//    func test_BufferedWrite() {
//        let stringWriter = StringWriter()
//        let writer = BufferedWriter(stringWriter, bufferSize: 5)
//        
//        //write into buffer
//        try! writer.write("1234")
//        XCTAssertEqual(stringWriter.stringBuffer, "")
//        
//        //force buffer to flush
//        try! writer.write("56")
//        XCTAssertEqual(stringWriter.stringBuffer, "123456")
//        
//        //weirw into buffer
//        try! writer.write("78")
//        XCTAssertEqual(stringWriter.stringBuffer, "123456")
//        
//        //flush
//        try! writer.flush()
//        XCTAssertEqual(stringWriter.stringBuffer, "12345678")
//    }
//
//    
//}
