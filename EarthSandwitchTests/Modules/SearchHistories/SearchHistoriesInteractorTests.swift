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
    private var repository: W3WRepository!

    @MainActor override func setUp() {
        super.setUp()

        UIView.setAnimationsEnabled(false)

        presenter = SearchHistoriesPresenterMock()
        repository = MockW3WRepository(apiKey: "")

        // swiftlint:disable:next force_try
        let container = try! ModelContainer(for: SearchHistory.self, configurations: .init(isStoredInMemoryOnly: true))
        sut = SearchHistoriesInteractor(
            presenter: presenter,
            modelContext: container.mainContext,
                        repository: repository
        )
    }

    override func tearDown() {
        sut = nil
        presenter = nil
        repository = nil

        super.tearDown()
    }

    func testValidateWords() {
        // Ginven
        let words = "///what.three.words"
        let request = SearchHistories.ValidateWords.Request(words: words)

        // When
        sut.validateWords(request: request)

        // Then
        XCTAssert(presenter.presentMakeASandwichButtonCalled)
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

    func testAddItem() {
        // Given
        let words = "mướp đắng.nhận lời.đỏ hồng"
        let count = sut.items.count
        let promise = expectation(description: "New item added")

        // When
        sut.addItem(request: .init(words: words))

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self else { return }
            // Then
            XCTAssertEqual(sut.items.count, count + 1)
            XCTAssertTrue(presenter.presentHistoriesCalled)
            promise.fulfill()
        }

        wait(for: [promise], timeout: 5)
    }

    func testDeleteItems() {
        // Given
        let offsets = IndexSet(integer: 0)
        sut.items = [.init(timestamp: Date(), srcWords: "", srcLat: 0, srcLng: 0, desWords: "", desLat: 0, desLng: 0)]
        let count = sut.items.count

        // When
        sut.deleteItems(request: .init(offsets: offsets))

        // Then
        XCTAssertEqual(sut.items.count, count - 1)
        XCTAssertTrue(presenter.presentHistoriesCalled)
    }
}

final class SearchHistoriesPresenterMock: SearchHistoriesPresentationLogic {
    var presentMakeASandwichButtonCalled = false
    var presentLanguageCalled = false
    var presentHistoriesCalled = false
    var presentErrorCalled = false

    func presentMakeASandwichButton(response: SearchHistories.ValidateWords.Response) {
        presentMakeASandwichButtonCalled = true
    }

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
