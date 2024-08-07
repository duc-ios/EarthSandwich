//
//  SearchHistoriesModels.swift
//  EarthSandwich
//
//  Created by Duc on 6/8/24.
//

import Foundation

// swiftlint:disable nesting
enum SearchHistories {
    enum ValidateWords {
        struct Request {
            var words: String
        }

        struct Response {
            var isValid: Bool
        }

        struct ViewModel {
            var isDisabled: Bool
        }
    }

    enum ChangeLanguage {
        struct Request {
            var locale: String
            var countryCode: String
        }

        struct Response {
            var locale: String
            var countryCode: String
        }

        struct ViewModel {
            var locale: String
            var countryCode: String
        }
    }

    enum LoadHistories {
        struct Request {}

        struct Response {
            var items: [SearchHistory]
        }

        struct ViewModel {
            var items: [SearchHistory]
        }
    }

    enum AddItem {
        struct Request {
            var words: String
        }

        struct Response {
            var item: SearchHistory
        }

        struct ViewModel {
            var items: [SearchHistory]
        }
    }

    enum DeleteItem {
        struct Request {
            var offsets: IndexSet
        }

        struct Response {
            var item: SearchHistory
        }

        struct ViewModel {
            var items: [SearchHistory]
        }
    }
}

// swiftlint:enable nesting
