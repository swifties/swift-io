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
    Reader interface
    Reader will return next string from the source.
    Size of the string returned depends on the Reader implementation.
 */
public protocol Reader: Closeable {
    
    /**
     Attempts to read string from the Reader.
     
     - Returns: Next string from the source. Size of the string is dependent on the implementation of the reader.
                Return value can be empty string which would mean Reader is waiting for more data to come.
                Nil when at the end. Multiple reads from the end of the reader will all return nil.
     - Throws: Exception if read error occurs or if the Reader is already closed.
    */
    func read() throws -> String?
    
}

public extension Reader {
    
    /**
        Read all strings from the Reader and pass it to the inline function.
     
        - Parameter fce: Closure which accepts part of the string as a parameter.
        - Throws: Exception if read error occurs or if the Reader is already closed.
    */
    public func readAll(fce: ((String) -> ())) throws
    {
        while(true) {
            if let s = try read() {
                fce(s)
            } else {
                break
            }
        }
    }
    
    /**
     Read all from this Reader and return the data as String.
     
     - Returns: String with all content the Reader can read.
     - Throws: When reading error occurs.
     - Note: Dangerous, reads all data from the Reader into one single String
     */
    public func readAll() throws -> String
    {
        var buffer = String()
        try readAll() {
            buffer.append($0)
        }
        return buffer
    }
}

