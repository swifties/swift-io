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
 Write string data into String buffer
 Use buffer property to get the written content
 */
public class StringWriter: Writer
{
    /**
     Buffer containing all data written to this Writer.
    */
    public private(set) var buffer: String

    /**
     Initializer.
     */
    public init() {
        self.buffer = String()
    }

    /**
     Write string data into memory buffer.
     */
    public func write(_ string: String) {
        buffer.append(string)
    }
    
    /**
     Close has no effect for StringWriter.
    */
    public func close() {
    }
}
