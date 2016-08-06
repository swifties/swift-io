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
 
 Created by Dusan Saiko on 31/07/16.
 */

import Foundation

class FileReader: InputStreamReader {
    
    /**
     Initializer to write data into url
     - Parameter url: file url to write to
     - Parameter appendFile: True if file should be appended
     - Parameter bufferSize: size of data buffer, default 1MB
     - Throws: IOException if initialization is not successfull
     */
    init(_ url: URL) throws
    {
        if let stream = InputStream(url: url)
        {
            stream.schedule(in: RunLoop.current, forMode: .defaultRunLoopMode)
            super.init(stream, sourceDescription: url.absoluteString)
        } else {
            throw IOException.FileIsNotReadable(url: url)
        }
    }
    
    convenience init(_ path: String) throws
    {
        try self.init(URL(fileURLWithPath: path))
    }
}
