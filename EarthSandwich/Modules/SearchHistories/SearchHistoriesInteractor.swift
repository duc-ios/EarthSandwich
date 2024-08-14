//
//  SearchHistoriesInteractor.swift
//  EarthSandwich
//
//  Created by Duc on 7/8/24.
//

import CoreLocation
import SwiftData
import SwiftUI

protocol SearchHistoriesBusinessLogic {
    var repository: W3WRepository { get set }
    var items: [SearchHistory] { get set }

    func validateWords(request: SearchHistories.ValidateWords.Request)
    func changeLanguage(request: SearchHistories.ChangeLanguage.Request)
    func loadHistories(request: SearchHistories.LoadHistories.Request?)
    func addItem(request: SearchHistories.AddItem.Request)
    func deleteItems(request: SearchHistories.DeleteItem.Request)
}

class SearchHistoriesInteractor {
    internal init(presenter: SearchHistoriesPresentationLogic, modelContext: ModelContext, repository: W3WRepository) {
        self.presenter = presenter
        self.modelContext = modelContext
        self.repository = repository
    }

    private let presenter: SearchHistoriesPresentationLogic
    private let modelContext: ModelContext
    var repository: W3WRepository
    var items: [SearchHistory] = []

    private var lang: (locale: String, countryCode: String) = ("en", "EN")
}

extension SearchHistoriesInteractor: SearchHistoriesBusinessLogic {
    func validateWords(request: SearchHistories.ValidateWords.Request) {
        presenter.presentMakeASandwichButton(response: .init(
            isValid: Validator.isValidThreeWords(request.words)
        ))
    }

    func changeLanguage(request: SearchHistories.ChangeLanguage.Request) {
        lang = (request.locale, request.countryCode)
        let response = SearchHistories.ChangeLanguage.Response(
            locale: request.locale,
            countryCode: request.countryCode
        )
        presenter.presentLanguage(response: response)
    }

    func loadHistories(request: SearchHistories.LoadHistories.Request?) {
        guard request != nil else {
            return presenter.presentError(response: .init(error: AppError.badRequest))
        }

        do {
            let descriptor = FetchDescriptor<SearchHistory>(sortBy: [SortDescriptor(\.timestamp, order: .reverse)])
            items = try modelContext.fetch(descriptor)
            presenter.presentHistories(response: .init(items: items))
        } catch {
            debugPrint("Fetch Failed")
            presenter.presentError(response: .init(error: .error(error)))
        }
    }

    func addItem(request: SearchHistories.AddItem.Request) {
        Task {
            do {
                let coords = try await repository.convertToCoordinates(request.words)
                let desCoords = repository.calculateAntipode(coords)
                let desWords = try await repository.convertToWords(coords: desCoords, locale: lang.locale)
                let newItem = SearchHistory(
                    timestamp: Date(),
                    srcWords: request.words, srcLat: coords.latitude, srcLng: coords.longitude,
                    desWords: desWords, desLat: desCoords.latitude, desLng: desCoords.longitude
                )
                modelContext.insert(newItem)
                items.insert(newItem, at: 0)
                presenter.presentHistories(response: .init(items: items))
            } catch {
                debugPrint(error)
                presenter.presentError(response: .init(error: .error(error)))
            }
        }
    }

    func deleteItems(request: SearchHistories.DeleteItem.Request) {
        for index in request.offsets {
            modelContext.delete(items.remove(at: index))
        }
        presenter.presentHistories(response: .init(items: items))
    }
}
