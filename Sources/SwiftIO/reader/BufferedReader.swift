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
 
 Created by dusan@saiko.cz on 02/08/16.
*/

import Foundation

/**
 Buffered reader class which can read from reader by lines
 */
public class BufferedReader: Reader, Closeable
{
    let reader: Reader
    var buffer: String
    var atEnd:  Bool
    
    /**
     Init with Reader
    */
    public init(_ reader: Reader) {
        self.reader = reader
        buffer      = String()
        atEnd       = false
    }
    
    deinit {
        try? close()
    }

    /**
     Read next line from the reader.
     
     - Returns: Next line from the reader without the line end characters, or nill when at the end.
     - Throws: Exception when can not read or reader is already closed.
    */
    public func readLine() throws -> String?
    {
        
        if(atEnd) {
            return nil
        }

        var startIndex =  buffer.startIndex
        var lineEndIndex = startIndex
        var contentsEndIndex = startIndex

        while(true) {
            
            buffer.getLineStart(&startIndex, end: &lineEndIndex, contentsEnd: &contentsEndIndex, for: startIndex..<startIndex)
            
            if(contentsEndIndex != lineEndIndex) {

                let line = buffer.substring(to: contentsEndIndex)
                buffer = buffer.substring(from: lineEndIndex)
                
                return line
            }
            
            if let nextString = try reader.read() {
                buffer.append(nextString)
            } else {
                break
            }
        }

        // no more string data in the reader
        
        let line = buffer
        buffer = String()
        atEnd = true
        
        //if last line is empty, it is not returned
        if(line == "")
        {
            return nil
        }
        
        return line
    }

    /**
     Conforming to the Reader protocol.
     
     Calls to readLine() and read() can be combined.
     
     - Returns: Next String from the Reader.
    */
    public func read() throws -> String? {
        if(atEnd) {
            return nil
        }
        
        if(!buffer.isEmpty) {
            let s = buffer;
            buffer.removeAll(keepingCapacity: true)
            return s
        }
        
        return try reader.read()
    }
    
    /**
     Close the Reader
    */
    public func close() throws
    {
        try reader.close()
        buffer.removeAll()
        //this will allow exception to be thrown on next read
        atEnd = false
    }
}


public extension BufferedReader {
    /**
     Reads all lines and passes them to closure.
     
     - Parameter fce: Closure to handle each line.
     - Throws: Exception when can not read or reader is already closed.
     */
    public func readAllLines(fce: ((String) -> ())) throws
    {
        while(true) {
            if let s = try readLine() {
                fce(s)
            } else {
                break
            }
        }
    }
}
