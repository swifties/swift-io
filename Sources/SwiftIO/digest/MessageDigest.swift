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

public final class MessageDigestImpl {
    static public var md2: MessageDigest { return MessageDigestMD2() }
    static public var md4: MessageDigest { return MessageDigestMD4() }
}

/**
  This class defines MessageDisgest protocol, which provides the functionality
  of a message digest algorithm, such as MD5 or SHA. Message digests are
  secure one-way hash functions that take arbitrary-sized data and output a
  fixed-length hash value.
**/
public protocol MessageDigest: class {
  
    /**
     - Returns: Size of data block to be processed.
     */
    var blockSize: Int { get }

    /**
     - Returns: total bytes processed
    */
    var bytesProcessed: UInt64 { get }

    /**
     Update the digest using the specified Data.
    */
    func update(data: Data)
    
    /**
     Completes the hash computation by performing final
     operations such as padding. Once has been called, the engine should be reset.
     Resetting is the responsibility of the engine implementor.
     
     - Returns: The array of bytes for the resulting hash value.
    */
    func finishAndReturnHash() -> Data
    
    /**
     copy method
    */
    func copy() -> MessageDigest
    
    /**
     reset the digest to initial state
    */
    func reset()
}

public extension MessageDigest {
    
    public func finishAndReturnHash() -> String {
        let data: Data = finishAndReturnHash()
        
        var hash = ""
        for index in 0 ..< data.count {
            hash += String(format: "%02x", data[index])
        }
        
        return hash
    }
    
    public func hash(of s: String, encoding: String.Encoding = DEFAULT_ENCODING) throws -> String {
        reset()
        
        if let data = s.data(using: encoding) {
            update(data: data)
            return hash()
        }
        
        throw Exception.InvalidStringEncoding(string: s, requestedEncoding: encoding, description: nil)
    }
    
    public func hash() -> String {
        return copy().finishAndReturnHash()
    }
    
    public func hash() -> Data {
        return copy().finishAndReturnHash()
    }
    
    public func hash(stream: InputStream) -> String {
        return hash(stream: DelegatingInputStream(stream))
    }
    
    public func hash(stream: InputStreamSupport) -> String {
        reset()
        let stream = MessageDigestInputStream(stream, digest: self)
        
        try? stream.readAll() {
            (data: Data) in
        }
        
        return hash()
    }
    
    public func hash(stream: InputStream) -> Data {
        return hash(stream: DelegatingInputStream(stream))
    }
    
    public func hash(stream: InputStreamSupport) -> Data {
        reset()
        
        let stream = MessageDigestInputStream(stream, digest: self)
        
        try? stream.readAll() {
            (data: Data) in
        }
        
        return hash()
    }
}


public class MessageDigestBase: MessageDigest {
    public  var blockSize: Int          = 0
    public  var bytesProcessed: UInt64  = 0

    internal var buffer                 = Data()
    
    public required init() {
        reset()
    }

    public func update(data: Data) {
        if(buffer.count == 0) {
            buffer = data
        } else {
            buffer.append(data)
        }
        
        bytesProcessed += UInt64(data.count)
        
        //call update by blocks
        var start = 0
        while(start + blockSize <= buffer.count) {
            update(offset: start)
            start += blockSize
        }
        
        if(start > 0) {
            buffer = buffer.subdata(in: start ..< buffer.count)
        }
    }

    public func reset() {
        self.bytesProcessed = 0
        self.buffer.removeAll()
    }

    
    public func copy() -> MessageDigest {
        fatalError("Must implement")
    }
    
    func update(offset: Int) {
        fatalError("Must implement")
    }
    
    public func finishAndReturnHash() -> Data {
        fatalError("Must implement")
    }
}

extension MessageDigestBase {
    
    static let defaultPadding: Data = {
        // we need 128 byte padding for SHA-384/512
        // and an additional 8 bytes for the high 8 bytes of the 16
        // byte bit counter in SHA-384/512
        var data = Data(count: 136)
        data[0] = UInt8(0x80)
        
        return data
    }()

    func b2iLittle(source: Data, sourceOffset: Int, length: Int, target: inout [Int], targetOffset: Int) {
        var index = sourceOffset
        var targetIndex = targetOffset
        let endIndex = length + sourceOffset
        
        while (index < endIndex) {
            target[targetIndex] =
                (Int(source[index + 0]) <<  0)        |
                (Int(source[index + 1]) <<  8)        |
                (Int(source[index + 2]) <<  16)       |
                (Int(source[index + 3]) <<  24)
            
            targetIndex += 1
            index += 4
        }
    }
    
    func i2bLittle(source: [Int], sourceOffset: Int, length: Int, target: inout Data, targetOffset: Int) {
        var index = sourceOffset
        var targetIndex = targetOffset
        let endIndex = length + sourceOffset
        
        while(index < endIndex) {
            let i = source[index]
            
            target[targetIndex + 0] = UInt8(i      )
            target[targetIndex + 1] = UInt8(i >>  8)
            target[targetIndex + 2] = UInt8(i >> 16)
            target[targetIndex + 3] = UInt8(i >> 24)
            
            targetIndex += 4
            index += 1
        }
    }
}

