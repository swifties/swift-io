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

 Strongly inspired by http://opencsv.sourceforge.net

 Swift version created by dusan@saiko.cz on 03/07/16.
*/

import Foundation

/**
 * Simple CSV writer released under a commercial-friendly license.
 */
public class CSVWriter {

    public static let   INITIAL_STRING_SIZE = 1024

    /**
     * The character used for escaping quotes.
     */
    public static let   DEFAULT_ESCAPE_CHARACTER = "\""

    /**
     * The default separator to use if none is supplied to the constructor.
     */
    public static let   DEFAULT_SEPARATOR = ","

    /**
     * The default quote character to use if none is supplied to the
     * constructor.
     */
    public static let   DEFAULT_QUOTE_CHARACTER = "\""

    /**
     * The quote constant to use when you wish to suppress all quoting.
     */
    public static let   NO_QUOTE_CHARACTER = "\u{0000}"

    /**
     * The escape constant to use when you wish to suppress all escaping.
     */
    public static let   NO_ESCAPE_CHARACTER = "\u{0000}"

    /**
     * Default line terminator.
     */
    public static let   UNIX_LINE_END = "\n"
    
    /**
     * Default line terminator.
     */
    public static let   CARRIAGE_RETURN = "\r"

    /**
     * RFC 4180 compliant line terminator.
     */
    public static let   RFC4180_LINE_END = "\r\n"
    
    /**
     * Default line terminator.
     */
    public static let   DEFAULT_LINE_END = UNIX_LINE_END

    let writer      : Writer
    let separator   : String
    let quoteChar   : String
    let escapeChar  : String
    let lineEnd     : String

    /**
     Constructs CSVWriter with supplied separator, quote char, escape char and line ending.

     - Parameter writer: The writer to an underlying CSV source.
     - Parameter separator: The delimiter to use for separating entries.
     - Parameter quoteChar: The character to use for quoted elements.
     - Parameter escapeChar: The character to use for escaping quotechars or escapechars
     - Parameter lineEnd: The line feed terminator to use.
    */
    public init(writer:     Writer,
                separator:  String = DEFAULT_SEPARATOR,
                quoteChar:  String = DEFAULT_QUOTE_CHARACTER,
                escapeChar: String = DEFAULT_ESCAPE_CHARACTER,
                lineEnd:    String = DEFAULT_LINE_END
    ) {
        self.writer     = writer
        self.separator  = separator
        self.quoteChar  = quoteChar
        self.escapeChar = escapeChar
        self.lineEnd    = lineEnd
    }

    /**
     Writes the column names.
     
     - Parameter columnNames: array containing column names.
     - Parameter applyQuotesToAll: True if all values are to be quoted. False if quotes only
        to be applied to values which contain the separator, escape,
        quote or new line characters.
      - Throws: IOException
     */
    public func writeColumnNames(columnNames: [String], applyQuotesToAll: Bool = true) throws
    {
        try writeNext(line: columnNames, applyQuotesToAll: applyQuotesToAll)
    }
    
    /**
     Writes array of records to a CSV file. The list is assumed to be a String[]
     - Parameter allLines: Array of String[], with each String[] representing a line of the file
     - Parameter applyQuotesToAll: True if all values are to be quoted. False if quotes only
        to be applied to values which contain the separator, escape,
        quote or new line characters.
     - Throws: IOException
     */
    public func writeAll(allLines: [[String]], applyQuotesToAll: Bool = true) throws
    {
        for line in allLines {
            try writeNext(line: line, applyQuotesToAll: applyQuotesToAll)
        }
    }
    
    /**
     Writes sequence of records to a CSV file. The list is assumed to be a String[]
     - Parameter allLines: Array of String[], with each String[] representing a line of the file
     - Parameter applyQuotesToAll: True if all values are to be quoted. False if quotes only
        to be applied to values which contain the separator, escape,
        quote or new line characters.
     - Throws: IOException
     */
    public func writeAll<StringArraySequence: Sequence>(allLines: StringArraySequence, applyQuotesToAll: Bool) throws where StringArraySequence.Iterator.Element == [String]
    {
        for line in allLines {
            try writeNext(line: line, applyQuotesToAll: applyQuotesToAll)
        }
    }
    
    /**
     Flush underlying stream to writer.
     - Throws: IOException If bad things happen
    */
    public func flush() throws {
        try writer.flush()
    }
    
    /**
     Close the underlying stream writer flushing any buffered content.
     - Throws: IOException If bad things happen
    */
    public func close() throws
    {
        try writer.close()
    }

    /**
      Writes the next line to the file.  This method is a fail-fast method that will throw the
      IOException of the writer supplied to the CSVWriter (if the Writer does not handle the exceptions itself like
      the PrintWriter class).
     
      - Parameter nextLine: A string array with each comma-separated element as a separate entry.
      - Parameter applyQuotesToAll: True if all values are to be quoted. False applies quotes only to values which contain the separator, escape, quote or new line characters.
      - Throws: Exception thrown by the writer supplied to CSVWriter.
     */
    public func writeNext(line: [String], applyQuotesToAll: Bool = true) throws
    {
        var appendable = String()
        
        for (i, nextElement) in line.enumerated() {
            if (i != 0) {
                appendable.append(separator)
            }

            let stringContainsSpecialCharacters = self.stringContainsSpecialCharacters(line: nextElement)

            if ((applyQuotesToAll || stringContainsSpecialCharacters) && quoteChar != CSVWriter.NO_QUOTE_CHARACTER) {
                appendable.append(quoteChar)
            }
            
            if (stringContainsSpecialCharacters) {
                processLine(nextElement: nextElement, appendable: &appendable)
            } else {
                appendable.append(nextElement)
            }
            
            if ((applyQuotesToAll || stringContainsSpecialCharacters) && quoteChar != CSVWriter.NO_QUOTE_CHARACTER) {
                appendable.append(quoteChar)
            }

        }
        
        appendable.append(lineEnd)
        try writer.write(string: appendable)
    }
    
    /**
     Checks to see if the line contains special characters.
     - Parameter line: Element of data to check for special characters.
     - Returns: True if the line contains the quote, escape, separator, newline, or return.
     */
    internal func stringContainsSpecialCharacters(line: String) -> Bool
    {
        //TODO: measure performance regular expression match vs loop vs contains()
        return line.contains(quoteChar)
            || line.contains(escapeChar)
            || line.contains(separator)
            || line.contains(CSVWriter.UNIX_LINE_END)
            || line.contains(CSVWriter.CARRIAGE_RETURN)
    }
    
    /**
     Processes all the characters in a line.
     - Parameter nextElement: Element to process.
     - Parameter appendable: Appendable holding the processed data.
     */
    internal func processLine(nextElement: String, appendable: inout String)
    {
        for nextChar in nextElement.characters {
            //TODO: measure performance Character -> String
            if (escapeChar != CSVWriter.NO_ESCAPE_CHARACTER && checkCharactersToEscape(nextChar: "\(nextChar)")) {
                appendable.append(escapeChar)
            }
            appendable.append(nextChar)
        }
    }

    internal func checkCharactersToEscape(nextChar: String) -> Bool
    {
        return quoteChar == CSVWriter.NO_QUOTE_CHARACTER
                ? (nextChar == quoteChar || nextChar == escapeChar || nextChar == separator)
                : (nextChar == quoteChar || nextChar == escapeChar)
    }
}

