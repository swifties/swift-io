/**
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 
 Created by dusan@saiko.cz on 31/10/16.
 */

import Foundation

public final class MessageDigestMD4: MessageDigestBase {
 
    // state
    var state = [Int]()
    
    // temporary buffer
    var x = [Int]()
    
    public required init() {
        super.init()
        
        self.blockSize = 64
    }
    
    public required convenience init(copyOf other: MessageDigestMD4) {
        self.init()
        
        self.bytesProcessed = other.bytesProcessed
        self.buffer = other.buffer
        self.state = other.state
        self.x = other.x
    }
    
    public override func copy() -> MessageDigest {
        return type(of: self).init(copyOf: self)
    }
    
    override public func reset() {
        super.reset()
        
        x = [Int](repeating: 0, count: 16)
        
        state = [Int](repeating: 0, count: 4)
        state[0] = 0x67452301
        state[1] = 0xefcdab89
        state[2] = 0x98badcfe
        state[3] = 0x10325476
    }
    
    
    private static func FF(_ a: Int, _ b: Int, _ c: Int, _ d: Int, _ x: Int, _ s: Int) -> Int {
        let aa = a + ((b & c) | ((~b) & d)) + x
        return ((aa << s) | (aa >> (32 - s)))
    }
    
    private static func GG(_ a: Int, _ b: Int, _ c: Int, _ d: Int, _ x: Int, _ s: Int) -> Int {
        let aa = a + ((b & c) | (b & d) | (c & d)) + x + 0x5a827999
        return ((aa << s) | (aa >> (32 - s)))
    }
    
    private static func HH(_ a: Int, _ b: Int, _ c: Int, _ d: Int, _ x: Int, _ s: Int) -> Int {
        let aa = a + ((b ^ c) ^ d) + x + 0x6ed9eba1
        return ((aa << s) | (aa >> (32 - s)))
    }
    
    override func update(offset: Int) {
        b2iLittle(source: buffer, sourceOffset: offset, length: self.blockSize, target: &x, targetOffset: 0)
        
        var a = state[0]
        var b = state[1]
        var c = state[2]
        var d = state[3]
        
        /* Round 1 */
        a = MessageDigestMD4.FF(a, b, c, d, x[ 0], MessageDigestMD4.S11) /* 1 */
        d = MessageDigestMD4.FF(d, a, b, c, x[ 1], MessageDigestMD4.S12) /* 2 */
        c = MessageDigestMD4.FF(c, d, a, b, x[ 2], MessageDigestMD4.S13) /* 3 */
        b = MessageDigestMD4.FF(b, c, d, a, x[ 3], MessageDigestMD4.S14) /* 4 */
        a = MessageDigestMD4.FF(a, b, c, d, x[ 4], MessageDigestMD4.S11) /* 5 */
        d = MessageDigestMD4.FF(d, a, b, c, x[ 5], MessageDigestMD4.S12) /* 6 */
        c = MessageDigestMD4.FF(c, d, a, b, x[ 6], MessageDigestMD4.S13) /* 7 */
        b = MessageDigestMD4.FF(b, c, d, a, x[ 7], MessageDigestMD4.S14) /* 8 */
        a = MessageDigestMD4.FF(a, b, c, d, x[ 8], MessageDigestMD4.S11) /* 9 */
        d = MessageDigestMD4.FF(d, a, b, c, x[ 9], MessageDigestMD4.S12) /* 10 */
        c = MessageDigestMD4.FF(c, d, a, b, x[10], MessageDigestMD4.S13) /* 11 */
        b = MessageDigestMD4.FF(b, c, d, a, x[11], MessageDigestMD4.S14) /* 12 */
        a = MessageDigestMD4.FF(a, b, c, d, x[12], MessageDigestMD4.S11) /* 13 */
        d = MessageDigestMD4.FF(d, a, b, c, x[13], MessageDigestMD4.S12) /* 14 */
        c = MessageDigestMD4.FF(c, d, a, b, x[14], MessageDigestMD4.S13) /* 15 */
        b = MessageDigestMD4.FF(b, c, d, a, x[15], MessageDigestMD4.S14) /* 16 */
        
        /* Round 2 */
        a = MessageDigestMD4.GG(a, b, c, d, x[ 0], MessageDigestMD4.S21) /* 17 */
        d = MessageDigestMD4.GG(d, a, b, c, x[ 4], MessageDigestMD4.S22) /* 18 */
        c = MessageDigestMD4.GG(c, d, a, b, x[ 8], MessageDigestMD4.S23) /* 19 */
        b = MessageDigestMD4.GG(b, c, d, a, x[12], MessageDigestMD4.S24) /* 20 */
        a = MessageDigestMD4.GG(a, b, c, d, x[ 1], MessageDigestMD4.S21) /* 21 */
        d = MessageDigestMD4.GG(d, a, b, c, x[ 5], MessageDigestMD4.S22) /* 22 */
        c = MessageDigestMD4.GG(c, d, a, b, x[ 9], MessageDigestMD4.S23) /* 23 */
        b = MessageDigestMD4.GG(b, c, d, a, x[13], MessageDigestMD4.S24) /* 24 */
        a = MessageDigestMD4.GG(a, b, c, d, x[ 2], MessageDigestMD4.S21) /* 25 */
        d = MessageDigestMD4.GG(d, a, b, c, x[ 6], MessageDigestMD4.S22) /* 26 */
        c = MessageDigestMD4.GG(c, d, a, b, x[10], MessageDigestMD4.S23) /* 27 */
        b = MessageDigestMD4.GG(b, c, d, a, x[14], MessageDigestMD4.S24) /* 28 */
        a = MessageDigestMD4.GG(a, b, c, d, x[ 3], MessageDigestMD4.S21) /* 29 */
        d = MessageDigestMD4.GG(d, a, b, c, x[ 7], MessageDigestMD4.S22) /* 30 */
        c = MessageDigestMD4.GG(c, d, a, b, x[11], MessageDigestMD4.S23) /* 31 */
        b = MessageDigestMD4.GG(b, c, d, a, x[15], MessageDigestMD4.S24) /* 32 */
        
        /* Round 3 */
        a = MessageDigestMD4.HH(a, b, c, d, x[ 0], MessageDigestMD4.S31) /* 33 */
        d = MessageDigestMD4.HH(d, a, b, c, x[ 8], MessageDigestMD4.S32) /* 34 */
        c = MessageDigestMD4.HH(c, d, a, b, x[ 4], MessageDigestMD4.S33) /* 35 */
        b = MessageDigestMD4.HH(b, c, d, a, x[12], MessageDigestMD4.S34) /* 36 */
        a = MessageDigestMD4.HH(a, b, c, d, x[ 2], MessageDigestMD4.S31) /* 37 */
        d = MessageDigestMD4.HH(d, a, b, c, x[10], MessageDigestMD4.S32) /* 38 */
        c = MessageDigestMD4.HH(c, d, a, b, x[ 6], MessageDigestMD4.S33) /* 39 */
        b = MessageDigestMD4.HH(b, c, d, a, x[14], MessageDigestMD4.S34) /* 40 */
        a = MessageDigestMD4.HH(a, b, c, d, x[ 1], MessageDigestMD4.S31) /* 41 */
        d = MessageDigestMD4.HH(d, a, b, c, x[ 9], MessageDigestMD4.S32) /* 42 */
        c = MessageDigestMD4.HH(c, d, a, b, x[ 5], MessageDigestMD4.S33) /* 43 */
        b = MessageDigestMD4.HH(b, c, d, a, x[13], MessageDigestMD4.S34) /* 44 */
        a = MessageDigestMD4.HH(a, b, c, d, x[ 3], MessageDigestMD4.S31) /* 45 */
        d = MessageDigestMD4.HH(d, a, b, c, x[11], MessageDigestMD4.S32) /* 46 */
        c = MessageDigestMD4.HH(c, d, a, b, x[ 7], MessageDigestMD4.S33) /* 47 */
        b = MessageDigestMD4.HH(b, c, d, a, x[15], MessageDigestMD4.S34) /* 48 */
        
        state[0] += a
        state[1] += b
        state[2] += c
        state[3] += d
    }
    
    override public func finishAndReturnHash() -> Data {
        let bitsProcessed = bytesProcessed << 3
        let index = Int(bytesProcessed & 0x3f)
        let padLen = (index < 56) ? (56 - index) : (120 - index)
        
        update(data: MessageDigestBase.defaultPadding.subdata(in: 0 ..< padLen))

        var sufix = Data(count: 8)
        i2bLittle(source: [Int(bitsProcessed)], sourceOffset: 0, length: 1, target: &sufix, targetOffset: 0)
        i2bLittle(source: [Int(bitsProcessed >> 32)], sourceOffset: 0, length: 1, target: &sufix, targetOffset: 4)
        
        update(data: sufix)

        var hash = Data(count: 16)
        i2bLittle(source: state, sourceOffset: 0, length: 4, target: &hash, targetOffset: 0)

        return hash
    }

    
    static private let S11 = 3
    static private let S12 = 7
    static private let S13 = 11
    static private let S14 = 19
    static private let S21 = 3
    static private let S22 = 5
    static private let S23 = 9
    static private let S24 = 13
    static private let S31 = 3
    static private let S32 = 9
    static private let S33 = 11
    static private let S34 = 15
}
