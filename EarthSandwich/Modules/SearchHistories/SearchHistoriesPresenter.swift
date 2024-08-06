//
//  SearchHistoriesPresenter.swift
//  EarthSandwich
//
//  Created by Duc on 6/8/24.
//

import Foundation

protocol SearchHistoriesPresentationLogic {
    func presentLanguage(response: SearchHistories.ChangeLanguage.Response)
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
    func presentLanguage(response: SearchHistories.ChangeLanguage.Response) {
        let viewModel = SearchHistories.ChangeLanguage.ViewModel(
            locale: response.locale,
            countryCode: response.countryCode
        )
        view.displayLanguage(viewModel: viewModel)
    }

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
