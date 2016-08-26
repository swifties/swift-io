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
//
///**
// Simple unsychronized buffered OutputStreamWriter implementation
//*/
//public class OutputStreamWriter: Writer
//{
//    let stream:             OutputStream
//    let description:        String
//    var closed:             Bool
//    
//    /**
//     Initializer to write data into the passed stream.
//     - Parameter stream: Stream which needs to be already opened
//     */
//    init(_ stream: OutputStream, description: String? = nil)
//    {
//        self.stream = stream
//        self.description = description ?? stream.description
//        self.stream.open()
//        self.closed = false
//    }
//    
//    deinit {
//        try? close()
//    }
//    
//    public func write(_ data: [UInt8], startIndex: Int, count: Int) throws
//    {
//        if(closed) {
//            throw IOException.StreamAlreadyClosed(description: description)
//        }
//        
//        if(startIndex < 0 || startIndex + count > data.count) {
//            throw Exception.RangeException(existingRange: 0 ..< data.count, requestedRange: startIndex ..< count, description: description)
//        }
//        
//        var totalWritten = 0
//        
//        //write loop in case data are not written in one piece
//        while(totalWritten < data.count) {
//            let dataToWrite = Array(data[startIndex + totalWritten ..< startIndex + count])
//            let bytesWritten = stream.write(dataToWrite, maxLength: dataToWrite.count)
//            
//            if ( bytesWritten <= 0) {
//                throw IOException.ErrorWritingIntoStream(sourceDescription: sourceDescription, error: stream.streamError, description: description)
//            }
//            totalWritten += bytesWritten
//        }
//    }
//    
//    public func close() throws {
//        if(!closed) {
//            closed = true
//            stream.close()
//        }
//    }
//
//}
