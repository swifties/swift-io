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
    func write(data: Data) throws

    /**
     Writes String to this stream
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

