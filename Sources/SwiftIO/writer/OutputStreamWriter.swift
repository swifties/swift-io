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
 
 Created by dusan@saiko.cz on 21/09/16.
*/

import Foundation

/**
 Write text data to underlaying OutputStream
 */
public class OutputStreamWriter: Writer, CustomStringConvertible
{
    let stream:             OutputStream
    let streamDescription:  String
    let encoding:           String.Encoding
    
    /**
     Initializer to write data into the passed stream.
     
     - Parameter stream: Stream to write to. Will be opened, if needed.
     - Parameter encoding: encoding to use for converting text to data bytes. DEFALT_ENCODING by default.
     - Parameter description: Description to be shown at errors etc. For example file path, http address etc.
     - Note: Stream is closed by calling close() at deinit().
     */
    public init(_ stream: OutputStream, encoding: String.Encoding =  DEFAULT_ENCODING, description: String? = nil)
    {
        self.stream = stream
        self.encoding = encoding
        self.streamDescription = description ?? stream.description
        
        if(stream.streamStatus == .notOpen)
        {
            self.stream.open()
        }
    }
    
    /**
     Write string data to the stream.
     
     - Parameter string: String to be written.
     - Throws: If string cannot be converted to given encoding or if write error occurs.
    */
    public func write(_ string: String) throws {
        guard let data = string.data(using: encoding)
        else {
            throw Exception.InvalidStringEncoding(string: string, requestedEncoding: encoding, description: streamDescription)
        }
        
        //convert to byte array
        let bytes = data.withUnsafeBytes {
            [UInt8](UnsafeBufferPointer(start: $0, count: data.count))
        }
        
        var totalWritten = 0
        let count = bytes.count

        //write loop in case data are not written in one piece
        while(totalWritten < bytes.count) {
            let dataToWrite = Array(data[totalWritten ..< count])
            let bytesWritten = stream.write(dataToWrite, maxLength: dataToWrite.count)

            if ( bytesWritten <= 0) {
                throw IOException.ErrorWritingIntoStream(error: stream.streamError, description: streamDescription)
            }
            totalWritten += bytesWritten
        }
    }
    
    /**
     Returns text description of the Stream. Description can be passed to the Reader initialized.
     
     - Return: Text description of the Stream.
     */
    public var description: String {
        return "\(type(of: self)): \(streamDescription)"
    }
    
    public func close() {
        stream.close()
    }

    deinit {
        close()
    }
}
