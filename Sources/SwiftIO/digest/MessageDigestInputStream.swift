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
 
 Created by dusan@saiko.cz on 2/10/16.
 */

import Foundation

public final class MessageDigestInputStream: DelegatingInputStream
{

    let digest: MessageDigest
    
    public init(_ stream: InputStreamSupport, digest: MessageDigest) {
        self.digest = digest
        super.init(stream)
    }

    public init(_ stream: InputStream, digest: MessageDigest) {
        self.digest = digest
        super.init(stream)
    }
    
    public override func read(_ buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) -> Int {
        let result = super.read(buffer, maxLength: len)
        
        if(result > 0) {
            digest.update(data: Data(UnsafeMutableBufferPointer(start: buffer, count: result)))
        }
        
        return result
    }
    
    public func hash() -> String {
        return digest.hash()
    }

    public func hash() -> Data {
        return digest.hash()
    }
}
