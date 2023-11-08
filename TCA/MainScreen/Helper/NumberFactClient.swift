//
//  NumberFactClient.swift
//  TCA
//
//  Created by Oleg Kolbasa on 08.11.2023.
//

import ComposableArchitecture
import Foundation

/// Создатели TCA говорят о том, что вместо протоколов актуальнее использовать структуры с мутабельными свойствами для предоставления интерфейса.
/// Вопрос на засыпку, почему? Ответ тут: https://www.pointfree.co/collections/dependencies
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

/// Если интересно узнать про библиотеку зависимостей (ее можно использовать отдельно в любых приложениях), то вам стоит забежать сюда: https://github.com/pointfreeco/swift-dependencies
extension DependencyValues {
    var numberFact: NumberFactClient {
        get { self[NumberFactClient.self] }
        set { self[NumberFactClient.self] = newValue }
    }
}
