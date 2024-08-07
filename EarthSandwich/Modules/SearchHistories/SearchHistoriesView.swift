//
//  SearchHistoriesView.swift
//  EarthSandwich
//
//  Created by Duc on 6/8/24.
//

import SwiftData
import SwiftUI

protocol SearchHistoriesDisplayLogic {
    func displayMakeASandwich(viewModel: SearchHistories.ValidateWords.ViewModel)
    func displayLanguage(viewModel: SearchHistories.ChangeLanguage.ViewModel)
    func displayHistories(viewModel: SearchHistories.LoadHistories.ViewModel)
    func displayError(message: String)
}

extension SearchHistoriesView: SearchHistoriesDisplayLogic {
    func displayMakeASandwich(viewModel: SearchHistories.ValidateWords.ViewModel) {
        store.isMakeASandwichButtonDisabled = viewModel.isDisabled
    }

    func displayLanguage(viewModel: SearchHistories.ChangeLanguage.ViewModel) {
        store.lang = (viewModel.locale, viewModel.countryCode)
    }

    func displayHistories(viewModel: SearchHistories.LoadHistories.ViewModel) {
        DispatchQueue.main.async {
            withAnimation {
                store.items = viewModel.items
            }
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
    // swiftlint:disable:next large_tuple
    let languages: [(name: String, locale: String, countryCode: String)] = [
        ("English", "en", "EN"),
        ("Tiếng Việt", "vi", "VN")
    ]

    @Published var lang: (locale: String, countryCode: String) = ("en", "EN")
    @Published var items: [SearchHistory] = []
    @Published var text = ""
    @Published var focusing = false
    @Published var isMakeASandwichButtonDisabled = true
    @Published var errorMessage: String?
    @Published var displayError = false
}

extension SearchHistoriesView {
    func configureView(modelContext: ModelContext) -> some View {
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

            HStack(alignment: .top) {
                AutoSuggestTextField(
                    apiKey: interactor.repository.apiKey,
                    locale: store.lang.locale,
                    countryCode: store.lang.countryCode,
                    text: $store.text,
                    focusing: $store.focusing
                )
                .frame(
                    maxHeight: store.focusing ? .infinity : 44
                )
                .onChange(of: store.text) {
                    interactor.validateWords(request: .init(words: store.text))
                }

                Menu(store.lang.countryCode) {
                    ForEach(store.languages, id: \.locale) { lang in
                        Button(lang.name) {
                            interactor.changeLanguage(request:
                                .init(
                                    locale: lang.locale,
                                    countryCode: lang.countryCode
                                )
                            )
                        }
                    }
                }
                .frame(width: 30, height: 44)
            }.padding(.horizontal, 8)

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

            Button("Make a sandwich") {
                interactor.addItem(request: .init(words: store.text))
                store.text = ""
            }
            .disabled(store.isMakeASandwichButtonDisabled)

            if store.focusing {
                Spacer()
            } else {
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
                        .onDelete { offsets in
                            interactor.deleteItems(request: .init(offsets: offsets))
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
