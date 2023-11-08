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
        
        /// Метод send(_:assert:file:line:) в тестовом хранилище является асинхронным, поскольку большинство функций связаны с асинхронными side эффектами, а тестовое хранилище использует асинхронный контекст для отслеживания этих эффектов.
        /// Примечание: Нижестоящие методы покажут ошибку. Это связано с тем, что каждый раз, когда вы отправляете действие в TestStore, вы также должны точно описать, как меняется состояние после отправки этого действия. Библиотека также показывает вам подробное сообщение об ошибке, показывающее, насколько именно состояние отличается от ожидаемого (строки с минусом «-») и фактическое значение (строки с плюсом «+»).
        //      await store.send(.incrementButtonTapped)
        //      await store.send(.decrementButtonTapped)
        await store.send(.incrementButtonTapped) {
            $0.count = 1
        }
        await store.send(.decrementButtonTapped) {
            $0.count = 0
        }
        /// Примечание к коду выше: предпочитайте использовать «абсолютные» изменения, такие как count = 1, а не «относительные», такие как count += 1. Первое является более сильным утверждением, которое доказывает, что вы знаете точное состояние вашего объекта, а не просто то, какое преобразование было применено к вашему состоянию.
    }
    
    func testTimer() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }
        
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = true /// хороший кейс, чтобы понять что в приложении есть что-то, что не прекращают свою работу. Нам как разработчикам важно это иметь ввиду.
        }
        /// Делаем timeout на 2, потому что мы используем в качестве таймера Task.sleep(), что не является хорошей практикой, и тогда тесты будут проходить в 100% случаев на любом девайсе.
        /// В данном случае, эта запись говорит о том, что она будет ждать пока поменяется значение $0.count до 1 в течении 2 секунд.
        await store.receive(.timerTick, timeout: 2) {
            $0.count = 1
        }
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = false
        }
    }
}
