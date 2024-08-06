//
//  SearchHistoriesPresenterTests.swift
//  EarthSandwich
//

@testable import EarthSandwich
import XCTest

final class SearchHistoriesPresenterTests: XCTestCase {
    private var sut: SearchHistoriesPresenter!
    private var view: SearchHistoriesViewMock!

    override func setUp() {
        super.setUp()

        UIView.setAnimationsEnabled(false)

        view = SearchHistoriesViewMock()
        sut = SearchHistoriesPresenter(view: view)
    }

    override func tearDown() {
        sut = nil

        super.tearDown()
    }

    func testDisplayHistories() {
        // Given
        let items = Seeds.items
        let response = SearchHistories.LoadHistories.Response(items: items)

        // When
        sut.presentHistories(response: response)

        // Then
        XCTAssertEqual(view.items, items)
    }

    func testDisplayError() {
        // Given
        let error: Error = "ERROR"

        // When
        sut.presentError(error)

        // Then
        XCTAssertEqual(view.message, (error as NSError).description)
    }
}

final class SearchHistoriesViewMock: SearchHistoriesDisplayLogic {
    var items: [SearchHistory] = []
    var message: String?

    func displayHistories(viewModel: EarthSandwich.SearchHistories.LoadHistories.ViewModel) {
        items = viewModel.items
    }

    func displayError(message: String) {
        self.message = message
    }
}
