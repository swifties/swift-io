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
 
 Created by dusan@saiko.cz on 21/09/16.
*/

import Foundation

/**
 Writer protocol to write text data.
 */
public protocol Writer: Closeable {
    
    /**
     Send text data to the Writer.
     
     Data is not cached and is passed directly to underlaying objects.
     
     - Parameter string: String to write.
     - Throws: Exception on write error.
    */
    func write(_ string: String) throws
}
