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
 
 Created by dusan@saiko.cz on 21/09/16.
*/

import Foundation

/**
  A Closeable is a source or destination of data that can be closed.
  The close method is invoked to release resources that the object is
  holding (such as open files).
 */
public protocol Closeable
{

    /**
     Closes the resource and releases any system resources associated with it. 
     Once the resource has been closed, further reads/writes will throw an Exception.
     Closing a previously closed resource has no effect.
     
     - Throws: Exception if an I/O error occurs.
     */
    func close() throws
}
