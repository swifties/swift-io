//
//  FileReaderTests.swift
//  swift-io
//
//  Created by Dusan Saiko on 06/08/16.
//
//

import XCTest
@testable import swift_io

class FileReaderTests: XCTestCase
{
    func test_FileReader()
    {
        let path = URL(fileURLWithPath: NSTemporaryDirectory() + "file.txt")
        try! BufferedReaderTests.TEST_STRING.data(using: .utf8)?.write(to: path)
        
        let reader = try! FileReader(path)
        XCTAssertEqual(BufferedReaderTests.TEST_STRING, try! reader.readAll())
    }
    
    
    func test_FileReaderNotExist()
    {
        let path = URL(fileURLWithPath: NSTemporaryDirectory() + "fileX.txt")
        let reader = try! FileReader(path)
        
        do {
            _ = try reader.readAll()
            XCTFail()
        } catch IOException.ErrorReadingFromStream(_, _) {
            //expected
        } catch {
            XCTFail()
        }
        
    }

    func test_InvalidURL()
    {
        do {
            _ = try FileReader(URL(string: "unknown://file.txt")!)
            XCTFail()
        } catch IOException.URLIsNotReadable(_) {
            //expected
        } catch {
            XCTFail()
        }
        
    }

}
