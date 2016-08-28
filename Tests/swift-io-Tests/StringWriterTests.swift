////
////  StringWriterTests.swift
////  Created by dusan@saiko.cz on 06/07/16.
//
//import Foundation
//import XCTest
//@testable import swift_io
//
//class StringWriterTests: XCTestCase
//{
//    
//    func test_SimpleAddition() {
//        let writer = StringWriter()
//        
//        let s1 = "Text "
//        let s2 = "News"
//        
//        writer.write(s1)
//        writer.write(s2)
//        
//        writer.close()
//        writer.close()
//
//        XCTAssertEqual(writer.stringBuffer, s1 + s2)
//        
//        //wrong index
//        do {
//            try writer.write(Array(s1.utf8), startIndex: -1, count: 1)
//            XCTFail()
//        } catch Exception.RangeException(_, _) {
//            //expected
//        } catch {
//            XCTFail()
//        }
//        
//        //wrong count
//        do {
//            try writer.write(Array(s1.utf8), startIndex: 0, count: 16)
//            XCTFail()
//        } catch Exception.RangeException(_, _) {
//            //expected
//        } catch {
//            XCTFail()
//        }
//    }
//    
//    func test_InvalidEncoding() {
//        let writer = StringWriter(dataEncoding: .utf8)
//        do {
//            let data: [UInt8] = [255] //invalid utf8 data
//            try writer.write(data)
//            print(writer.stringBuffer)
//            XCTFail()
//        } catch Exception.InvalidDataEncoding(_, _) {
//            //expected
//        } catch {
//            XCTFail()
//        }
//    }
//
//}
