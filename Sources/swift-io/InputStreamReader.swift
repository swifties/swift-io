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
    ///Byte Order Masks for UTF-16 little endian
    ///SeeAlso: [wikipedia](https://en.wikipedia.org/wiki/Byte_order_mark)
    static let UTF16LE_BOM:     [UInt8] = [0xFF, 0xFE]

    ///Byte Order Masks for UTF-16 big endian
    ///SeeAlso: [wikipedia](https://en.wikipedia.org/wiki/Byte_order_mark)
    static let UTF16BE_BOM:     [UInt8] = [0xFE, 0xFF]

    ///Byte Order Masks for UTF-32 little endian
    ///SeeAlso: [wikipedia](https://en.wikipedia.org/wiki/Byte_order_mark)
    static let UTF32LE_BOM:     [UInt8] = [0xFF, 0xFE, 0x00, 0x00]

    ///Byte Order Masks for UTF-32 big endian
    ///SeeAlso: [wikipedia](https://en.wikipedia.org/wiki/Byte_order_mark)
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
     
     - Parameter stream: Stream to read the data from. Stream will be opened if necessary. Stream will be closed at deinit().
     - Parameter encoding: Encoding of the data. DEFAULT_ENCODING by default. 
     - Parameter bufferSize: Buffer size to use. DEFAULT_BUFFER_SIZE by default, minimum MINIMUM_BUFFER_SIZE.
     - Parameter description: Description to be shown at errors etc. For example file path, http address etc.
     
     - SeeAlso: DEFAULT_ENCODING
     - SeeAlso: DEFAULT_BUFFER_SIZE
     - SeeAlso: MINIMUM_BUFFER_SIZE
     */
    public init(_ stream: InputStream, encoding: String.Encoding = DEFAULT_ENCODING, bufferSize: Int = DEFAULT_BUFFER_SIZE, description: String? = nil)
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
    
    /**
     Returns text description of the Stream. Description can be passed to the Reader initialized.
     
     - Return: Text description of the Stream.
    */
    public var description: String {
        return "\(type(of: self)): \(streamDescription)"
    }
    
    deinit {
        close()
    }
    

    /**
     Analyze data header for BOM sequences
     
     - SeeAlso: [Wikipedia](https://en.wikipedia.org/wiki/Byte_order_mark)
    */
    private func analyzeBOM()  throws -> Int {
        if(encoding == .utf16)
        {
            //need to specify utf16 encoding reading BOM
            if(buffer.starts(with: InputStreamReader.UTF16LE_BOM)) {
                encoding = String.Encoding.utf16LittleEndian
                return InputStreamReader.UTF16LE_BOM.count
            }
            else if(buffer.starts(with: InputStreamReader.UTF16BE_BOM)) {
                encoding = String.Encoding.utf16BigEndian
                return InputStreamReader.UTF16BE_BOM.count
            }

            throw Exception.InvalidDataEncoding(requestedEncoding: encoding, description: "\(description): UTF-16 data without BOM. Please Use UTF-16LE or UTF-16BE instead.")
        } else if (encoding == .utf32) {
            //need to specify utf32 encoding reading BOM
            if(buffer.starts(with: InputStreamReader.UTF32LE_BOM)) {
                encoding = String.Encoding.utf32LittleEndian
                return InputStreamReader.UTF32LE_BOM.count
            }
            else if(buffer.starts(with: InputStreamReader.UTF32BE_BOM)) {
                encoding = String.Encoding.utf32BigEndian
                return InputStreamReader.UTF32BE_BOM.count
            }
            
            throw Exception.InvalidDataEncoding(requestedEncoding: encoding, description: "\(description): UTF-32 data without BOM. Please Use UTF-32LE or UTF-32BE instead.")
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
            return nil
        }
        
        //read from the stream
        let count = stream.read(&buffer, maxLength: buffer.count)
        
        if(count == -1) {
            //when error or when stream already closed
            throw IOException.ErrorReadingFromStream(error: stream.streamError, description: description)
        }

        //for first piece of data we need to analyze BOM
        if(firstData) {
            var skipBytes = 0
            firstData = false
            skipBytes = try analyzeBOM()
            data = Array(buffer[skipBytes ..< count])
        } else {
            data.append(contentsOf: buffer.prefix(count))
        }

        //try to read the string from buffer
        if let  string = String(bytes: data, encoding: encoding), !string.isEmpty
        {
            //if OK, clear the buffer and return the String
            data.removeAll(keepingCapacity: true)
            return string
        } else {
            //we are somewhere in the middle of the encoded characters
            //try to decrement the size of data we use for conversion to String
            var size = data.count - dataUnitSize
            while(size > 0) {
                
                if let  string = String(bytes: data[0 ..< size], encoding: encoding),
                        string.characters.count > 0
                {
                    data = Array(data.suffix(from: size))
                    return string
                }

                //try to decrement more
                size -= dataUnitSize
            }
            
        }

        if(data.count > bufferSize) {
            //could not find any string in the data
            //see: InputStreamReaderTests.test_NoString()
            throw Exception.InvalidDataEncoding(requestedEncoding: encoding, description: description)
        }
        
        //return an empty string - the data will continue to float on next read
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
