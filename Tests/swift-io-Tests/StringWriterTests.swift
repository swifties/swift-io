//
//  StringWriterTests.swift
//  Created by dusan@saiko.cz on 06/09/16.

import Foundation
import XCTest
@testable import swift_io

class StringWriterTests: XCTestCase
{
    
    func test_SimpleWriter() {
        let reader = try! StringReader(InputStreamReaderTests.LONG_TEXT, bufferSize: 1)
        let writer = StringWriter()

        var count = 0

        try! reader.readAll() {
            writer.write($0)
            count += 1
        }

        writer.close()
        
        XCTAssertEqual(InputStreamReaderTests.LONG_TEXT, writer.buffer)
        XCTAssertTrue(count > 0)
    }
}
