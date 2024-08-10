//
//  AppView.swift
//  EarthSandwich
//
//  Created by Duc on 6/8/24.
//

import SwiftUI

struct AppView: View {
    @Environment(\.modelContext) var modelContext
    var body: some View {
        NavigationView {
            SearchHistoriesView()
                .configured(modelContext: modelContext)
        }
    }
}

#if DEBUG
#Preview {
    AppView()
}
#endif
