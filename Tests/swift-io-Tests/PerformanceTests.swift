//
//  PerformanceTests.swift
//  swift-io
//
//  Created by Dusan Saiko on 29/08/16.
//
//

import Foundation
import XCTest

@testable import swift_io

class PerformanceTests: XCTestCase
{
    func test_BigFile() {
        let filePath = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("big.txt", isDirectory: false)


//        self.measure {
            let reader = try! BufferedReader(FileReader(filePath))
            var lines = 0
            
            try! reader.readAllLines() {
                (line: String) in
                    lines += 1
            }
            XCTAssertEqual(lines, 642285)
//        }
    }
}
