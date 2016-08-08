//
//  Closeable.swift
//  swift-io
//
//  Created by Dusan Saiko on 08/08/16.
//
//

import Foundation

/**
 * A {@code Closeable} is a source or destination of data that can be closed.
 * The close method is invoked to release resources that the object is
 * holding (such as open files).
 *
 * @since 1.5
 */
public protocol Closeable
{

    /**
     Closes the resource and releases any system resources associated with it. 
     Once the resource has been closed, further reads/writes will throw an Exception.
     Closing a previously closed resource has no effect.
     
     - Throws: Exception if an I/O error occurs
     */
    func close() throws
}
