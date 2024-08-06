//
//  ItemCardView.swift
//  EarthSandwich
//
//  Created by Duc on 7/8/24.
//

import SwiftUI

struct ItemCardView: View {
    let item: SearchHistory

    private let slashes = {
        var text = AttributedString("///")
        text.foregroundColor = .red
        return text
    }()

    var body: some View {
        VStack {
            Text(slashes + AttributedString(item.srcWords
                    .trimmingCharacters(in: .init(charactersIn: "///"))))
            Text("🌏")
            Text(slashes + AttributedString(item.desWords
                    .trimmingCharacters(in: .init(charactersIn: "///"))))
        }
        .frame(maxWidth: .infinity)
    }
}
