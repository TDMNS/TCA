//
//  NumberFactClient.swift
//  TCA
//
//  Created by Oleg Kolbasa on 08.11.2023.
//

import ComposableArchitecture
import Foundation

struct NumberFactClient {
    var fetch: (Int) async throws -> String?
}

extension NumberFactClient: DependencyKey {
    static let liveValue = Self { number in
        guard let url = URL(string: "http://numbersapi.com/\(number)") else { return nil }
        let (data, _) = try await URLSession.shared
            .data(from: url)
        return String(decoding: data, as: UTF8.self)
    }
}

extension DependencyValues {
    var numberFact: NumberFactClient {
        get { self[NumberFactClient.self] }
        set { self[NumberFactClient.self] = newValue }
    }
}
