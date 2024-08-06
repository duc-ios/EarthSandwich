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

        sut = NetworkW3WWorker()
    }

    override func tearDown() {
        sut = nil

        super.tearDown()
    }

    func testCalculateAntipode() {
        // Given
        let coords = CLLocationCoordinate2D(latitude: 52.04, longitude: -0.76) // Milton Keynes

        // When
        let antipode = sut.calculateAntipode(coords) // Milton Keynes

        // Then
        XCTAssertEqual(
            antipode,
            CLLocationCoordinate2D(latitude: -52.04, longitude: 179.24)
        )
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        ceil(lhs.latitude) == ceil(rhs.latitude) && ceil(lhs.longitude) == ceil(rhs.longitude)
    }
}
