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
    func loadHistories(request: SearchHistories.LoadHistories.Request?)
    func addItem(request: SearchHistories.AddItem.Request)
    func deleteItems(request: SearchHistories.DeleteItem.Request)
}

class SearchHistoriesInteractor {
    internal init(presenter: SearchHistoriesPresentationLogic, worker: W3WWorker, modelContext: ModelContext) {
        self.presenter = presenter
        self.worker = worker
        self.modelContext = modelContext
    }

    private let presenter: SearchHistoriesPresentationLogic
    private let worker: W3WWorker
    private let modelContext: ModelContext

    private var items: [SearchHistory] = []
}

extension SearchHistoriesInteractor: SearchHistoriesBusinessLogic {
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
                let desWords = try await worker.convertToWords(desCoords)
                let newItem = SearchHistory(
                    timestamp: Date(),
                    srcWords: request.words, srcLat: coords.latitude, srcLng: coords.longitude,
                    desWords: desWords, desLat: desCoords.latitude, desLng: desCoords.longitude
                )
                modelContext.insert(newItem)
                loadHistories(request: .init())
            } catch {
                debugPrint(error)
                presenter.presentError(error)
            }
        }
    }

    func deleteItems(request: SearchHistories.DeleteItem.Request) {
        for index in request.offsets {
            modelContext.delete(items[index])
        }
        loadHistories(request: .init())
    }
}
