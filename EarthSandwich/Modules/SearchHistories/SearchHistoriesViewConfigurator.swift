//
//  SearchHistoriesViewConfiguration.swift
//  EarthSandwich
//
//  Created by Duc on 9/8/24.
//

import SwiftData
import SwiftUI

extension SearchHistoriesView {
    func configured(
        modelContext: ModelContext
    ) -> some View {
        var view = self
//        let repository = MockW3WRepository(apiKey: Configs.apiKey)
        let repository = NetworkW3WRepository(apiKey: Configs.apiKey)
        let presenter = SearchHistoriesPresenter(view: view)
        let interactor = SearchHistoriesInteractor(
            presenter: presenter,
            modelContext: modelContext,
            repository: repository
        )
        view.interactor = interactor
        return view
    }
}
