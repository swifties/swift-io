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
public class InputStreamReader: Reader, CustomStringConvertible
{
    static let UTF16LE_BOM:     [UInt8] = [0xFF, 0xFE]
    static let UTF16BE_BOM:     [UInt8] = [0xFE, 0xFF]
    static let UTF32LE_BOM:     [UInt8] = [0xFF, 0xFE, 0x00, 0x00]
    static let UTF32BE_BOM:     [UInt8] = [0x00, 0x00, 0xFE, 0xFF]

    let stream:                 InputStream
    let streamDescription:      String
    let bufferSize:             Int
    let dataUnitSize:           Int

    var data:                   Data
    var buffer:                 [UInt8]
    var encoding:               String.Encoding
    var firstData:              Bool
    
    public var description: String {
        return "\(type(of: self)): \(streamDescription)"
    }
    
    /**
     Initializer to read strings from the stream
     
     - Parameter stream: Stream to read the data from. It the stream is not opened, it will be. Stream will be closed at deinit().
     - Parameter encoding: Encoding of the data. DEFAULT_ENCODING by default. 
     - Parameter bufferSize: Buffer size to use. DEFAULT_BUFFER_SIZE by default, minimum MINIMUM_BUFFER_SIZE.
     - Parameter description: Description to be shown at errors etc. For example file path, http address etc.
     
     - SeeAlso: DEFAULT_ENCODING
     - SeeAlso: DEFAULT_BUFFER_SIZE
     - SeeAlso: MINIMUM_BUFFER_SIZE
     
     - Throws: Exception if stream can not be opened
     */
    init(_ stream: InputStream, encoding: String.Encoding = DEFAULT_ENCODING, bufferSize: Int = DEFAULT_BUFFER_SIZE, description: String? = nil) throws
    {
        self.stream = stream
        self.encoding = encoding
        self.bufferSize = max(bufferSize, MINIMUM_BUFFER_SIZE)
        self.streamDescription = description ?? stream.description
        self.firstData = true

        self.data = Data(capacity: self.bufferSize)
        self.buffer = [UInt8](repeating: 0, count: self.bufferSize)
        
        self.dataUnitSize = {
            switch encoding {
            case String.Encoding.utf32,
                 String.Encoding.utf32LittleEndian,
                 String.Encoding.utf32BigEndian:
                return 4
            case String.Encoding.utf16,
                 String.Encoding.utf16LittleEndian,
                 String.Encoding.utf16BigEndian:
                return 2
            default:
                return 1
            }
        }()
        
        if(stream.streamStatus == .notOpen)
        {
            self.stream.open()
        }
    }
    
    deinit {
        close()
    }
    

    /**
     Analyze data header for BOM sequences
     
     - SeeAlso: https://en.wikipedia.org/wiki/Byte_order_mark
    */
    private func analyzeBOM()  throws -> Int {
        if(encoding == String.Encoding.utf16)
        {
            //need to specify utf16 encoding reading BOM
            if(buffer.starts(with: InputStreamReader.UTF16LE_BOM)) {
                encoding = String.Encoding.utf16LittleEndian
                return InputStreamReader.UTF16LE_BOM.count
            }
            else if(buffer.starts(with: InputStreamReader.UTF16BE_BOM)) {
                encoding = String.Encoding.utf16BigEndian
                return InputStreamReader.UTF16BE_BOM.count
            } else {
                throw Exception.InvalidDataEncoding(requestedEncoding: encoding, description: "\(description): UTF-16 data without BOM. Please Use UTF-16LE or UTF-16BE instead.")
            }
        } else if (encoding == String.Encoding.utf32) {
            //need to specify utf32 encoding reading BOM
            if(buffer.starts(with: InputStreamReader.UTF32LE_BOM)) {
                encoding = String.Encoding.utf32LittleEndian
                return InputStreamReader.UTF32LE_BOM.count
            }
            else if(buffer.starts(with: InputStreamReader.UTF32BE_BOM)) {
                encoding = String.Encoding.utf32BigEndian
                return InputStreamReader.UTF32BE_BOM.count
            } else {
                throw Exception.InvalidDataEncoding(requestedEncoding: encoding, description: "\(description): UTF-32 data without BOM. Please Use UTF-32LE or UTF-32BE instead.")
            }
        }
        return 0
    }
    
    /**
     Read next part of data into buffer
     */
    private func readNext() throws
    {
        if(stream.streamStatus == .closed)
        {
            throw IOException.StreamAlreadyClosed(description: description)
        }
        
        let count = stream.read(&buffer, maxLength: buffer.count)
        
        if(count == -1) {
            throw IOException.ErrorReadingFromStream(error: stream.streamError, description: description)
        }

        var skipBytes = 0
        
        if(firstData) {
            firstData = false
            skipBytes = try analyzeBOM()
        }

        data.append(contentsOf: buffer[skipBytes ..< count])
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
        try readNext()
        
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

        var result = ""

        //read in chunks
        var index = dataUnitSize
        var startIndex = 0
        
        while(startIndex + index < data.count)
        {
            //try to read 0..<index from the data as String
            //if it is not enough, we will increment the chunk size
            while(startIndex + index < data.count)
            {
                let chunk = data[startIndex ..< startIndex + index]
                if let  string = String(bytes: chunk, encoding: encoding),
                        string.characters.count > 0
                {
                    //we were able to read the string chunk, 
                    //append it to resul
                    result.append(string)
                    
                    //reset index position
                    startIndex += index
                    index = dataUnitSize
                    break
                }
                index += dataUnitSize
            }
        }

        //remove the chunk from data
        data.removeSubrange(0 ..< startIndex)

        if(result == "" && data.count > MINIMUM_BUFFER_SIZE) {
            //could not find any string in the data
            throw Exception.InvalidDataEncoding(requestedEncoding: encoding, description: description)
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
