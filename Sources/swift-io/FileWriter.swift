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
 Simple sycnhronized and buffered FileWriter implementation
*/
class FileWriter: BufferedWriter
{
    
    let url: URL
    let stream: NSOutputStream
    
    /**
        Initializer to write data into url
        - Parameter url: file url to write to
        - Parameter appendFile: True if file should be appended
        - Parameter bufferSize: size of data buffer, default 1MB
        - Throws: IOException if initialization is not successfull
    */
    init(url: URL, appendFile: Bool = false, bufferSize: Int? = nil) throws
    {
        self.url = url
        let fileManager = FileManager.default
        
        guard let path = url.path else { throw IOException.InvalidPath(url: url) }
        
        //create file if not exists
        if(!fileManager.fileExists(atPath: path)) {
            if(!fileManager.createFile(atPath: path, contents: nil, attributes: nil)) {
                throw IOException.ErrorCreatingFile(url: url)
            }
        }

        if(!FileManager.default.isWritableFile(atPath: path)) {
            throw IOException.ErrorWritingIntoFile(url: url)
        }

        if let stream = NSOutputStream(url: url, append: appendFile)
        {
            stream.schedule(in: RunLoop.current, forMode: .defaultRunLoopMode)
            self.stream = stream
            self.stream.open()
        } else {
            throw IOException.ErrorWritingIntoFile(url: url)
        }
        
        super.init(bufferSize: bufferSize ?? BufferedWriter.DEFAULT_BUFFER_SIZE)
    }
    
    /**
     Initializer to write data into url
     - Parameter path: file path to write to
     - Parameter appendFile: True if file should be appended
     - Parameter bufferSize: size of data buffer, default 1MB
     - Throws: IOException if initialization is not successfull
     */
    convenience init(path: String, appendFile: Bool = false, bufferSize: Int? = nil) throws
    {
        try self.init(url: URL(fileURLWithPath: path), appendFile: appendFile, bufferSize: bufferSize)
    }
    
    override func flushData(data: Data) throws {
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
                throw IOException.ErrorWritingIntoFile(url: url)
            }
            count += bytesWritten
        }
    }
    
    override func close() throws {
        try super.close()
        stream.close()
    }
}
