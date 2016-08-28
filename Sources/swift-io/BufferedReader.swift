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

public class BufferedReader: Closeable
{
    let reader: Reader
    var buffer: String
    
    public init(_ reader: Reader) {
        self.reader = reader
        buffer = String()
    }
    
    deinit {
        close()
    }

    public func readLine() throws -> String?
    {

//        //: Playground - noun: a place where people can play
//        
//        import Foundation
//        
//        let string: NSString = "ahoj\n\nworld"
//        let stringLength = string.length
//        
//        var startIndex: Int = 0
//        var lineEndIndex: Int = 0
//        var contentsEndIndex: Int = 0
//        
//        var range: NSRange
//        
//        while (lineEndIndex < stringLength)
//        {
//            range = NSMakeRange(lineEndIndex, 0)
//            string.getLineStart(&startIndex, end: &lineEndIndex, contentsEnd: &contentsEndIndex, for: range)
//            
//            let line = string.substring(with: NSMakeRange(startIndex, contentsEndIndex - startIndex))
//            print("Line: \(line)")
//        }
        
        return nil
    }
    
    public func close()
    {
        reader.close()
    }
}
