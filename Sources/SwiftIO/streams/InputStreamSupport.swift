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
 
 Created by dusan@saiko.cz on 3/10/16.
 */

import Foundation

/**
 Protocol version of InputStream class
 
 We these protocols as we want to delegate and chain to the Foundation.InputStream and we must be sure we delegate all methods availabe, which can not be done
 when new method would be added into the InputStream class.
 
 - SeeAlso: DelegatingInputStream
 - SeeAlso: InputStream class for methods documentation
 */
public protocol InputStreamSupport: StreamSupport {
    
    var hasBytesAvailable: Bool { get }
    
    func read(_ buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) -> Int
    func getBuffer(_ buffer: UnsafeMutablePointer<UnsafeMutablePointer<UInt8>?>, length len: UnsafeMutablePointer<Int>) -> Bool
        
}

public extension InputStreamSupport {
    
    public func readAll(bufferSize: Int = DEFAULT_BUFFER_SIZE, handler: ((_ data: Data) -> Void)) throws {
        
        var buffer = [UInt8](repeating: 0, count: bufferSize)
        
        if(streamStatus != .open) {
            open()
        }
        
        while(streamStatus != .atEnd) {
            let count = read(&buffer, maxLength: buffer.count)
            
            if(count == -1) {
                //when error or when stream already closed
                throw IOException.ErrorReadingFromStream(error: streamError, description: nil)
            }
            
            let data = Data(buffer.prefix(count))
            handler(data)
        }
    }
}
