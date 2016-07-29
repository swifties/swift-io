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
 Simple unsychronized buffered OutputStreamWriter implementation
*/
public class OutputStreamWriter: BufferedWriter
{
    var stream: OutputStream
    
    /**
     Initializer to write data into the passed stream.
     - Parameter stream: Stream which needs to be already opened
     */
    init(stream: OutputStream, bufferSize: Int = BufferedWriter.DEFAULT_BUFFER_SIZE, sourceDescription: String? = nil) //TODO
    {
        self.stream = stream
        super.init(sourceDescription: sourceDescription ?? stream.description, bufferSize: bufferSize)
    }
    
    override func flushData(data: Data) throws {
        if(closed) {
            throw IOException.StreamAlreadyClosed(sourceDescription: sourceDescription)
        }
        
        var count = 0
        
        //write loop in case data are not written in one piece
        while(count < data.count) {
            let dataToWrite = count == 0 ? data : data.subdata(in: Range(data.startIndex.advanced(by: count)..<data.endIndex))
            let bytesWritten = try dataToWrite.withUnsafeBytes({
                (bytes: UnsafePointer<UInt8>) throws -> Int in
                    let count = stream.write(bytes, maxLength: dataToWrite.count)
                    return count
            })
            
            if ( bytesWritten <= 0) {
                throw IOException.ErrorWritingIntoStream(sourceDescription: sourceDescription)
            }
            count += bytesWritten
        }
    }
    
    override public func close() throws {
        if(!closed) {
            try super.close()
            stream.close()
        }
    }
}
