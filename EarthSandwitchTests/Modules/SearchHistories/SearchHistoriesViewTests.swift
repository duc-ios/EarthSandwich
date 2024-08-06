//
//  SearchHistoriesViewModelTests.swift
//  EarthSandwich
//

@testable import EarthSandwich
import XCTest

final class SearchHistoriesViewTests: XCTestCase {
    private var sut: SearchHistoriesDisplayLogic!

    override func setUp() {
        super.setUp()

        UIView.setAnimationsEnabled(false)

        sut = SearchHistoriesView()
    }

    override func tearDown() {
        sut = nil

        UIView.setAnimationsEnabled(true)

        super.tearDown()
    }
}
