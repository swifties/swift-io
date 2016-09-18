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
        String.Encoding.utf32,
        String.Encoding.utf16,
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
        let reader = InputStreamReader(InputStream(data: Data("test".utf8)))
        XCTAssert(reader.description.characters.count > 0)
        
        reader.close()
        reader.close()
        
        do {
            _ = try reader.read()
            XCTFail()
        } catch IOException.ErrorReadingFromStream(_) {
            //expected
        } catch  {
            XCTFail()
        }
    }
    
    func test_Read() {
        for encoding in encodings {
            let data = "Č".data(using: encoding)!

            
            let reader = InputStreamReader(InputStream(data:data), encoding: encoding)
            let result = try! reader.readAll()
            XCTAssertEqual(result, "Č")
        }
    }
    
    func test_ReadSmallBuffer() {
        for encoding in encodings {
            let data = "Č".data(using: encoding)!

            let reader = InputStreamReader(InputStream(data:data), encoding: encoding, bufferSize: 1)
            let result = try!reader.readAll()
            
            XCTAssertEqual(result, "Č")
        }
    }
    
    func test_ReadLongText() {
        for encoding in encodings {
            let text = "Gancorig vedl v závěru souboje o třetí místo s Uzbekem Ichtijorem Navruzovem 7:6. V posledních sekundách jen kolem svého soupeře tančil, vítězně zvedal ruce a odmítal bojovat, za což dostal od rozhodčích trestný bod.Gancorig vedl v závěru souboje o třetí místo s Uzbekem Ichtijorem Navruzovem 7:6. V posledních sekundách jen kolem svého soupeře tančil, vítězně zvedal ruce a odmítal bojovat, za což dostal od rozhodčích trestný bod.Gancorig vedl v závěru souboje o třetí místo s Uzbekem Ichtijorem Navruzovem 7:6. V posledních sekundách jen kolem svého soupeře tančil, vítězně zvedal ruce a odmítal bojovat, za což dostal od rozhodčích trestný bod.Gancorig vedl v závěru souboje o třetí místo s Uzbekem Ichtijorem Navruzovem 7:6. V posledních sekundách jen kolem svého soupeře tančil, vítězně zvedal ruce a odmítal bojovat, za což dostal od rozhodčích trestný bod.Gancorig vedl v závěru souboje o třetí místo s Uzbekem Ichtijorem Navruzovem 7:6. V posledních sekundách jen kolem svého soupeře tančil, vítězně zvedal ruce a odmítal bojovat, za což dostal od rozhodčích trestný bod.Gancorig vedl v závěru souboje o třetí místo s Uzbekem Ichtijorem Navruzovem 7:6. V posledních sekundách jen kolem svého soupeře tančil, vítězně zvedal ruce a odmítal bojovat, za což dostal od rozhodčích trestný bod.Gancorig vedl v závěru souboje o třetí místo s Uzbekem Ichtijorem Navruzovem 7:6. V posledních sekundách jen kolem svého soupeře tančil, vítězně zvedal ruce a odmítal bojovat, za což dostal od rozhodčích trestný bod.Gancorig vedl v závěru souboje o třetí místo s Uzbekem Ichtijorem Navruzovem 7:6. V posledních sekundách jen kolem svého soupeře tančil, vítězně zvedal ruce a odmítal bojovat, za což dostal od rozhodčích trestný bod.Gancorig vedl v závěru souboje o třetí místo s Uzbekem Ichtijorem Navruzovem 7:6. V posledních sekundách jen kolem svého soupeře tančil, vítězně zvedal ruce a odmítal bojovat, za což dostal od rozhodčích trestný bod.Gancorig vedl v závěru souboje o třetí místo s Uzbekem Ichtijorem Navruzovem 7:6. V posledních sekundách jen kolem svého soupeře tančil, vítězně zvedal ruce a odmítal bojovat, za což dostal od rozhodčích trestný bod.Gancorig vedl v závěru souboje o třetí místo s Uzbekem Ichtijorem Navruzovem 7:6. V posledních sekundách jen kolem svého soupeře tančil, vítězně zvedal ruce a odmítal bojovat, za což dostal od rozhodčích trestný bod.Gancorig vedl v závěru souboje o třetí místo s Uzbekem Ichtijorem Navruzovem 7:6. V posledních sekundách jen kolem svého soupeře tančil, vítězně zvedal ruce a odmítal bojovat, za což dostal od rozhodčích trestný bod.Gancorig vedl v závěru souboje o třetí místo s Uzbekem Ichtijorem Navruzovem 7:6. V posledních sekundách jen kolem svého soupeře tančil, vítězně zvedal ruce a odmítal bojovat, za což dostal od rozhodčích trestný bod.Gancorig vedl v závěru souboje o třetí místo s Uzbekem Ichtijorem Navruzovem 7:6. V posledních sekundách jen kolem svého soupeře tančil, vítězně zvedal ruce a odmítal bojovat, za což dostal od rozhodčích trestný bod.Gancorig vedl v závěru souboje o třetí místo s Uzbekem Ichtijorem Navruzovem 7:6. V posledních sekundách jen kolem svého soupeře tančil, vítězně zvedal ruce a odmítal bojovat, za což dostal od rozhodčích trestný bod.Gancorig vedl v závěru souboje o třetí místo s Uzbekem Ichtijorem Navruzovem 7:6. V posledních sekundách jen kolem svého soupeře tančil, vítězně zvedal ruce a odmítal bojovat, za což dostal od rozhodčích trestný bod.Gancorig vedl v závěru souboje o třetí místo s Uzbekem Ichtijorem Navruzovem 7:6. V posledních sekundách jen kolem svého soupeře tančil, vítězně zvedal ruce a odmítal bojovat, za což dostal od rozhodčích trestný bod.Gancorig vedl v závěru souboje o třetí místo s Uzbekem Ichtijorem Navruzovem 7:6. V posledních sekundách jen kolem svého soupeře tančil, vítězně zvedal ruce a odmítal bojovat, za což dostal od rozhodčích trestný bod.Gancorig vedl v závěru souboje o třetí místo s Uzbekem Ichtijorem Navruzovem 7:6. V posledních sekundách jen kolem svého soupeře tančil, vítězně zvedal ruce a odmítal bojovat, za což dostal od rozhodčích trestný bod.Gancorig vedl v závěru souboje o třetí místo s Uzbekem Ichtijorem Navruzovem 7:6. V posledních sekundách jen kolem svého soupeře tančil, vítězně zvedal ruce a odmítal bojovat, za což dostal od rozhodčích trestný bod.Gancorig vedl v závěru souboje o třetí místo s Uzbekem Ichtijorem Navruzovem 7:6. V posledních sekundách jen kolem svého soupeře tančil, vítězně zvedal ruce a odmítal bojovat, za což dostal od rozhodčích trestný bod.Gancorig vedl v závěru souboje o třetí místo s Uzbekem Ichtijorem Navruzovem 7:6. V posledních sekundách jen kolem svého soupeře tančil, vítězně zvedal ruce a odmítal bojovat, za což dostal od rozhodčích trestný bod.Gancorig vedl v závěru souboje o třetí místo s Uzbekem Ichtijorem Navruzovem 7:6. V posledních sekundách jen kolem svého soupeře tančil, vítězně zvedal ruce a odmítal bojovat, za což dostal od rozhodčích trestný bod.Gancorig vedl v závěru souboje o třetí místo s Uzbekem Ichtijorem Navruzovem 7:6. V posledních sekundách jen kolem svého soupeře tančil, vítězně zvedal ruce a odmítal bojovat, za což dostal od rozhodčích trestný bod.Gancorig vedl v závěru souboje o třetí místo s Uzbekem Ichtijorem Navruzovem 7:6. V posledních sekundách jen kolem svého soupeře tančil, vítězně zvedal ruce a odmítal bojovat, za což dostal od rozhodčích trestný bod.Gancorig vedl v závěru souboje o třetí místo s Uzbekem Ichtijorem Navruzovem 7:6. V posledních sekundách jen kolem svého soupeře tančil, vítězně zvedal ruce a odmítal bojovat, za což dostal od rozhodčích trestný bod."

            let data = text.data(using: encoding)!
        
            let reader = InputStreamReader(InputStream(data:data), encoding: encoding)
            let result = try!reader.readAll()
            XCTAssertEqual(result, text)
        }
    }

    func test_ReadLongTextSmallerBuffer() {
        let text = "Gancorig vedl v závěru souboje o třetí místo s Uzbekem Ichtijorem Navruzovem 7:6. V posledních sekundách jen kolem svého soupeře tančil, vítězně zvedal ruce a odmítal bojovat, za což dostal od rozhodčích trestný bod."

        for encoding in encodings {
            
            let data = text.data(using: encoding)!
            
            let reader = InputStreamReader(InputStream(data:data), encoding: encoding, bufferSize: 2)
            let result = try!reader.readAll()
            XCTAssertEqual(result, text)
        }
    }
    
    func test_EmptyFile() {
        let path = NSTemporaryDirectory() + "file.txt"
        FileManager.default.createFile(atPath: path, contents: nil, attributes: [:])
        
        
        let reader = try! FileReader(URL(fileURLWithPath: path))
        
        let s = try! reader.read()
        XCTAssertEqual(s, "")
    }
    
    func test_ChineseSmallBuffer() {
        let text = "Hi! 大家好！It's contains Chinese!"
        
        for encoding in encodings {
            if(encoding == String.Encoding.windowsCP1250) {
                continue
            }
            
            let data = text.data(using: encoding)!
            
            let reader = InputStreamReader(InputStream(data:data), encoding: encoding, bufferSize: 2)
            let result = try!reader.readAll()
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
            
            let reader = InputStreamReader(InputStream(data:data), encoding: encoding)
            let result = try!reader.readAll()
            XCTAssertEqual(result, text)
            
            XCTAssertNil(try! reader.read())
        }
    }
    
    func test_WrongEncoding() {
        let text = "Hi! 大家好！It's contains Chinese!"
        
        let data = text.data(using: .utf8)!
        
        do {
            let reader = InputStreamReader(InputStream(data:data), encoding: .utf16)
            _ = try reader.readAll()
            XCTFail()
        } catch Exception.InvalidDataEncoding(_, _) {
            //expected
        } catch  {
            XCTFail()
        }
        
        do {
            let reader = InputStreamReader(InputStream(data:data), encoding: .utf32)
            _ = try reader.readAll()
            XCTFail()
        } catch Exception.InvalidDataEncoding(_, _) {
            //expected
        } catch  {
            XCTFail()
        }
    }
    
    func test_BOMEncoding16() {
        let text = "Hi! 大家好！It's contains Chinese!"
        
        var data = Data(bytes: InputStreamReader.UTF16BE_BOM)
        data.append(text.data(using: .utf16BigEndian)!)
        
        let reader = InputStreamReader(InputStream(data:data), encoding: .utf16)
        XCTAssertEqual(text, try! reader.readAll())
    }
    
    func test_BOMEncoding32() {
        let text = "Hi! 大家好！It's contains Chinese!"
        
        var data = Data(bytes: InputStreamReader.UTF32BE_BOM)
        data.append(text.data(using: .utf32BigEndian)!)
        
        let reader = InputStreamReader(InputStream(data:data), encoding: .utf32)
        XCTAssertEqual(text, try! reader.readAll())
    }
    
    func test_NoString() {
        let data:     [UInt8] = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF]
        let reader = InputStreamReader(InputStream(data:Data(bytes: data)), encoding: .utf32BigEndian, bufferSize: 8)
        do {
            _ = try reader.readAll()
            XCTFail()
        } catch Exception.InvalidDataEncoding(_, _) {
            //expected
        } catch  {
            XCTFail()
        }
    }
    
    func test_InvalidEncoding() {
        let reader = try? StringReader("ČŘˇÍŤ", encoding: .ascii)
        XCTAssertNil(reader)
    }

}
