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
 Simple unsynchronized buffered writer.
 Subclases need to implemend flushData(_) and close() methods.
 deinit() calls close() automatically
 */
public class BufferedWriter: Writer {
    static let DEFAULT_BUFFER_SIZE  = 1024 * 1024
    
    let bufferSize:                 Int
    let sourceDescription:          String
    var buffer:                     Data
    
    /**
     Initializer
     - Parameter bufferSize: caching buffer size. Default 1 MB
     */
    init(sourceDescription: String, bufferSize: Int = DEFAULT_BUFFER_SIZE) {
        self.sourceDescription      = sourceDescription
        self.bufferSize             = bufferSize
        self.buffer                 = Data(capacity: bufferSize)!
    }
    
    deinit {
        do {
            try close()
        } catch let error {
            //TODO: introduce proper logging
            NSLog("\(error)")
        }
    }
    
    /**
     Flush the stream
     */
    public func flush() throws {
        //if closed, this will throw an exception
        try flushData(data: buffer)
        
        //refresh buffer only when needed
        if(buffer.count > 0) {
            self.buffer = Data(capacity: bufferSize)!
        }
    }
    
    /**
     Unsynchronized buffered write
     - Parameter data: Data to be written.
     */
    public func write(data: Data) throws
    {
        if(buffer.count + data.count > bufferSize) {
            try flush()
            try flushData(data: data)
        } else {
            self.buffer.append(data)
        }
    }
    
    public func write(string: String) throws {
        if let data = string.data(using: StringWriter.DEFAULT_STRING_ENCODING) {
            try write(data: data)
        } else {
            throw Exception.InvalidData(string: string)
        }
    }

    /**
     Closes the stream by flushing the data
     */
    public func close() throws {
        if(buffer.count > 0) {
            try flushData(data: buffer)
        }
    }

    /**
     Method to be overwritten. Write data to the stream.
     */
    func flushData(data: Data) throws {
        throw Exception.MethodNotImplemented
    }
}

