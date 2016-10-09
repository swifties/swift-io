//
//  PerformanceTests.swift
//  swift-io
//
//  Created by Dusan Saiko on 29/08/16.
//
//

import Foundation
import XCTest

@testable import SwiftIO

class PerformanceTests: XCTestCase
{
    func test_BigFile() {
        let filePath = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("big.txt", isDirectory: false)

//TODO: uncomment self.measure block if you want to measure performance
//Note: How to profile performance using Xcode:
//      - set debug mode for tests
//      - place breakpoint at the start of the test method
//      - start tests, will stop at the breakpoint
//      - open instruments - Time Profiler
//      - attach ctest process to the profiler
//      - resume testing
        
//        self.measure {
            let reader = try! BufferedReader(FileReader(filePath))
            var lines = 0
            
            try! reader.readAllLines() {
                (line: String) in
                    lines += 1
            }
            XCTAssertEqual(lines, 1284570)
//        }
    }
}
