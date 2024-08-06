//
//  Seeds.swift
//  EarthSandwichTests
//
//  Created by Duc on 7/8/24.
//

@testable import EarthSandwich
import Foundation

enum Seeds {
    static let items = [SearchHistory(
        timestamp: Date(),
        srcWords: "s.r.c", srcLat: 52.04, srcLng: -0.76,
        desWords: "d.e.s", desLat: -52.04, desLng: 179.24)]
}
