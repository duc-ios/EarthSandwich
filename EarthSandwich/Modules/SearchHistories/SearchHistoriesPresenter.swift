//
//  SearchHistoriesPresenter.swift
//  EarthSandwich
//
//  Created by Duc on 6/8/24.
//

import Foundation

protocol SearchHistoriesPresentationLogic {
    func presentHistories(response: SearchHistories.LoadHistories.Response)
    func presentError(_ error: Error)
}

class SearchHistoriesPresenter {
    internal init(view: any SearchHistoriesDisplayLogic) {
        self.view = view
    }

    private let view: SearchHistoriesDisplayLogic
}

extension SearchHistoriesPresenter: SearchHistoriesPresentationLogic {
    func presentHistories(response: SearchHistories.LoadHistories.Response) {
        let viewModel = SearchHistories.LoadHistories.ViewModel(
            items: response.items
        )
        view.displayHistories(viewModel: viewModel)
    }

    func presentError(_ error: Error) {
        view.displayError(message: (error as NSError).description)
    }
}
