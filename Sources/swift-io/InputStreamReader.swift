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
 
 Created by Dusan Saiko on 31/07/16.
*/

import Foundation

class InputStreamReader: Reader
{
    let stream: InputStream
    let sourceDescription: String
    var closed: Bool
    
    /**
     Initializer to write data into the passed stream.
     - Parameter stream: Stream which needs to be already opened
     */
    init(stream: InputStream, sourceDescription: String? = nil)
    {
        self.stream = stream
        self.sourceDescription = sourceDescription ?? stream.description
        self.stream.open()
        self.closed = false
    }
    
    deinit {
        try? close()
    }
    
    /**
     Attempts to read characters into the specified character buffer.
     
     - Parameter buffer: buffer to be filled from the Reader.
     - Parameter maxCount: number of bytes to be read. If count exceeds the capacity of the buffer, Exception.ArraySizeTooSmall will be thrown.
     
     - Returns: the number of bytes read or -1 when at the end.
     - Throws: exception if read error occurs
     */
    func read(buffer: inout [UInt8]) throws -> Int?
    {
        if(closed) {
            throw IOException.StreamAlreadyClosed(sourceDescription: sourceDescription)
        }
        
        let count = stream.read(&buffer, maxLength: buffer.count)
        
        if(count == 0) {
            return nil
        }
        
        if(count == -1) {
            throw IOException.ErrorReadingFromStream(sourceDescription: sourceDescription, error: stream.streamError)
        }
        
        return count
    }
    
    
    /**
     Closes the stream and releases any system resources associated with
     it. Once the stream has been closed, further reads will throw an IOException.
     Closing a previously closed stream has no effect.
     
     - Throws: Exception if an I/O error occurs
     */
    func close() throws {
        if(!closed) {
            stream.close()
        }
    }
}
