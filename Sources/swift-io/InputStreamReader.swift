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

public class InputStreamReader: Reader
{
    let stream:             InputStream
    let description:        String
    let encoding:           String.Encoding
    let bufferSize:         Int

    var data:               Data
    var buffer:             [UInt8]
    
    /**
     Initializer to write data into the passed stream.
     - Parameter stream: Stream which needs to be already opened
     */
    init(_ stream: InputStream, encoding: String.Encoding = DEFAULT_ENCODING, bufferSize: Int = DEFAULT_BUFFER_SIZE, description: String? = nil)
    {
        self.stream = stream
        self.encoding = encoding
        self.bufferSize = max(bufferSize, 1) //MINIMUM_BUFFER_SIZE)
        self.description = description ?? stream.description

        self.data = Data(capacity: bufferSize)
        self.buffer = [UInt8](repeating: 0, count: bufferSize)
        
        if(stream.streamStatus == .notOpen)
        {
            self.stream.open()
        }
    }
    
    deinit {
        close()
    }
    
    /**
     Attempts to read characters into the specified character buffer.
     
     - Parameter buffer: buffer to be filled from the Reader.
     - Parameter maxCount: number of bytes to be read. If count exceeds the capacity of the buffer, Exception.ArraySizeTooSmall will be thrown.
     
     - Returns: the number of bytes read or -1 when at the end.
     - Throws: exception if read error occurs
     */
    public func read() throws -> String?
    {
        if(stream.streamStatus == .closed)
        {
            throw IOException.StreamAlreadyClosed(description: description)
        }

        if(stream.streamStatus == .closed)
        {
            throw IOException.StreamAlreadyClosed(description: description)
        }

        let count = stream.read(&buffer, maxLength: buffer.count)

        if(count == -1) {
            throw IOException.ErrorReadingFromStream(error: stream.streamError, description: description)
        }

        data.append(buffer, count: count)
        
        if(stream.streamStatus == .atEnd)
        {
            if(data.count > 0) {
                if let lastPart = String(bytes: data, encoding: encoding) {
                    data.removeAll()
                    return lastPart
                } else {
                    throw Exception.InvalidDataEncoding(data: data, requestedEncoding: encoding, description: description)
                }
            }
            return nil
        }

        if let string = String(data: data, encoding: encoding) {
            let data2 = string.data(using: encoding)!
            
            if(data.count == data2.count && data == data2)
            {
                data.removeAll()
                return string
            }
        }
        
        return ""
    }
    
    
    /**
     Closes the stream and releases any system resources associated with
     it. Once the stream has been closed, further reads will throw an IOException.
     Closing a previously closed stream has no effect.
     
     - Throws: Exception if an I/O error occurs
     */
    public func close() {
        stream.close()
    }
}
