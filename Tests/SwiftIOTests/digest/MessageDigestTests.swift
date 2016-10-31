//
//  MessageDigestTests.swift
//  swift-io
//
//  Created by Dusan Saiko on 02/10/2016.
//
//

import Foundation
import XCTest
@testable import SwiftIO

class MessageDigestTests: XCTestCase
{
    struct  HashResult {
        let text: String
        let hash: String
        let bytes: Int
    }
    
    static let LONG_TEXT = "Knowing that millions of people around the world would be watching in person and on television and expecting great things from him — at least one more gold medal for America, if not another world record — during this, his fourth and surely his last appearance in the World Olympics, and realizing that his legs could no longer carry him down the runway with the same blazing speed and confidence in making a huge, eye-popping leap that they were capable of a few years ago when he set world records in the 100-meter dash and in the 400-meter relay and won a silver medal in the long jump, the renowned sprinter and track-and-field personality Carl Lewis, who had known pressure from fans and media before but never, even as a professional runner, this kind of pressure, made only a few appearances in races during the few months before the Summer Olympics in Atlanta, Georgia, partly because he was afraid of raising expectations even higher and he did not want to be distracted by interviews and adoring fans who would follow him into stores and restaurants demanding autographs and photo-opportunities, but mostly because he wanted to conserve his energies and concentrate, like a martial arts expert, on the job at hand: winning his favorite competition, the long jump, and bringing home another Gold Medal for the United States, the most fitting conclusion to his brilliant career in track and field."
    
    
    func test_Simple(results: [HashResult], provider: ((Void) -> MessageDigest)) {
        let digest = provider()
        
        //make sure .MDX property always returns a new object
        XCTAssert(digest as AnyObject !== provider() as AnyObject)
        
        for test in results {
            //try string hash
            XCTAssertEqual(test.hash, try! digest.hash(of: test.text))
            
            //try input stream hash
            let digest2 = provider()
            let stream = MessageDigestInputStream(InputStream(data: test.text.data(using: .utf8)!), digest: digest2)
            try? stream.readAll() {
                (data: Data) in
            }
            
            XCTAssertEqual(test.hash, digest2.hash())
            XCTAssertEqual(test.hash, stream.hash())
        }
    }
    
    func test_File(provider: ((Void) -> MessageDigest), hash: String) {
        let filePath = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("random.dat", isDirectory: false)
        
        let digest = provider()
        let stream = MessageDigestInputStream(InputStream(url: filePath)!, digest: digest)
        
        try? stream.readAll() {
            (data: Data) in
        }
        
        XCTAssertEqual(digest.hash(), hash)
        XCTAssertEqual(stream.hash(), hash)
    }

    func test_Performance(measure: Bool, count: Int, provider: @escaping ((Void) -> MessageDigest), hash: String) {
        let filePath = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("random.dat", isDirectory: false)
        
        let data = try! Data(contentsOf: filePath)
        
        if(measure) {
            self.measure {
                let digest = provider()
                for _ in 0 ..< count {
                    digest.update(data: data)
                }
                XCTAssertEqual(digest.hash(), hash)
            }
        } else {
            let digest = provider()
            for _ in 0 ..< count {
                digest.update(data: data)
            }
            XCTAssertEqual(digest.hash(), hash)
        }
    }

}
