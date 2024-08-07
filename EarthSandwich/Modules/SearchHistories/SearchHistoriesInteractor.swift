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
    var worker: W3WWorker { get set }
    var items: [SearchHistory] { get set }

    func validateWords(request: SearchHistories.ValidateWords.Request)
    func changeLanguage(request: SearchHistories.ChangeLanguage.Request)
    func loadHistories(request: SearchHistories.LoadHistories.Request?)
    func addItem(request: SearchHistories.AddItem.Request)
    func deleteItems(request: SearchHistories.DeleteItem.Request)
}

class SearchHistoriesInteractor {
    internal init(presenter: SearchHistoriesPresentationLogic, modelContext: ModelContext, worker: W3WWorker) {
        self.presenter = presenter
        self.modelContext = modelContext
        self.worker = worker
    }

    private let presenter: SearchHistoriesPresentationLogic
    private let modelContext: ModelContext
    var worker: W3WWorker
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
            return presenter.presentError("Bad Request")
        }

        do {
            let descriptor = FetchDescriptor<SearchHistory>(sortBy: [SortDescriptor(\.timestamp, order: .reverse)])
            items = try modelContext.fetch(descriptor)
            presenter.presentHistories(response: .init(items: items))
        } catch {
            debugPrint("Fetch Failed")
            presenter.presentError(error)
        }
    }

    func addItem(request: SearchHistories.AddItem.Request) {
        Task {
            do {
                let coords = try await worker.convertToCoordinates(request.words)
                let desCoords = worker.calculateAntipode(coords)
                let desWords = try await worker.convertToWords(coords: desCoords, locale: lang.locale)
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
                presenter.presentError(error)
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
