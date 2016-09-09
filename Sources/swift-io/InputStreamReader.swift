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
    

    var data:                   [UInt8]
    var buffer:                 [UInt8]
    var encoding:               String.Encoding
    var firstData:              Bool
    
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
        
        //make the buffer size a number aligned to dataUnitSize bytes
        self.bufferSize = Int(max(bufferSize, MINIMUM_BUFFER_SIZE) / dataUnitSize) * dataUnitSize
        
        self.streamDescription = description ?? stream.description
        self.firstData = true

        self.data = [UInt8]()
        self.buffer = [UInt8](repeating: 0, count: self.bufferSize)
        
        if(stream.streamStatus == .notOpen)
        {
            self.stream.open()
        }
    }
    
    public var description: String {
        return "\(type(of: self)): \(streamDescription)"
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
     Reads next String from the stream.
     Max String size retrieved is influenced by buffer size and encoding set in the initializer.
     
     
     - Returns: Next string from the stream. 
                Empty String can be returned from the reader - which means more data will be read from the stream on next iteration of read().
                Nil when at the end of the stream.
     
     - Throws: Exception if read error occurs
     */
    public func read() throws -> String?
    {
        if(stream.streamStatus == .atEnd)
        {
            if(data.count > 0) {
                if let lastPart = String(bytes: data, encoding: encoding) {
                    data.removeAll(keepingCapacity: false)
                    return lastPart
                } else {
                    throw Exception.InvalidDataEncoding(requestedEncoding: encoding, description: description)
                }
            }
            return nil
        }
        
        
        let count = stream.read(&buffer, maxLength: buffer.count)
        
        if(count == -1) {
            //when error
            //or when stream already closed
            throw IOException.ErrorReadingFromStream(error: stream.streamError, description: description)
        }
        
        if(firstData) {
            var skipBytes = 0
            firstData = false
            skipBytes = try analyzeBOM()
            data = Array(buffer[skipBytes ..< count])
        } else {
            data.append(contentsOf: buffer.prefix(count))
        }

        if let  string = String(bytes: data, encoding: encoding), !string.isEmpty
        {
            
            data.removeAll(keepingCapacity: true)
            return string
        } else {
            var size = data.count - dataUnitSize
            while(size > 0) {
                
                if let  string = String(bytes: data[0 ..< size], encoding: encoding),
                        string.characters.count > 0
                {
                    data = Array(data.suffix(from: size))
                    return string
                }

                size -= dataUnitSize
            }
            
        }

        if(data.count > bufferSize) {
            //could not find any string in the data
            throw Exception.InvalidDataEncoding(requestedEncoding: encoding, description: description)
        }
        
        return ""
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
