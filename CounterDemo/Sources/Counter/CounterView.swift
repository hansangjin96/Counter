//
//  CounterView.swift
//  Counter
//
//  Created by 한상진 on 2022/08/20.
//

import SwiftUI
import ComposableArchitecture

struct CounterView: View {
    
    let store: Store<CounterState, CounterAction>
    
    // MARK: Body
    
    var body: some View {
        WithViewStore(store) { viewStore in
            Form {
                Section {
                    VStack(alignment: .center, spacing: 10) {
                        HStack {
                            Button("-") { viewStore.send(.decrementButtonTapped) }
                            Text("\(viewStore.currentNumber)")
                            Button("+") { viewStore.send(.incrementButtonTapped) }
                        }
                        .frame(maxWidth: .infinity)
                        
                        Divider()
                        
                        Button("find number fact") { viewStore.send(.isPrimeButtonTapped) }
                            .frame(maxWidth: .infinity)
                        
                        Divider()
                        
                        if viewStore.isFavoriteNumber {
                            Button("delete \(viewStore.currentNumber) from favorite") {
                                viewStore.send(.deleteFavoriteNumberButtonTapped)
                            }
                            .frame(maxWidth: .infinity)
                        } else {
                            Button("save \(viewStore.currentNumber) as favorite") {
                                viewStore.send(.saveFavoriteNumberButtonTapped)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        if viewStore.isNumberFactRequestInFlight {
                            Divider()
                            
                            VStack(spacing: 10) {
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                                    .id(UUID())
                                
                                Button("cancel") { viewStore.send(.cancelButtonTapped) }
                            }
                        }
                        
                        if let fact = viewStore.numberFact {
                            Divider()
                            
                            Text(fact)
                                .font(.system(size: 15))
                                .frame(maxWidth: .infinity)
                        }                        
                    }
                }
            }
            .buttonStyle(.borderless)
        }
        .navigationTitle("Counter")
        .alert(
            store.scope(state: \.alert),
            dismiss: .alertDismissed
        )
    }
} 

// MARK: Preview

struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView(
            store: .init(
                initialState: .init(),
                reducer: counterReducer,
                environment: .init(factClient: .live)
            )
        )
    }
}
