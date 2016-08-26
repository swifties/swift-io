//
//  CSVReader.swift
//  swift-io
//
//  Created by Dusan Saiko on 08/08/16.
//
//

import Foundation

//public class CSVReader: Closeable
//{
//    let reader: BufferedReader
//    
//    /**
//     Constructs CSVReader with supplied separator, quote char, escape char and line ending.
//     
//     - Parameter writer: The writer to an underlying CSV source.
//     - Parameter separator: The delimiter to use for separating entries.
//     - Parameter quoteChar: The character to use for quoted elements.
//     - Parameter escapeChar: The character to use for escaping quotechars or escapechars
//     - Parameter lineEnd: The line feed terminator to use.
//     */
//    public init(reader:     Reader,
//                encoding:   String.Encoding = StringWriter.DEFAUTL_ENCODING,
//                separator:  String = CSVWriter.DEFAULT_SEPARATOR,
//                quoteChar:  String = CSVWriter.DEFAULT_QUOTE_CHARACTER,
//                escapeChar: String = CSVWriter.DEFAULT_ESCAPE_CHARACTER)
//    {
//        self.reader     = BufferedReader(reader, encoding: encoding)
//        self.separator  = separator
//        self.quoteChar  = quoteChar
//        self.escapeChar = escapeChar
//        self.lineEnd    = lineEnd
//    }
//}
