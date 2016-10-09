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

class MessageDigestMD2Tests: XCTestCase
{
    static let LONG_TEXT = "Knowing that millions of people around the world would be watching in person and on television and expecting great things from him — at least one more gold medal for America, if not another world record — during this, his fourth and surely his last appearance in the World Olympics, and realizing that his legs could no longer carry him down the runway with the same blazing speed and confidence in making a huge, eye-popping leap that they were capable of a few years ago when he set world records in the 100-meter dash and in the 400-meter relay and won a silver medal in the long jump, the renowned sprinter and track-and-field personality Carl Lewis, who had known pressure from fans and media before but never, even as a professional runner, this kind of pressure, made only a few appearances in races during the few months before the Summer Olympics in Atlanta, Georgia, partly because he was afraid of raising expectations even higher and he did not want to be distracted by interviews and adoring fans who would follow him into stores and restaurants demanding autographs and photo-opportunities, but mostly because he wanted to conserve his energies and concentrate, like a martial arts expert, on the job at hand: winning his favorite competition, the long jump, and bringing home another Gold Medal for the United States, the most fitting conclusion to his brilliant career in track and field."
    
    let tests = [
        (string: "",                                hash: "8350e5a3e24c153df2275c9f80692773", bytes: 0),
        (string: "1",                               hash: "c92c0babdc764d8674bcea14a55d867d", bytes: 1),
        (string: "longer text",                     hash: "34c6122993d4656883d974c811f1f2aa", bytes: 11),
        (string: "ČŘ",                              hash: "59819634d0bdd913f012997aa7337d08", bytes: 4),
        (string: InputStreamReaderTests.LONG_TEXT,  hash: "b13f39e3887566e149618cc22577d837", bytes: 6437),
        (string: MessageDigestMD2Tests.LONG_TEXT,   hash: "d59ea64b962ab4ae14d0acae98578aaf", bytes: 1408),
    ]
    
    func test_Simple() {
        let digest = MessageDigestProvider.MD2
        
        //make sure .MDX property always returns a new object
        XCTAssert(digest as AnyObject !== MessageDigestProvider.MD2 as AnyObject)
        
        for test in tests {
            //try string hash
            XCTAssertEqual(test.hash, try! digest.hash(of: test.string))
            
            
            //try input stream hash
            let digest2 = MessageDigestProvider.MD2
            let stream = MessageDigestInputStream(InputStream(data: test.string.data(using: .utf8)!), digest: digest2)
            try? stream.readAll() {
                (data: Data) in
            }

            XCTAssertEqual(test.hash, digest2.hash())
            XCTAssertEqual(test.hash, stream.hash())
        }
    }

    func test_File() {
        let filePath = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("random.dat", isDirectory: false)

        let digest = MessageDigestProvider.MD2
        let stream = MessageDigestInputStream(InputStream(url: filePath)!, digest: digest)
        
        try? stream.readAll() {
            (data: Data) in
        }
        
        XCTAssertEqual(digest.hash(), "745059d5ca5f67615d28e6a5dd6d443c")
        XCTAssertEqual(stream.hash(), "745059d5ca5f67615d28e6a5dd6d443c")
    }
    
    
    func test_Performance() {
        let filePath = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("random.dat", isDirectory: false)
        
        let data = try! Data(contentsOf: filePath)
  
        self.measure {
            let digest = MessageDigestProvider.MD2
            for _ in 0 ..< 1000 {
                digest.update(data: data)
            }
            XCTAssertEqual(digest.hash(), "a7db6f124f975071debd1e32eb1dff8e")
        }
        
    }
}
