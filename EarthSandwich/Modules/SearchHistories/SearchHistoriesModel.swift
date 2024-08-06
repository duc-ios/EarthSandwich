//
//  SearchHistoriesModels.swift
//  EarthSandwich
//
//  Created by Duc on 6/8/24.
//

import Foundation

// swiftlint:disable nesting
enum SearchHistories {
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
