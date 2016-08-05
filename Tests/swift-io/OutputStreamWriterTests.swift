//
//  OutputStreamWriterTests.swift
//  swift-io
//
//  Created by Dusan Saiko on 05/08/16.
//
//

import Foundation
import XCTest
@testable import swift_io

class OutputStreamWriterTests: XCTestCase
{
    
    func test_PlainStream() {
        let writer = OutputStreamWriter(NSOutputStream.toMemory())
        XCTAssert(writer.sourceDescription.characters.count > 0)
        
        let data: [UInt8] = [1,2,3]
        
        //test write
        try! writer.write(data, startIndex: 0, count: 3)

        //wrong index
        do {
            try writer.write(data, startIndex: -1, count: 1)
            XCTFail()
        } catch Exception.RangeException(_, _) {
            //expected
        } catch {
            XCTFail()
        }

        //wrong count
        do {
            try writer.write(data, startIndex: 0, count: 4)
            XCTFail()
        } catch Exception.RangeException(_, _) {
            //expected
        } catch {
            XCTFail()
        }
    }
    
    func test_InterruptedWrite() {
        class TempStream: NSOutputStream {
            var bytesWritten = 0
            var broken = false
            
            private override var streamError: Error? {
                get {
                    return Exception.MethodNotImplemented
                }
            }
            
            private override func open() {
                
            }
            
            private override func close() {
                
            }
            
            private override func write(_ buffer: UnsafePointer<UInt8>, maxLength len: Int) -> Int {
                if(broken) {
                    return -1
                }
                
                //lets simulate only one byte is written
                bytesWritten += 1
                return 1
            }
            
            func breakStream() {
                broken = true
            }
        }
        
        let stream = TempStream()
        let writer = OutputStreamWriter(stream)
        let data: [UInt8] = [1,2,3]
        
        //test write
        try! writer.write(data)
        
        XCTAssertEqual(data.count, stream.bytesWritten)
        
        stream.breakStream()
        do {
            try writer.write(data)
            XCTFail()
        } catch IOException.ErrorWritingIntoStream(_, _) {
            //expected
        } catch {
            XCTFail()
        }
        
        
    }
}
