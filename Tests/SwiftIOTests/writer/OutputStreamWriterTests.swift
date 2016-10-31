//
//  OutputStreamWriterTests.swift
//  swift-io
//
//  Created by Dusan Saiko on 21/09/16.
//
//

import Foundation

import Foundation
import XCTest
@testable import SwiftIO

class OutputStreamWriterTests: XCTestCase
{
    
    func test_InterruptedWrite() {
        class TempStream: OutputStream {
            var bytesWritten = 0
            var broken = false

            override var streamError: Error? {
                    return Exception.MethodNotImplemented
            }

            override func open() {

            }

            override func close() {

            }

            override func write(_ buffer: UnsafePointer<UInt8>, maxLength len: Int) -> Int {
                if(broken) {
                    return -1
                }

                //lets simulate only one byte is written
                bytesWritten += 1
                return 1
            }
            
            override var streamStatus: Stream.Status {
                    return .open
            }

            func breakStream() {
                broken = true
            }
        }

        let stream = TempStream()
        let writer = OutputStreamWriter(stream)
        let data = "Ahoj"

        //test write
        try! writer.write(data)

        XCTAssertEqual(data.characters.count, stream.bytesWritten)

        stream.breakStream()
        do {
            try writer.write(data)
            XCTFail()
        } catch {
            //expected
        }


    }
}
