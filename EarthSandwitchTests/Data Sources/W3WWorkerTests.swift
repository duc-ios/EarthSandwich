//
//  W3WWorkerTests.swift
//  EarthSandwich
//
//  Created by Duc on 7/8/24.
//

import CoreLocation
@testable import EarthSandwich
import XCTest

final class W3WWorkerTests: XCTestCase {
    private var sut: W3WWorker!

    override func setUp() {
        super.setUp()

        sut = NetworkW3WWorker(apiKey: Configs.apiKey)
    }

    override func tearDown() {
        sut = nil

        super.tearDown()
    }

    func testConvertToCoordinates() {
        // given
        let words = "mướp đắng.nhận lời.đỏ hồng"
        let promise = expectation(description: "Coords Received")

        // when
        Task {
            do {
                let coords = try await sut.convertToCoordinates(words)
                // then
                XCTAssertEqual(coords, CLLocationCoordinate2D(latitude: 51.5209174, longitude: -0.1981336))
            } catch {
                debugPrint(error)
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }

    func testConvertToWords() {
        // given
        let coords = CLLocationCoordinate2D(latitude: 51.5209174, longitude: -0.1981336)
        let locale = "vi"
        let promise = expectation(description: "Words Received")

        // when
        Task {
            do {
                let words = try await sut.convertToWords(coords: coords, locale: locale)
                // then
                XCTAssertEqual(words, "mướp đắng.nhận lời.đỏ hồng")
                promise.fulfill()
            } catch {
                debugPrint(error)
            }
        }
        wait(for: [promise], timeout: 5)
    }

    func testCalculateAntipode() {
        // Given
        // what3words 65 Alfred Rd, London W2 5EU, United Kingdom
        let coords = CLLocationCoordinate2D(latitude: 51.5209174, longitude: -0.1981336)

        // When
        let antipode = sut.calculateAntipode(coords) // Milton Keynes

        // Then
        XCTAssertEqual(
            antipode,
            CLLocationCoordinate2D(latitude: -51.5209174, longitude: 179.80186640000002)
        )
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        String(format: "%.2f", lhs.latitude) == String(format: "%.2f", rhs.latitude)
            && String(format: "%.2f", lhs.longitude) == String(format: "%.2f", rhs.longitude)
    }
}
