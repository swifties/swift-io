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

public class DelegatingInputStream: DelegatingStream, InputStreamSupport {
    
    private let stream: InputStreamSupport
    
    public init(_ stream: InputStreamSupport) {
        self.stream = stream
        super.init(stream)
    }

    public init(_ stream: InputStream) {
        self.stream = DelegatingInputStreamNativeWrapper(stream)
        super.init(stream)
    }

    public var hasBytesAvailable: Bool {
            return stream.hasBytesAvailable
    }
    
    public func read(_ buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) -> Int {
        return stream.read(buffer, maxLength: len)
    }
    
    public func getBuffer(_ buffer: UnsafeMutablePointer<UnsafeMutablePointer<UInt8>?>, length len: UnsafeMutablePointer<Int>) -> Bool {
        return stream.getBuffer(buffer, length: len)
    }
   
}

class DelegatingInputStreamNativeWrapper: DelegatingStream, InputStreamSupport {
    
    private let stream: InputStream
    
    public init(_ stream: InputStream) {
        self.stream = stream
        super.init(stream)
    }
    
    public var hasBytesAvailable: Bool {
            return stream.hasBytesAvailable
    }
    
    public func read(_ buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) -> Int {
        return stream.read(buffer, maxLength: len)
    }
    
    public func getBuffer(_ buffer: UnsafeMutablePointer<UnsafeMutablePointer<UInt8>?>, length len: UnsafeMutablePointer<Int>) -> Bool {
        return stream.getBuffer(buffer, length: len)
    }
}
