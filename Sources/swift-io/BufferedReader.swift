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

/**
 Buffered reader class which reads from reader by lines
 */
public class BufferedReader: Closeable
{
    let reader: Reader
    var buffer: String
    var atEnd:  Bool
    
    /**
     Init with reader
    */
    public init(_ reader: Reader) {
        self.reader = reader
        buffer      = String()
        atEnd       = false
    }
    
    deinit {
        close()
    }

    /**
     Read next line from the reader
     
     - Returns: next line from the reader without the line end characters, or nill when at the end.
     - Throws: Exception when can not read or reader is already closed
    */
    public func readLine() throws -> String?
    {
        
        if(atEnd) {
            reader.close()
            return nil
        }

        while(true) {
            var startIndex  = buffer.startIndex
            var lineEndIndex = buffer.startIndex
            var contentsEndIndex = buffer.startIndex
            
            buffer.getLineStart(&startIndex, end: &lineEndIndex, contentsEnd: &contentsEndIndex, for: lineEndIndex..<lineEndIndex)
            
            if(contentsEndIndex != lineEndIndex) {
                let line = buffer.substring(with: startIndex ..< contentsEndIndex)
                buffer.removeSubrange(startIndex ..< lineEndIndex)
                return line
            }
            
            if let nextString = try reader.read() {
                buffer.append(nextString)
            } else {
                break
            }
        }

        let line = buffer
        buffer.removeAll()
        atEnd = true
        
        //if last line is empty, it is not returned
        if(line == "")
        {
            close()
            return nil
        }
        
        return line
    }
    
    /**
      Reads all lines and passes them to closure
     
     - Parameter fce: closure to handle each line
     - Throws: Exception when can not read or reader is already closed
     */
    func readAllLines(fce: ((String) -> ())) throws
    {
        while(true) {
            if let s = try readLine() {
                fce(s)
            } else {
                break
            }
        }
    }
    
    public func close()
    {
        reader.close()
    }
}
