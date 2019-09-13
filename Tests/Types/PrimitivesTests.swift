//
//  PrimitivesTests.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class PrimitivesTests: XCTestCase {
    func testUnsignedIntegerHexInitializer() {
        XCTAssertEqual(0, UInt8(hexValue: "0"))
        XCTAssertEqual(0, UInt8(hexValue: "0x0"))
        XCTAssertEqual(UInt8.max, UInt8(hexValue: "0xff"))
        XCTAssertNil(UInt8(hexValue: "0xfg"))
        XCTAssertNil(UInt8(hexValue: "0xff1"))

        XCTAssertEqual(0, UInt16(hexValue: "0"))
        XCTAssertEqual(0, UInt16(hexValue: "0x0"))
        XCTAssertEqual(UInt16.max, UInt16(hexValue: "0xffff"))
        XCTAssertNil(UInt8(hexValue: "0xfffg"))
        XCTAssertNil(UInt8(hexValue: "0xffff1"))

        XCTAssertEqual(0, UInt32(hexValue: "0"))
        XCTAssertEqual(0, UInt32(hexValue: "0x0"))
        XCTAssertEqual(UInt32.max, UInt32(hexValue: "0xffffffff"))
        XCTAssertNil(UInt32(hexValue: "0xfffffffg"))
        XCTAssertNil(UInt32(hexValue: "0xffffffff1"))

        XCTAssertEqual(0, UInt64(hexValue: "0"))
        XCTAssertEqual(0, UInt64(hexValue: "0x0"))
        XCTAssertEqual(UInt64.max, UInt64(hexValue: "0xffffffffffffffff"))
        XCTAssertNil(UInt64(hexValue: "0xfffffffffffffffg"))
        XCTAssertNil(UInt64(hexValue: "0xffffffffffffffff1"))
    }

    func testUnsignedIntegerToHexString() {
        XCTAssertEqual("0x0", UInt8(0).hexString)
        XCTAssertEqual("0xff", UInt8.max.hexString)

        XCTAssertEqual("0x0", UInt16(0).hexString)
        XCTAssertEqual("0xffff", UInt16.max.hexString)

        XCTAssertEqual("0x0", UInt32(0).hexString)
        XCTAssertEqual("0xffffffff", UInt32.max.hexString)

        XCTAssertEqual("0x0", UInt64(0).hexString)
        XCTAssertEqual("0xffffffffffffffff", UInt64.max.hexString)

        XCTAssertEqual("0x400", UInt32(1024).hexString)
        XCTAssertEqual("0xabcdef", UInt32(11259375).hexString)
    }
}