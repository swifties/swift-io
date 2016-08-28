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

/**
 Reader to read Strings from InputStream
 */
public class InputStreamReader: Reader
{
    let stream:             InputStream
    let description:        String
    let encoding:           String.Encoding
    let bufferSize:         Int

    var data:               Data
    var buffer:             [UInt8]
    
    /**
     Initializer to read strings from the stream
     
     - Parameter stream: Stream to read the data from. It the stream is not opened, it will be. Stream will be closed at deinit().
     - Parameter encoding: Encoding of the data. DEFAULT_ENCODING by default. 
     - Parameter bufferSize: Buffer size to use. DEFAULT_BUFFER_SIZE by default, minimum MINIMUM_BUFFER_SIZE.
     - Parameter description: Description to be shown at errors etc. For example file path, http address etc.
     
     - Remark: Encoding can not be generic utf16, utf32 or unicode. Use .utf16BigEndian .utf16LittleEndian etc. instead.

     - SeeAlso: DEFAULT_ENCODING
     - SeeAlso: DEFAULT_BUFFER_SIZE
     - SeeAlso: MINIMUM_BUFFER_SIZE
     
     - Throws: Exception if stream can not be opened
     */
    init(_ stream: InputStream, encoding: String.Encoding = DEFAULT_ENCODING, bufferSize: Int = DEFAULT_BUFFER_SIZE, description: String? = nil) throws
    {
        switch encoding {
        case String.Encoding.utf16, String.Encoding.unicode:
            throw Exception.InvalidDataEncoding(requestedEncoding: encoding, description: "Can not use unspecific .utf16 encoding. Use .utf16BigEndian or .utf16LittleEndian instead.")
        case String.Encoding.utf32:
            throw Exception.InvalidDataEncoding(requestedEncoding: encoding, description: "Can not use unspecific .utf32 encoding. Use .utf32BigEndian or .utf32LittleEndian instead.")
        default:
            break
            
        }
        self.stream = stream
        self.encoding = encoding
        self.bufferSize = max(bufferSize, MINIMUM_BUFFER_SIZE)
        self.description = description ?? stream.description

        self.data = Data(capacity: self.bufferSize)
        self.buffer = [UInt8](repeating: 0, count: self.bufferSize)
        
        if(stream.streamStatus == .notOpen)
        {
            self.stream.open()
        }
    }
    
    deinit {
        close()
    }
    
    /**
     Reads next String from the stream.
     Max String size retrieved is influenced by buffer size and encoding set in the initializer.
     
     
     - Returns: Next string from the stream. 
                Empty String can be returned from the reader - which means more data will be read from the stream on next iteration of read().
                Nil when at the end of the stream.
     
     - Throws: Exception if read error occurs
     */
    public func read() throws -> String?
    {
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
                    throw Exception.InvalidDataEncoding(requestedEncoding: encoding, description: description)
                }
            }
            return nil
        }

        //read in chunks of 4 (utf32)
        let DATA_UNIT_SIZE = 4
        var result = ""
        
        var index = DATA_UNIT_SIZE
        while(index < data.count)
        {
            //try to read 0..<index from the data as String
            //if it does not work, we will increase the index position
            while(index < data.count)
            {
                let chunk = data.subdata(in: 0..<index)
                if let  string = String(data: chunk, encoding: encoding),
                        string.characters.count > 0
                {
                    //we were able to read the string chunk, 
                    //append it to resul
                    result.append(string)
                    
                    //remove the chunk from data
                    data.removeSubrange(0..<index)
                    
                    //reset index position
                    index = DATA_UNIT_SIZE
                    break
                }
                index += DATA_UNIT_SIZE
            }
        }
        
        
        return result
    }
    
    
    /**
     Closes the stream and releases any system resources associated with
     it. Once the stream has been closed, further reads will throw an IOException.
     Closing a previously closed stream has no effect.
     */
    public func close() {
        stream.close()
    }
}
