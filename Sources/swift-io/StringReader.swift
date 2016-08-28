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

public class StringReader: InputStreamReader
{
    public init(_ string: String, bufferSize: Int = DEFAULT_BUFFER_SIZE, desciption: String? = nil) throws
    {
        guard let data = string.data(using: DEFAULT_ENCODING) else
        {
            //can happen if we try to encode String in encoding not supporting all given characters
            throw Exception.InvalidStringEncoding(string: string, requestedEncoding: DEFAULT_ENCODING, description: desciption)
        }

        try super.init(InputStream(data: data), encoding: DEFAULT_ENCODING, bufferSize: bufferSize, description: desciption)
    }
}
