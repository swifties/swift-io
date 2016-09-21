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
@testable import swift_io

class OutputStreamWriterTests: XCTestCase
{
    
    func test_InterruptedWrite() {
        class TempStream: OutputStream {
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
            
            private override var streamStatus: Stream.Status {
                get {
                    return .open
                }
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
