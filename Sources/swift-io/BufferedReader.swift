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
 
 Created by Dusan Saiko on 02/08/16.
 */
import Foundation

public class BufferedReader
{
    static let DEFAULT_BUFFER_SIZE = 8 * 1024
    static let LINE_END_CHARACTERS = ["\r\n", "\n", "\r"]
    
    let reader: Reader
    let encoding: String.Encoding

    var readerBuffer: [UInt8]
    var buffer: Data
    var lineEndings: [Data]
    var endOfData: Bool
    
    
    public init(_ reader: Reader, encoding: String.Encoding = StringWriter.DEFAUTL_ENCODING, bufferSize: Int = BufferedReader.DEFAULT_BUFFER_SIZE) {
        self.reader = reader
        self.buffer = Data(capacity: bufferSize)
        self.encoding = encoding
        self.lineEndings = BufferedReader.LINE_END_CHARACTERS.map({
            (eol: String) -> Data in
            return eol.data(using: encoding)!
        })
        self.readerBuffer = [UInt8](repeating: 0, count: bufferSize)
        self.endOfData = false
    }
    
    deinit {
        try? close()
    }

    public func readLine() throws -> String?
    {
        func findEOL(startIndex: Int = 0) -> Range<Int>? {
            for eol in lineEndings {
                if let range = buffer.range(of: eol, options: [], in: startIndex ..< buffer.count) {
                    return range
                }
            }
            return nil
        }
        
        if(endOfData) {
            return nil
        }

        var range = findEOL()
        var findIndex = buffer.count
        
        while (range == nil) {
            if let count = try reader.read(buffer: &readerBuffer) {
                buffer.append(readerBuffer, count: count)
                range = findEOL(startIndex: findIndex)
                findIndex = buffer.count
            } else {
                //no more data
                endOfData = true

                if(buffer.count > 0) {
                    //return last line
                    let line = String(data: buffer, encoding: encoding)
                    buffer.removeAll(keepingCapacity: false)
                    return line
                } else {
                    return nil
                }
            }
        }

        if let range = range {
            let line = String(data: buffer.subdata(in: 0 ..< range.lowerBound), encoding: encoding)
            buffer.removeSubrange(0 ..< range.upperBound)
            return line
        }
        
        return nil
    }
    
    public func close() throws
    {
        try reader.close()
    }
}
