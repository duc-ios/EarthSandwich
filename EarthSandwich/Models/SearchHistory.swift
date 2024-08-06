//
//  SearchHistory.swift
//  EarthSandwich
//
//  Created by Duc on 6/8/24.
//

import Foundation
import SwiftData

@Model
final class SearchHistory {
    internal init(
        timestamp: Date,
        srcWords: String,
        srcLat: Double,
        srcLng: Double,
        desWords: String,
        desLat: Double,
        desLng: Double) {
        self.timestamp = timestamp
        self.srcWords = srcWords
        self.srcLat = srcLat
        self.srcLng = srcLng
        self.desWords = desWords
        self.desLat = desLat
        self.desLng = desLng
    }

    var timestamp: Date
    var srcWords: String
    var srcLat: Double
    var srcLng: Double
    var desWords: String
    var desLat: Double
    var desLng: Double
}
