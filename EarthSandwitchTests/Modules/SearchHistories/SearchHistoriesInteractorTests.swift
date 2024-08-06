//
//  SearchHistoriesInteractorTests.swift
//  EarthSandwich
//

import CoreLocation
@testable import EarthSandwich
import SwiftData
import XCTest

final class SearchHistoriesInteractorTests: XCTestCase {
    private var sut: SearchHistoriesBusinessLogic!
    private var presenter: SearchHistoriesPresenterMock!
    private var worker: W3WWorker!

    @MainActor override func setUp() {
        super.setUp()

        UIView.setAnimationsEnabled(false)

        presenter = SearchHistoriesPresenterMock()
        worker = MockW3WWorker()

        // swiftlint:disable:next force_try
        let container = try! ModelContainer(for: SearchHistory.self, configurations: .init(isStoredInMemoryOnly: true))
        sut = SearchHistoriesInteractor(
            presenter: presenter,
            worker: worker,
            modelContext: container.mainContext
        )
    }

    override func tearDown() {
        sut = nil
        presenter = nil
        worker = nil

        super.tearDown()
    }

    func testChangeLanguage() {
        // Given
        let locale = "vi"
        let countryCode = "VN"
        let request = SearchHistories.ChangeLanguage.Request(locale: locale, countryCode: countryCode)

        // When
        sut.changeLanguage(request: request)

        // Then
        XCTAssertTrue(presenter.presentLanguageCalled)
    }

    func testLoadHistories() {
        // Given
        let request = SearchHistories.LoadHistories.Request()

        // When
        sut.loadHistories(request: request)

        // Then
        XCTAssertTrue(presenter.presentHistoriesCalled)
    }

    func testLoadHistoriesError() {
        // Given
        let request: SearchHistories.LoadHistories.Request? = nil

        // When
        sut.loadHistories(request: request)

        // Then
        XCTAssertTrue(presenter.presentErrorCalled)
    }
}

final class SearchHistoriesPresenterMock: SearchHistoriesPresentationLogic {
    var presentLanguageCalled = false
    var presentHistoriesCalled = false
    var presentErrorCalled = false

    func presentLanguage(response: SearchHistories.ChangeLanguage.Response) {
        presentLanguageCalled = true
    }

    func presentHistories(response: SearchHistories.LoadHistories.Response) {
        presentHistoriesCalled = true
    }

    func presentError(_ error: any Error) {
        presentErrorCalled = true
    }
}
