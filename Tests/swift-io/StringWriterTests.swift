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
        try! stream.close()

        XCTAssertEqual(stream.string, s1+s2)
    }
}
