//
//  CounterFeature.swift
//  TCA
//
//  Created by Oleg Kolbasa on 07.11.2023.
//

import ComposableArchitecture

struct CounterFeature: Reducer {
    struct State: Equatable {
        var count = 0
    }
    
    enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
    }
    
    
    /// Reducer
    /// - Parameters:
    ///   - state: состояние
    ///   - action: действия пользователя
    /// - Returns: возвращает любые эффекты, которые функция хочет выполнить во внешнем мире. Заметка: метод reduce принимает состояние в качестве аргумента и помечается как inout. Это означает, что вы можете вносить любые изменения непосредственно в состояние. Нет необходимости делать копию состояния только для того, чтобы вернуть его.
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .decrementButtonTapped:
            state.count -= 1
            return .none
        case .incrementButtonTapped:
            state.count += 1
            return .none
        }
    }
}
