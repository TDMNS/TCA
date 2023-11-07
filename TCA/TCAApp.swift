//
//  TCAApp.swift
//  TCA
//
//  Created by Oleg Kolbasa on 07.11.2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCAApp: App {
    static let store = Store(initialState: CounterFeature.State()) {
        CounterFeature()
            ._printChanges() /// Заметьте как это удобно!
    }
    
    var body: some Scene {
        WindowGroup {
            CounterView(store: TCAApp.store)
        }
    }
}
