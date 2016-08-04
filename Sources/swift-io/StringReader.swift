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
 
 Created by dusan@saiko.cz on 03/08/16.
 */

import Foundation

public class StringReader: Reader
{
    let data: Data
    var index: Int
    
    public init(string: String, dataEncoding: String.Encoding = StringWriter.DEFAUTL_ENCODING) throws
    {
        guard let data = string.data(using: dataEncoding) else
        {
            //can happen if we try to encode String in encoding not supporting all given characters
            throw Exception.InvalidStringEncoding(string: string, requestedEncoding: dataEncoding)
        }
        
        self.data = data
        index = 0
    }
    
    public func read(buffer: inout [UInt8]) -> Int?
    {
        if(index >= data.count) {
            return nil
        }
        
        let count = min(data.count - index, buffer.count)
        buffer.removeAll(keepingCapacity: true)
        buffer.append(contentsOf: data[index ..< index + count])
        index = index + count
        
        return count
    }
    
    public func close() throws
    {
    }
}
