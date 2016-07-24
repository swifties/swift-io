//
//  StringWriterTests.swift
//  Created by dusan@saiko.cz on 06/07/16.

import Foundation
import XCTest
@testable import swift_io

class StringWriterTests: XCTestCase
{
    
    func test_SimpleAddition() {
        let stream = StringWriter()
        
        let s1 = "Text "
        let s2 = "News"
        
        try! stream.write(string: s1)
        try! stream.write(string: s2)
        
        try! stream.close()
        try! stream.close() //double close is OK
        
        do {
            try stream.flush()
            XCTAssertTrue(false) //unreachable - dlouble flush will fail
        } catch IOException.StreamAlreadyClosed {
            XCTAssertTrue(true) //this is fine
        } catch {
            XCTAssertTrue(false) //unknown exception?
        }
        
        XCTAssertEqual(stream.string, s1+s2)
    }
}
