//
//  MIDIPacketListBuilderTests.swift
//  WebMIDIKitTests
//
//  Created by Adam Nemecek on 11/30/21.
//

import XCTest
import WebMIDIKit

func fill(_ b: MIDIPacketListBuilder) {
    b.append(timestamp: 1, data: [0,1,2,3])
    b.append(timestamp: 2, data: [4,5,6,7])
}

class MIDIPacketListBuilderTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
    }


    func testEqual() {
        let a = MIDIPacketListBuilder(byteSize: 1024)
        let b = MIDIPacketListBuilder(byteSize: 512)

        XCTAssert(a == b)

        fill(a)
        fill(b)

        XCTAssert(a == b)

        let empty = MIDIPacketListBuilder(byteSize: 256)
        b.clear()
        XCTAssert(b.isEmpty)
        XCTAssert(b == empty)
    }
}
