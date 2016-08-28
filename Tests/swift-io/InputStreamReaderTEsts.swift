//
//  InputStreamReaderTEsts.swift
//  swift-io
//
//  Created by Dusan Saiko on 06/08/16.
//
//


import XCTest
@testable import swift_io

class InputStreamReaderTests: XCTestCase
{
    let encodings = [
        String.Encoding.utf8,
        String.Encoding.windowsCP1250,
        String.Encoding.utf32BigEndian,
        String.Encoding.utf32LittleEndian,
        String.Encoding.utf16BigEndian,
        String.Encoding.utf16LittleEndian
    ]

    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    func test_ReadFromClosed() {
        let reader = try! InputStreamReader(InputStream(data: Data("test".utf8)))
        XCTAssert(reader.description.characters.count > 0)
        
        reader.close()
        reader.close()
        
        do {
            _ = try reader.read()
            XCTFail()
        } catch IOException.StreamAlreadyClosed(_) {
            //expected
        } catch  {
            XCTFail()
        }
    }
    
    func test_Read() {
        for encoding in encodings {
            let data = "Č".data(using: encoding)!

            var result = ""
            
            let reader = try! InputStreamReader(InputStream(data:data), encoding: encoding)
            
            while(true) {
                if let s = try! reader.read() {
                    result.append(s)
                } else {
                    break
                }
                
            }
            XCTAssertEqual(result, "Č")
        }
    }
    
    func test_ReadSmallBuffer() {
        for encoding in encodings {
            let data = "Č".data(using: encoding)!

            var result = ""
            
            let reader = try! InputStreamReader(InputStream(data:data), encoding: encoding, bufferSize: 1)
            
            while(true) {
                if let s = try! reader.read() {
                    result.append(s)
                } else {
                    break
                }
                
            }
            XCTAssertEqual(result, "Č")
        }
    }
    
    func test_ReadLongText() {
        for encoding in encodings {
            let text = "Gancorig vedl v závěru souboje o třetí místo s Uzbekem Ichtijorem Navruzovem 7:6. V posledních sekundách jen kolem svého soupeře tančil, vítězně zvedal ruce a odmítal bojovat, za což dostal od rozhodčích trestný bod."

            let data = text.data(using: encoding)!
        
            var result = ""
            let reader = try! InputStreamReader(InputStream(data:data), encoding: encoding)
            
            while(true) {
                if let s = try! reader.read() {
                    result.append(s)
                } else {
                    break
                }
                
            }
            XCTAssertEqual(result, text)
        }
    }

    func test_ReadLongTextSmallerBuffer() {
        let text = "Gancorig vedl v závěru souboje o třetí místo s Uzbekem Ichtijorem Navruzovem 7:6. V posledních sekundách jen kolem svého soupeře tančil, vítězně zvedal ruce a odmítal bojovat, za což dostal od rozhodčích trestný bod."

        for encoding in encodings {
            
            let data = text.data(using: encoding)!
            
            var result = ""
            let reader = try! InputStreamReader(InputStream(data:data), encoding: encoding, bufferSize: 2)
            
            while(true) {
                if let s = try! reader.read() {
                    result.append(s)
                } else {
                    break
                }
                
            }
            print(encoding)
            print(result)
            XCTAssertEqual(result, text)
        }
    }
    
    func test_EmptyFile() {
        let path = NSTemporaryDirectory() + "file.txt"
        FileManager.default.createFile(atPath: path, contents: nil, attributes: [:])
        
        
        let reader = try! FileReader(URL(fileURLWithPath: path))
        
        let s = try! reader.read()
        XCTAssertNil(s)
    }
    
    func test_ChineseSmallBuffer() {
        let text = "Hi! 大家好！It's contains Chinese!"
        
        for encoding in encodings {
            if(encoding == String.Encoding.windowsCP1250) {
                continue
            }
            
            let data = text.data(using: encoding)!
            
            var result = ""
            let reader = try! InputStreamReader(InputStream(data:data), encoding: encoding, bufferSize: 2)
            
            while(true) {
                if let s = try! reader.read() {
                    result.append(s)
                } else {
                    break
                }
                
            }
            print(encoding)
            print(result)
            XCTAssertEqual(result, text)
        }
    }
    
    func test_Chinese() {
        let text = "Hi! 大家好！It's contains Chinese!"
        
        for encoding in encodings {
            if(encoding == String.Encoding.windowsCP1250) {
                continue
            }
            
            let data = text.data(using: encoding)!
            
            var result = ""
            let reader = try! InputStreamReader(InputStream(data:data), encoding: encoding)
            
            while(true) {
                if let s = try! reader.read() {
                    result.append(s)
                } else {
                    break
                }
                
            }
            print(encoding)
            print(result)
            XCTAssertEqual(result, text)
        }
    }

    
    func test_UnsupportedEncodings() {
        let data = "Č".data(using: .utf8)!

        var reader = try? InputStreamReader(InputStream(data:data), encoding: .utf16)
        XCTAssertNil(reader)

        reader = try? InputStreamReader(InputStream(data:data), encoding: .utf32)
        XCTAssertNil(reader)

        reader = try? InputStreamReader(InputStream(data:data), encoding: .unicode)
        XCTAssertNil(reader)

        reader = try? InputStreamReader(InputStream(data:data), encoding: .utf8)
        XCTAssertNotNil(reader)
    }
}
