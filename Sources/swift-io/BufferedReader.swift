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

public class BufferedReader
{
    let reader: Reader
    
    public init(reader: Reader) {
        self.reader = reader
    }
    
    deinit {
        try? close()
    }
    
    public func readLine() throws -> String?
    {
    }
    
    public func close() throws
    {
        try reader.close()
    }
}
