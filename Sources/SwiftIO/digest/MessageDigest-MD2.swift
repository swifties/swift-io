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
 
 Created by dusan@saiko.cz on 2/10/16.
 */

import Foundation

public final class MessageDigestMD2: MessageDigestBase {

    // state, 48 ints
    var X = [Int]()
    
    // checksum, 16 ints. 
    var C = [Int]()

    public required init() {
        super.init()

        self.blockSize = 16
    }
    
    public required convenience init(copyOf other: MessageDigestMD2) {
        self.init()
        
        self.bytesProcessed = other.bytesProcessed
        self.buffer = other.buffer
        self.X = other.X
        self.C = other.C
    }
    
    public override func copy() -> MessageDigest {
        return type(of: self).init(copyOf: self)
    }
    
    override public func reset() {
        super.reset()
        
        X = [Int](repeating: 0, count: 48)
        C = [Int](repeating: 0, count: 16)
    }
    
    override func update(offset: Int) {
        var t = C[15]

        for i in 0 ..< 16 {
            let k = Int(buffer[offset + i])
            X[16 + i] = k
            X[32 + i] = k ^ X[i]

            C[i] ^= MessageDigestMD2.S[X[16 + i] ^ t]
            t = C[i]
        }
        
        t = 0
        for i in 0 ..< 18 {
            for j in 0 ..< 48 {
                X[j] ^= MessageDigestMD2.S[t]
                t = X[j]
            }
            t = (t + i) & 0xff
        }
    }

    public override func finishAndReturnHash() -> Data {
        let padValue = Int(16 - (bytesProcessed & 15))
        update(data: MessageDigestMD2.PADDING[padValue])

        var cBytes = Data(capacity: 16)
        for i in 0 ..< 16 {
            cBytes.append(UInt8(C[i]))
        }

        update(data: cBytes)
        let hash = X.map() { UInt8($0) }.prefix(16)
        
        reset()
        
        return Data(hash)
    }
    
    static private let S: [Int] = [
        41, 46, 67, 201, 162, 216, 124, 1, 61, 54, 84, 161, 236, 240, 6,
        19, 98, 167, 5, 243, 192, 199, 115, 140, 152, 147, 43, 217, 188,
        76, 130, 202, 30, 155, 87, 60, 253, 212, 224, 22, 103, 66, 111, 24,
        138, 23, 229, 18, 190, 78, 196, 214, 218, 158, 222, 73, 160, 251,
        245, 142, 187, 47, 238, 122, 169, 104, 121, 145, 21, 178, 7, 63,
        148, 194, 16, 137, 11, 34, 95, 33, 128, 127, 93, 154, 90, 144, 50,
        39, 53, 62, 204, 231, 191, 247, 151, 3, 255, 25, 48, 179, 72, 165,
        181, 209, 215, 94, 146, 42, 172, 86, 170, 198, 79, 184, 56, 210,
        150, 164, 125, 182, 118, 252, 107, 226, 156, 116, 4, 241, 69, 157,
        112, 89, 100, 113, 135, 32, 134, 91, 207, 101, 230, 45, 168, 2, 27,
        96, 37, 173, 174, 176, 185, 246, 28, 70, 97, 105, 52, 64, 126, 15,
        85, 71, 163, 35, 221, 81, 175, 58, 195, 92, 249, 206, 186, 197,
        234, 38, 44, 83, 13, 110, 133, 40, 132, 9, 211, 223, 205, 244, 65,
        129, 77, 82, 106, 220, 55, 200, 108, 193, 171, 250, 36, 225, 123,
        8, 12, 189, 177, 74, 120, 136, 149, 139, 227, 99, 232, 109, 233,
        203, 213, 254, 59, 0, 29, 57, 242, 239, 183, 14, 102, 88, 208, 228,
        166, 119, 114, 248, 235, 117, 75, 10, 49, 68, 80, 180, 143, 237,
        31, 26, 219, 153, 141, 51, 159, 17, 131, 20,
    ]
    
    
    // digest padding. 17 element array.
    // padding[0] is null
    // padding[i] is an array of i time the byte value i (i = 1..16)
    static private let PADDING: [ Data ] = {
        var result = [ Data ](repeating: Data(), count: 17)
        for i in 1 ..< 17 {
            result[i] = Data([UInt8](repeating: UInt8(i), count: i))
        }
        
        return result
    }()
}
