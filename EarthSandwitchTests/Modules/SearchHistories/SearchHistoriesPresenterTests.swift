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

    func testValidateValidWords() {
        // Given
        let words = "///what.three.words"
        let response = SearchHistories.ValidateWords.Response(isValid: true)

        // When
        sut.presentMakeASandwichButton(response: response)

        // Then
        XCTAssertEqual(view.isMakeASandwichButtonDisabled, false)
    }

    func testValidateInvalidWords() {
        // Given
        let words = "///what.three.words"
        let response = SearchHistories.ValidateWords.Response(isValid: false)

        // When
        sut.presentMakeASandwichButton(response: response)

        // Then
        XCTAssertEqual(view.isMakeASandwichButtonDisabled, true)
    }

    func testDisplayLanguage() {
        // Given
        let locale = "vi"
        let countryCode = "VN"
        let response = SearchHistories.ChangeLanguage.Response(locale: locale, countryCode: countryCode)

        // When
        sut.presentLanguage(response: response)

        // Then
        XCTAssertEqual(view.locale, locale)
        XCTAssertEqual(view.countryCode, countryCode)
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
        sut.presentError(response: .init(error: error))

        // Then
        XCTAssertEqual(view.message, (error as NSError).description)
    }
}

final class SearchHistoriesViewMock: SearchHistoriesDisplayLogic {
    var locale: String?
    var countryCode: String?
    var items: [SearchHistory] = []
    var message: String?
    var isMakeASandwichButtonDisabled = false

    func displayMakeASandwich(viewModel: SearchHistories.ValidateWords.ViewModel) {
        isMakeASandwichButtonDisabled = viewModel.isDisabled
    }

    func displayLanguage(viewModel: SearchHistories.ChangeLanguage.ViewModel) {
        locale = viewModel.locale
        countryCode = viewModel.countryCode
    }

    func displayHistories(viewModel: EarthSandwich.SearchHistories.LoadHistories.ViewModel) {
        items = viewModel.items
    }

    func displayError(viewModel: EarthSandwich.SearchHistories.ShowError.ViewModel) {
        self.message = viewModel.message
    }
}
