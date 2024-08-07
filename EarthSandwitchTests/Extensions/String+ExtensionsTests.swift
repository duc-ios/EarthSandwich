//
//  String+ExtensionsTests.swift
//  EarthSandwichTests
//
//  Created by Duc on 7/8/24.
//

@testable import EarthSandwich
import XCTest

final class StringExtensionsTest: XCTestCase {
    func testIsNilOrBlank() {
        // Given
        let optionalString: String? = " string "
        let emptyString: String? = ""
        let nilString: String? = nil

        // When
        let optionalResult = optionalString.isNilOrBlank
        let emptyResult = emptyString.isNilOrBlank
        let nilResult = nilString.isNilOrBlank

        // Then
        XCTAssertFalse(optionalResult)
        XCTAssertTrue(emptyResult)
        XCTAssertTrue(nilResult)
    }

    func testIsBlank() {
        // Given
        let string = " string "
        let emptyString = ""

        // When
        let optionalResult = string.isBlank
        let emptyResult = emptyString.isBlank

        // Then
        XCTAssertFalse(optionalResult)
        XCTAssertTrue(emptyResult)
    }

    func testTrimmed() {
        // Given
        let string = " string "
        let whiteSpaces = "  "

        // When
        let stringResult = string.trimmed
        let whiteSpacesResult = whiteSpaces.trimmed

        // Then
        XCTAssertEqual(stringResult, "string")
        XCTAssertEqual(whiteSpacesResult, "")
    }
}
