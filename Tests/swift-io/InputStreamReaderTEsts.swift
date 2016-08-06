//
//  InputStreamReaderTEsts.swift
//  swift-io
//
//  Created by Dusan Saiko on 06/08/16.
//
//


import XCTest
@testable import swift_io

class InputStreamReaderTests: XCTestCase
{
    func test_PlainStream() {
        let reader = InputStreamReader(InputStream(data: Data("test".utf8)))
        XCTAssert(reader.sourceDescription.characters.count > 0)
        
        try! reader.close()
        
        var buffer = [UInt8](repeating: 0, count: 1024 * 8)
        do {
            _ = try reader.read(&buffer)
            XCTFail()
        } catch IOException.StreamAlreadyClosed(_) {
            //expected
        } catch  {
            XCTFail()
        }
   }
    
    func test_EmptyFile() {
        let path = NSTemporaryDirectory() + "file.txt"
        FileManager.default.createFile(atPath: path, contents: nil, attributes: [:])

        let reader = try! FileReader(path)
        
        var buffer = [UInt8](repeating: 0, count: 1024 * 8)
        let count = try! reader.read(&buffer)
        XCTAssertNil(count)
    }
}
