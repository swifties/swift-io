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
    let data: [UInt8]
    var index: Int
    
    public init(string: String) {
        self.data = Array(string.utf8)
        index = 0
    }
    
    public func read(buffer: inout [UInt8]) throws -> Int?
    {
        if(index >= data.count) {
            return nil
        }
        
        var n = 0
        while(index < data.count && n < buffer.count) {
            buffer[n] = data[index]
            index += 1
            n += 1
        }
        return n
    }
    
    public func close() throws
    {
    }
}
