//
//  String+Extensions.swift
//  EarthSandwich
//
//  Created by Duc on 6/8/24.
//

import Foundation

extension Optional where Wrapped == String {
    var isNilOrBlank: Bool {
        guard let self else { return true }
        return self.isBlank
    }
}

extension String {
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
    var isBlank: Bool { trimmed.isEmpty }
}
