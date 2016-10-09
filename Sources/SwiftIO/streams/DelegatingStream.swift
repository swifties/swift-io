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

public class DelegatingStream: StreamSupport
{
    private var stream: StreamSupport
    
    
    public init(_ stream: StreamSupport) {
        self.stream = stream
    }

    public init(_ stream: Stream) {
        self.stream = DelegatingStreamNativeWrapper(stream)
    }
    
    
    public var streamStatus: Stream.Status {
        get {
            return stream.streamStatus
        }
    }
    
    public var streamError: Error? {
        get {
            return stream.streamError
        }
    }
    
    weak public var delegate: StreamDelegate? {
        get {
            return stream.delegate
        }
        set(value) {
            stream.delegate = value
        }
    }
    
    public func open() {
        stream.open()
    }
    
    public func close() {
        stream.close()
    }
    
    public func property(forKey key: Stream.PropertyKey) -> Any? {
        return stream.property(forKey: key)
    }
    
    public func setProperty(_ property: Any?, forKey key: Stream.PropertyKey) -> Bool {
        return stream.setProperty(property, forKey: key)
    }
    
    public func schedule(in aRunLoop: RunLoop, forMode mode: RunLoopMode) {
        stream.schedule(in: aRunLoop, forMode: mode)
    }
    
    public func remove(from aRunLoop: RunLoop, forMode mode: RunLoopMode) {
        stream.remove(from: aRunLoop, forMode: mode)
    }
}

class DelegatingStreamNativeWrapper: StreamSupport
{
    let stream: Stream
    
    init(_ stream: Stream) {
        self.stream = stream
    }

    var streamStatus: Stream.Status {
        get {
            return stream.streamStatus
        }
    }
    
    var streamError: Error? {
        get {
            return stream.streamError
        }
    }

    weak var delegate: StreamDelegate? {
        get {
            return stream.delegate
        }
        set(value) {
            stream.delegate = value
        }
    }
    
    public func open() {
        stream.open()
    }
    
    func close() {
        stream.close()
    }
    
    func property(forKey key: Stream.PropertyKey) -> Any? {
        return stream.property(forKey: key)
    }
    
    func setProperty(_ property: Any?, forKey key: Stream.PropertyKey) -> Bool {
        return stream.setProperty(property, forKey: key)
    }
    
    func schedule(in aRunLoop: RunLoop, forMode mode: RunLoopMode) {
        stream.schedule(in: aRunLoop, forMode: mode)
    }
    
    func remove(from aRunLoop: RunLoop, forMode mode: RunLoopMode) {
        stream.remove(from: aRunLoop, forMode: mode)
    }
    
}
