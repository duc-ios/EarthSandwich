//
//  Validator.swift
//  EarthSandwich
//
//  Created by Duc on 7/8/24.
//

@testable import EarthSandwich
import XCTest

final class ValidatorTests: XCTestCase {
    func testIsValidThreeWords() {
        // Given
        let true1 = "what.three.words"
        let false1 = "//what.three.words"
        let false2 = "what,three,words"

        // When
        let resultTrue1 = Validator.isValidThreeWords(true1)
        let resultFalse1 = Validator.isValidThreeWords(false2)
        let resultFalse2 = Validator.isValidThreeWords(false2)

        // Then
        XCTAssertTrue(resultTrue1)
        XCTAssertFalse(resultFalse1)
        XCTAssertFalse(resultFalse2)
    }
}
