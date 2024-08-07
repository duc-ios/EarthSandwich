//
//  Validator.swift
//  EarthSandwich
//
//  Created by Duc on 7/8/24.
//

import Foundation

struct Validator {
    static func isValidThreeWords(_ words: String) -> Bool {
        words
            .trimmingCharacters(in: .init(charactersIn: "///"))
            .components(separatedBy: ".")
            .filter { !$0.isBlank }
            .count == 3
    }
}
