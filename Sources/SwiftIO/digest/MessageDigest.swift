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

public class MessageDigestProvider {

    static public var MD2: MessageDigest { get { return MessageDigestMD2() } }
   
}

/**
  This class defines MessageDisgest protocol, which provides the functionality
  of a message digest algorithm, such as MD5 or SHA. Message digests are
  secure one-way hash functions that take arbitrary-sized data and output a
  fixed-length hash value.
**/
public protocol MessageDigest {
  
    /**
     - Returns: The digest length in bytes.
    */
    var digestLength: Int { get }
    
    /**
     - Returns: total bytes processed
    */
    var bytesProcessed: Int { get }

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
     copy methor
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

