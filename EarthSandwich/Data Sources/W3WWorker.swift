//
//  APIWorker.swift
//  EarthSandwich
//
//  Created by Duc on 7/8/24.
//

import CoreLocation
import W3WSwiftApi

protocol W3WWorker {
    func convertToCoordinates(_ words: String) async throws -> CLLocationCoordinate2D
    func convertToWords(coords: CLLocationCoordinate2D, locale: String) async throws -> String
    func calculateAntipode(_ coords: CLLocationCoordinate2D) -> CLLocationCoordinate2D
}

struct NetworkW3WWorker: W3WWorker {
    let api = What3WordsV4(apiKey: Configs.apiKey)

    func convertToCoordinates(_ words: String) async throws -> CLLocationCoordinate2D {
        try await withCheckedThrowingContinuation { continuation in
            api.convertToCoordinates(words: words) { square, error in
                if let coords = square?.coordinates {
                    continuation.resume(returning: coords)
                } else if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: "Unexpected Error")
                }
            }
        }
    }

    func convertToWords(coords: CLLocationCoordinate2D, locale: String) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            api.convertTo3wa(coordinates: coords, language: W3WBaseLanguage(locale: locale)) { square, error in
                if let words = square?.words {
                    continuation.resume(returning: words)
                } else if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: "Unexpected Error")
                }
            }
        }
    }
}

struct MockW3WWorker: W3WWorker {
    func convertToCoordinates(_ words: String) async throws -> CLLocationCoordinate2D {
        return .init(latitude: 52.04, longitude: -0.76)
    }

    func convertToWords(coords: CLLocationCoordinate2D, locale: String) async throws -> String {
        return "what.three.works"
    }
}

extension W3WWorker {
    func calculateAntipode(_ coords: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        // Convert degrees to radians
        let latRad = (coords.latitude * .pi) / 180
        let longRad = (coords.longitude * .pi) / 180

        // Calculate the antipode latitude by changing the sign (pos to neg or neg to pos)
        let antipodeLat = -latRad

        // Calculate the antipode longitude by adding 180 degrees (π radians)
        var antipodeLong = longRad + .pi

        // Normalize the longitude to the range -π to π (-180° to 180°)
        if antipodeLong > .pi {
            antipodeLong -= 2 * .pi
        }

        // Convert radians back to degrees
        let antipodeLatDeg = (antipodeLat * 180) / .pi
        let antipodeLongDeg = (antipodeLong * 180) / .pi

        return CLLocationCoordinate2D(
            latitude: antipodeLatDeg,
            longitude: antipodeLongDeg
        )
    }
}
