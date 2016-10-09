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
 Methods from Stream class translated to protocol.
 
 We these protocols as we want to delegate and chain to the Foundation.InputStream and we must be sure we delegate all methods availabe, which can not be done
 when new method would be added into the InputStream class.
 
 - SeeAlso: DelegatingInputStream
 - SeeAlso: Stream class for methods documentation
 */
public protocol StreamSupport {
    
    weak var delegate: StreamDelegate? {get set}

    func open()
    func close()
    
    func property(forKey key: Stream.PropertyKey) -> Any?
    func setProperty(_ property: Any?, forKey key: Stream.PropertyKey) -> Bool
    
    func schedule(in aRunLoop: RunLoop, forMode mode: RunLoopMode)
    func remove(from aRunLoop: RunLoop, forMode mode: RunLoopMode)
    
    var streamStatus: Stream.Status { get }
    var streamError: Error? { get }
}
