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
public protocol Writer {
    
    /**
     Writes Data to this stream
     - Parameter data: Data to be written into the stream
     - Throws: IOException if an I/O error occurs
     */
    func write(data: [UInt8], startIndex: Int, count: Int) throws
    
    /**
      Closes the stream, flushing it first. Once the stream has been closed,
      further write() or flush() invocations will cause an IOException to be
      thrown. Closing a previously closed stream has no effect.
     
      - Throws IOException if an I/O error occurs
    */
    func close() throws
}

public extension Writer {

    public func write(data: [UInt8]) throws
    {
        try write(data: data, startIndex: 0, count: data.count)
    }
    
    /**
     Writes Data to this stream
     - Parameter data: Data to be written into the stream
     - Throws: IOException if an I/O error occurs
     */
    public func write(data: Data) throws {
        let array = data.withUnsafeBytes { (bytes: UnsafePointer<UInt8>)->[UInt8] in
            return Array(UnsafeBufferPointer<UInt8>(start: bytes, count: data.count/sizeof(UInt8.self)))
        }
        
        try write(data: array, startIndex: 0, count: array.count)
    }
    
    public func write(string: String, encoding: String.Encoding = StringWriter.DEFAUTL_ENCODING) throws {
        if let data = string.data(using: encoding) {
            try write(data: data)
        } else {
            //can happen if we try to encode String in encoding not supporting all given characters
            throw Exception.InvalidStringEncoding(string: string, requestedEncoding: encoding)
        }
    }
}

