//
//  CounterFeature.swift
//  TCA
//
//  Created by Oleg Kolbasa on 07.11.2023.
//

import ComposableArchitecture
import Foundation

struct CounterFeature: Reducer {
    struct State: Equatable {
        var count = 0
        var fact: String?
        var isLoading = false
        var isTimerRunning = false
    }
    
    enum Action: Equatable {
        case decrementButtonTapped
        case factButtonTapped
        case factResponse(String)
        case incrementButtonTapped
        case timerTick
        case toggleTimerButtonTapped
    }
    
    enum CancelID { case timer }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.numberFact) var numberFact
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .decrementButtonTapped:
            state.count -= 1
            state.fact = nil
            return .none
            
        case .factButtonTapped:
            state.fact = nil
            state.isLoading = true
            return .run { [count = state.count] send in
                guard let fact = try await numberFact.fetch(count) else { return }
                await send(.factResponse(fact))
            }
            
        case let .factResponse(fact):
            state.fact = fact
            state.isLoading = false
            return .none
            
        case .incrementButtonTapped:
            state.count += 1
            state.fact = nil
            return .none
            
        case .timerTick:
            state.count += 1
            state.fact = nil
            return .none
            
        case .toggleTimerButtonTapped:
            state.isTimerRunning.toggle()
            if state.isTimerRunning {
                return .run { send in
                    for await _ in clock.timer(interval: .seconds(1)) {
                        await send(.timerTick)
                    }
                }
                .cancellable(id: CancelID.timer)
            } else {
                return .cancel(id: CancelID.timer)
            }
        }
    }
}
