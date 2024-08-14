//
//  SearchHistoriesDataStore.swift
//  EarthSandwich
//
//  Created by Duc on 9/8/24.
//

import Foundation

class SearchHistoriesDataStore: ObservableObject {
    // swiftlint:disable:next large_tuple
    let languages: [(name: String, locale: String, countryCode: String)] = [
        ("English", "en", "EN"),
        ("Tiếng Việt", "vi", "VN")
    ]

    @Published var lang: (locale: String, countryCode: String) = ("en", "EN")
    @Published var items: [SearchHistory] = []
    @Published var text = ""
    @Published var focusing = false
    @Published var isMakeASandwichButtonDisabled = true
    @Published var error: AppError?
    @Published var displayError = false
}
