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

/**
 Reader to read data from a String
 */
public class StringReader: InputStreamReader
{
    
    /**
     Create reader from String data.
     
     - Parameter string: String to read from.
     - Parameter encoding: Encoding to use for internal data manipulation. In general should stay the DEFAULT_ENCODING by default.
     - Parameter bufferSize: Buffer size to use. DEFAULT_BUFFER_SIZE by default, minimum MINIMUM_BUFFER_SIZE.
     - Parameter description: Description to be shown at errors etc. For example file path, http address etc.
     
     - SeeAlso: InputStreamReader.
     */
    public init(_ string: String, bufferSize: Int = DEFAULT_BUFFER_SIZE, encoding: String.Encoding = DEFAULT_ENCODING, desciption: String? = nil) throws
    {
        guard let data = string.data(using: encoding) else
        {
            //can happen if we try to encode String in encoding not supporting all given characters
            throw Exception.InvalidStringEncoding(string: string, requestedEncoding: encoding, description: desciption)
        }

        super.init(InputStream(data: data), encoding: encoding, bufferSize: bufferSize, description: desciption)
    }
}
