//
//  String+Error.swift
//  EarthSandwich
//
//  Created by Duc on 7/8/24.
//

import Foundation

extension String: LocalizedError {
    public var errorDescription: String? { self }
}
