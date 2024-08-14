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
    func presentMakeASandwichButton(response: SearchHistories.ValidateWords.Response)
    func presentError(response: SearchHistories.ShowError.Response)
}

class SearchHistoriesPresenter {
    internal init(view: any SearchHistoriesDisplayLogic) {
        self.view = view
    }

    private let view: SearchHistoriesDisplayLogic
}

extension SearchHistoriesPresenter: SearchHistoriesPresentationLogic {
    func presentMakeASandwichButton(response: SearchHistories.ValidateWords.Response) {
        view.displayMakeASandwich(viewModel: .init(isDisabled: !response.isValid))
    }

    func presentLanguage(response: SearchHistories.ChangeLanguage.Response) {
        view.displayLanguage(viewModel: .init(
            locale: response.locale,
            countryCode: response.countryCode
        ))
    }

    func presentHistories(response: SearchHistories.LoadHistories.Response) {
        view.displayHistories(viewModel: .init(items: response.items))
    }

    func presentError(response: SearchHistories.ShowError.Response) {
        view.displayError(viewModel: .init(error: response.error))
    }
}
