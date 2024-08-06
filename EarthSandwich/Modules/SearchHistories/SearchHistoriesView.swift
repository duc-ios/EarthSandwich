//
//  SearchHistoriesView.swift
//  EarthSandwich
//
//  Created by Duc on 6/8/24.
//

import SwiftData
import SwiftUI

protocol SearchHistoriesDisplayLogic {
    func displayHistories(viewModel: SearchHistories.LoadHistories.ViewModel)
    func displayError(message: String)
}

extension SearchHistoriesView: SearchHistoriesDisplayLogic {
    func displayHistories(viewModel: SearchHistories.LoadHistories.ViewModel) {
        DispatchQueue.main.async {
            store.items = viewModel.items
        }
    }

    func displayError(message: String) {
        DispatchQueue.main.async {
            store.errorMessage = message
            store.displayError = true
        }
    }
}

class SearchHistoriesDataStore: ObservableObject {
    @Published var items: [SearchHistory] = []
    @Published var text = ""
    @Published var focusing = false
    @Published var errorMessage: String?
    @Published var displayError = false
}

extension SearchHistoriesView {
    func configureView(modelContext: ModelContext) -> some View {
        var view = self
//        let worker = MockW3WWorker()
        let worker = NetworkW3WWorker()
        let presenter = SearchHistoriesPresenter(view: view)
        let interactor = SearchHistoriesInteractor(
            presenter: presenter,
            worker: worker,
            modelContext: modelContext
        )
        view.interactor = interactor
        return view
    }
}

struct SearchHistoriesView: View {
    var interactor: SearchHistoriesBusinessLogic!

    @ObservedObject var store = SearchHistoriesDataStore()

    var body: some View {
        VStack {
            Text({
                var text = AttributedString("///")
                text.foregroundColor = .red
                return text
            }() + AttributedString("enter.three.words"))

            AutoSuggestTextField(text: $store.text, focusing: $store.focusing)
                .frame(
                    maxHeight: store.focusing ? .infinity : 44
                )

//            ZStack {
//                Text(slashes + AttributedString(store.text))
//                    .font(.largeTitle)
//                    .lineLimit(1)
//
//                TextField("", text: $store.text)
//                    .multilineTextAlignment(.center)
//                    .frame(height: 44)
//                    .autocapitalization(.none)
//                    .font(.largeTitle)
//                    .foregroundStyle(.clear)
//                    .padding(.leading, 28)
//            }

            if store.focusing {
                Spacer()
            } else {
                if !store.text.isBlank {
                    Button("Make a sandwich") {
                        interactor.addItem(request: .init(words: store.text))
                    }
                }

                if store.items.isEmpty {
                    Spacer()
                    Text("No data")
                        .foregroundStyle(.secondary)
                    Spacer()
                } else {
                    List {
                        ForEach(store.items) {
                            ItemCardView(item: $0)
                        }
                        .onDelete {
                            interactor.deleteItems(request: .init(offsets: $0))
                        }
                    }
                }
            }
        }
        .onAppear {
            interactor.loadHistories(request: .init())
        }
        .alert("Error", isPresented: $store.displayError, actions: {
            Button("OK") {}
        }, message: {
            Text(store.errorMessage ?? "")
        })
    }
}

#if DEBUG
#Preview {
    // swiftlint:disable:next force_try
    let container = try! ModelContainer(for: SearchHistory.self, configurations: .init(isStoredInMemoryOnly: true))
    return NavigationView {
        SearchHistoriesView()
            .configureView(modelContext: container.mainContext)
    }.modelContainer(container)
}
#endif
