//
//  TCATests.swift
//  TCATests
//
//  Created by Oleg Kolbasa on 07.11.2023.
//

import ComposableArchitecture
import XCTest
@testable import TCA

@MainActor
final class CounterFeatureTests: XCTestCase {
    func testCounter() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }
        
        await store.send(.incrementButtonTapped) {
            $0.count = 1
        }
        await store.send(.decrementButtonTapped) {
            $0.count = 0
        }
    }
    
    func testTimer() async {
        let clock = TestClock()
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }
        
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = true
        }
        await clock.advance(by: .seconds(1))
        await store.receive(.timerTick) {
            $0.count = 1
        }
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = false
        }
    }
    /// Не прокатит! Но почему? Все просто, TestStore ждет пока все эффекты выполнятся и поскольку сетевой запрос еще не завершен, мы получаем ошибку.
//    func testNumberFact() {
//        let store = TestStore(initialState: CounterFeature.State()) {
//            CounterFeature()
//        }
//        
//        await store.send(.factButtonTapped) {
//            $0.isLoading = true
//        }
//        await store.receive(.factResponse("???")) {
//            $0.isLoading = false
//            $0.fact = "???"
//        }
//    }
}
