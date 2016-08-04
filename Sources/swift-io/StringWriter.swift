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
 Simple Writer into String object
 This writer ignores calls to flush() or close()
 */
public class StringWriter: Writer
{
    static let DEFAUTL_ENCODING = String.Encoding.utf8

    public private(set) var string: String
    
    let encoding: String.Encoding
    
    public init(encoding: String.Encoding = StringWriter.DEFAUTL_ENCODING) {
        self.string = String()
        self.encoding = encoding
    }

    public func write(data: [UInt8], startIndex: Int, count: Int) throws
    {
        if(startIndex < 0 || startIndex + count > data.count) {
            throw Exception.RangeException(existingRange: 0 ..< data.count, requestedRange: startIndex ..< count)
        }
        
        let dataToWrite = Data(bytes: data[startIndex ..< startIndex + count])

        if let string = String(data: dataToWrite, encoding: encoding)
        {
            write(string: string)
        } else {
            throw Exception.InvalidDataEncoding(data: dataToWrite, requestedEncoding: encoding)
        }
    }
    
    public func write(string: String)
    {
        self.string.append(string)
    }
    
    public func close()
    {
    }
}
