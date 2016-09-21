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

typealias URLReader = FileReader

/** 
  Read String data from URL
 */
public class FileReader: InputStreamReader
{
    /**
     Create a Reader from URL InputStream
     
     - Parameter url: Valid resource URL
     - Throws: Exception if stream can not be created or opened
     
     - SeeAlso: InputStreamReader
    */
    public init(_ url: URL, encoding: String.Encoding = DEFAULT_ENCODING, bufferSize: Int = DEFAULT_BUFFER_SIZE, description: String? = nil) throws
    {
        if let stream = InputStream(url: url)
        {
            super.init(stream, encoding: encoding, bufferSize: bufferSize, description: description ?? url.absoluteString)
        } else {
            throw IOException.URLIsNotReadable(url: url)
        }
    }
}
