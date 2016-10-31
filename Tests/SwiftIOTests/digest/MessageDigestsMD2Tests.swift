//
//  MessageDigestsMD2Tests.swift
//  swift-io
//
//  Created by Dusan Saiko on 02/10/2016.
//
//

import Foundation

import Foundation
import XCTest
@testable import SwiftIO

class MessageDigestMD2Tests: MessageDigestTests
{
    
    let provider: ((Void) -> MessageDigest) = {
        return MessageDigestImpl.md2
    }
  
    let tests: [HashResult] = [
        HashResult(text: "",                                hash: "8350e5a3e24c153df2275c9f80692773", bytes: 0),
        HashResult(text: "1",                               hash: "c92c0babdc764d8674bcea14a55d867d", bytes: 1),
        HashResult(text: "longer text",                     hash: "34c6122993d4656883d974c811f1f2aa", bytes: 11),
        HashResult(text: "ČŘ",                              hash: "59819634d0bdd913f012997aa7337d08", bytes: 4),
        HashResult(text: InputStreamReaderTests.LONG_TEXT,  hash: "b13f39e3887566e149618cc22577d837", bytes: 6437),
        HashResult(text: MessageDigestTests.LONG_TEXT,      hash: "d59ea64b962ab4ae14d0acae98578aaf", bytes: 1408),
    ]
    
    func test_Simple() {
        test_Simple(results: tests, provider: provider)
    }

    func test_File() {
        test_File(provider: provider, hash: "745059d5ca5f67615d28e6a5dd6d443c")
    }
    
    func test_Performance() {
        test_Performance(measure: true, count: 1000, provider: provider, hash: "a7db6f124f975071debd1e32eb1dff8e")
    }
}
