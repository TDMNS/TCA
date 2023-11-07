//
//  CounterView.swift
//  TCA
//
//  Created by Oleg Kolbasa on 07.11.2023.
//

import SwiftUI
import ComposableArchitecture

struct CounterView: View {
    let store: StoreOf<CounterFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Text("\(viewStore.count)")
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                HStack {
                    Button("-") {
                        viewStore.send(.decrementButtonTapped)
                    }
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                    
                    Button("+") {
                        viewStore.send(.incrementButtonTapped)
                    }
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                }
            }
        }
    }
}

#Preview {
    /// в предварительном просмотре мы можем закомментировать Reducer CounterFeature, и в хранилище будет предоставлен редуктор, который не выполняет никаких изменений состояния или эффектов. Это позволяет нам предварительно просмотреть дизайн функции, не беспокоясь о ее логике или поведении.
    CounterView(
        store: Store(initialState: CounterFeature.State(), reducer: {
            CounterFeature()
        })
    )
}
