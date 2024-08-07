//
//  String+ErrorTests.swift
//  EarthSandwichTests
//
//  Created by Duc on 7/8/24.
//

import XCTest

final class StringErrorTests: XCTestCase {
    func testErrorDescription() {
        // Given
        let error = "error"

        // When
        let result = error.localizedDescription

        // Then
        XCTAssertEqual(error, result)
    }
}
