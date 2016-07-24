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
     Writes data to this stream
     - Parameter data: Data to be written into the stream
     - Throws: IOException if an I/O error occurs
    */
    func write(data: Data) throws

    /**
     Writes data to this stream
     - Parameter data: Data to be written into the stream
     - Throws: IOException if an I/O error occurs
     */
    func write(string: String) throws
    
    /**
     Flushes the stream.  If the stream has saved any characters from the
     various write() methods in a buffer, write them immediately to their
     intended destination.  Then, if that destination is another character or
     byte stream, flush it.  Thus one flush() invocation will flush all the
     buffers in a chain of Writers and OutputStreams.
    
     <p> If the intended destination of this stream is an abstraction provided
     by the underlying operating system, for example a file, then flushing the
     stream guarantees only that bytes previously written to the stream are
     passed to the operating system for writing; it does not guarantee that
     they are actually written to a physical device such as a disk drive.
    
     - Throws: IOException if an I/O error occurs
    */
    func flush() throws
    
    /**
      Closes the stream, flushing it first. Once the stream has been closed,
      further write() or flush() invocations will cause an IOException to be
      thrown. Closing a previously closed stream has no effect.
     
      - Throws IOException if an I/O error occurs
    */
    func close() throws
}


/**
 Simple unsynchronized buffered writer.
 Subclases need to implemend flushData(_) and close() methods.
 close() method is already called from deffer()
*/
public class BufferedWriter {
    static let DEFAULT_BUFFER_SIZE = 1024 * 1024

    let bufferSize: Int
    var buffer:     Data?

    /**
     Initializer
     - Parameter bufferSize: caching buffer size. Default 1 MB
    */
    init(bufferSize: Int = DEFAULT_BUFFER_SIZE) {
        self.bufferSize = bufferSize
        self.buffer = Data()
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
     Flush and close the stream.
     If stream already closed, does not throw.
     To be overwitten by subclasses. Overrides need to call this super method
    */
    public func close() throws {
        if let buffer = buffer {
            try flushData(data: buffer)
            self.buffer = nil
        }
    }

    /**
     Flush the stream
    */
    public func flush() throws {
        if let buffer = buffer {
            try flushData(data: buffer)
            self.buffer = Data()
        } else {
            throw IOException.StreamAlreadyClosed
        }
    }

    /**
      Unsynchronized buffered writer method
      - Parameter data: Data to be written.
    */
    public func write(data: Data) throws
    {
        if let buffer = buffer {
            if(buffer.count + data.count > bufferSize) {
                try flushData(data: buffer)
                try flushData(data: data)
                self.buffer = Data()
            } else {
                self.buffer!.append(data)
            }
        } else {
            throw IOException.StreamAlreadyClosed
        }
    }

    public func write(string: String) throws {
        if let data = string.data(using: .utf8) {
            try write(data: data)
        }
    }
    
    /**
     Method to be overwritten. Write data to the stream.
    */
    func flushData(data: Data) throws {
        throw Exception.MethodNotImplemented
    }
}

