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
 
 Created by dusan@saiko.cz on 04/07/16.
 */

import Foundation


/**
 Swift version of the java Writer interface
*/
public protocol Writer: Closeable {
    
    /**
     Writes Data to this stream
     - Parameter data: Data to be written into the stream
     - Throws: IOException if an I/O error occurs
     */
    func write(_ data: [UInt8], startIndex: Int, count: Int) throws
}

public extension Writer {

    public func write(_ data: [UInt8]) throws
    {
        try write(data, startIndex: 0, count: data.count)
    }
    
    /**
     Writes Data to this stream.
     
     - Parameter data: Data to be written into the stream
     - Throws: IOException if an I/O error occurs
     */
    public func write(_ data: Data) throws {
        let array = data.withUnsafeBytes { (bytes: UnsafePointer<UInt8>)->[UInt8] in
            return Array(UnsafeBufferPointer<UInt8>(start: bytes, count: data.count/sizeof(UInt8.self)))
        }
        
        try write(array, startIndex: 0, count: array.count)
    }
    
    public func write(_ string: String, dataEncoding: String.Encoding = StringWriter.DEFAUTL_ENCODING) throws {
        if let data = string.data(using: dataEncoding) {
            try write(data)
        } else {
            //can happen if we try to encode String in encoding not supporting all given characters
            throw Exception.InvalidStringEncoding(string: string, requestedEncoding: dataEncoding)
        }
    }
}

