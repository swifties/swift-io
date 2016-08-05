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

 Created by Dusan Saiko on 24/07/16.
*/

import Foundation

public class FileWriter: OutputStreamWriter
{

    /**
     Initializer to write data into url
     - Parameter url: file url to write to
     - Parameter appendFile: True if file should be appended
     - Parameter bufferSize: size of data buffer, default 1MB
     - Throws: IOException if initialization is not successfull
     */
    init(url: URL, appendFile: Bool = false) throws
    {
        let fileManager = FileManager.default
        
        //create file if not exists
        if(!fileManager.fileExists(atPath: url.path)) {
            if(!fileManager.createFile(atPath: url.path, contents: nil, attributes: nil)) {
                throw IOException.ErrorCreatingFile(url: url)
            }
        }
        
        if(!FileManager.default.isWritableFile(atPath: url.path)) {
            throw IOException.FieIsNotWritable(url: url)
        }
        
        if let stream = NSOutputStream(url: url, append: appendFile)
        {
            stream.schedule(in: RunLoop.current, forMode: .defaultRunLoopMode)
            super.init(stream, sourceDescription: url.absoluteString)
        } else {
            throw IOException.FieIsNotWritable(url: url)
        }
    }

    /**
     Initializer to write data into file
     - Parameter file: file path to write to
     - Parameter appendFile: True if file should be appended
     - Throws: IOException if initialization is not successfull
     */
    convenience init(file: String, appendFile: Bool = false) throws
    {
        try self.init(url: URL(fileURLWithPath: file), appendFile: appendFile)
    }
}
