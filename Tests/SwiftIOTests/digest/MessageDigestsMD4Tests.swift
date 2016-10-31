//
//  MessageDigestsMD4Tests.swift
//  swift-io
//
//  Created by Dusan Saiko on 01/11/2016.
//
//

import Foundation

import Foundation
import XCTest
@testable import SwiftIO

class MessageDigestMD4Tests: MessageDigestTests
{
    
    let provider: ((Void) -> MessageDigest) = {
        return MessageDigestImpl.md4
    }
    
    let tests: [HashResult] = [
        HashResult(text: "",                                hash: "31d6cfe0d16ae931b73c59d7e0c089c0", bytes: 0),
    ]
    
    func test_Simple() {
        test_Simple(results: tests, provider: provider)
    }
}
