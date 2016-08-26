////
////  FileReaderTests.swift
////  swift-io
////
////  Created by Dusan Saiko on 06/08/16.
////
////
//
//import XCTest
//@testable import swift_io
//
//class FileReaderTests: XCTestCase
//{
//    func test_FileReader()
//    {
//        let path = NSTemporaryDirectory() + "file.txt"
//        let writer = try! FileWriter(path)
//
//        try! writer.write(StringReaderTests.TEST_STRING)
//        try! writer.close()
//        
//        
//        var buffer = [UInt8](repeating: 0, count: 1024 * 8)
//        let reader = try! FileReader(path)
//        
////        let count = try! reader.read(&buffer)!
////        let data = Data(bytes: buffer, count: count)
////        let string = String(data: data, encoding: StringWriter.DEFAUTL_ENCODING)
////
////        XCTAssertEqual(data.count, StringReaderTests.TEST_STRING.data(using: StringWriter.DEFAUTL_ENCODING)!.count)
////        
////        XCTAssertEqual(StringReaderTests.TEST_STRING, string)
//    }
//    
//    
//    func test_FileReaderNotExist()
//    {
////        let path = NSTemporaryDirectory() + "fileX.txt"
////        let reader = try! FileReader(path)
////        var buffer = [UInt8](repeating: 0, count: 1024 * 8)
////        do {
////            _ = try reader.read(&buffer)!
////            XCTFail()
////        } catch IOException.ErrorReadingFromStream(_, _) {
////            //expected
////        } catch {
////            XCTFail()
////        }
//        
//    }
//
//    func test_InvalidURL()
//    {
//        do {
//            _ = try FileReader(URL(string: "unknown://file.txt")!)
//            XCTFail()
//        } catch IOException.FileIsNotReadable(_) {
//            //expected
//        } catch {
//            XCTFail()
//        }
//        
//    }
//
//}
