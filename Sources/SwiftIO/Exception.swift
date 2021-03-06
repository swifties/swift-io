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
  Definition of generic exceptions.
 */
public enum Exception: Error {
    
    case MethodNotImplemented

    case InvalidStringEncoding              (string: String, requestedEncoding: String.Encoding, description: String?)
    case InvalidDataEncoding                (requestedEncoding: String.Encoding, description: String?)
    case RangeException                     (existingRange: Range<Int>, requestedRange: Range<Int>, description: String?)
}
