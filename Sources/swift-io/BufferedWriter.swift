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

//public class BufferedWriter: Writer
//{
//    let writer: Writer
//    let bufferSize: Int
//    var buffer: Data
//    
//    public init(_ writer: Writer, bufferSize: Int = DEFAULT_BUFFER_SIZE) {
//        self.writer = writer
//        self.bufferSize = bufferSize
//        self.buffer = Data(capacity: bufferSize)
//    }
//    
//    deinit {
//        try? close()
//    }
//    
//    public func write(_ data: [UInt8], startIndex: Int, count: Int) throws
//    {
//        if(count + buffer.count > bufferSize) {
//            try flush()
//            try writer.write(data, startIndex: startIndex, count: count)
//        } else {
//            buffer.append(Array(data[startIndex ..< startIndex + count]), count: count)
//        }
//    }
//    
//    public func close() throws
//    {
//        try flush()
//        try writer.close()
//    }
//    
//    func flush() throws {
//        try writer.write(buffer)
//        buffer.removeAll(keepingCapacity: true)
//    }
//    
//}
