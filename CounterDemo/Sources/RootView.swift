//
//  RootView.swift
//  Counter
//
//  Created by havi.log on 2022/08/19.
//

import SwiftUI
import Counter
import Favorite
import ComposableArchitecture

struct RootView: View {
    
    let store: Store<RootState, RootAction>
    
    // MARK: Body
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                Form {
                    Section {
                        NavigationLink(
                            "Counter",
                            destination: {
                                CounterView(
                                    store: store.scope(
                                        state: \.counter, 
                                        action: RootAction.counter
                                    )
                                )
                            }
                        )
                        
                        NavigationLink(
                            "Favorite",
                            destination: {
                                FavoriteView(
                                    store: store.scope(
                                        state: \.favorite, 
                                        action: RootAction.favorite
                                    )
                                )
                            }
                        )
                    }
                }
                .navigationTitle("Counter Demo")
            }
        }
    }
} 

// MARK: Preview

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(
            store: Store(
                initialState: RootState(),
                reducer: rootReducer,
                environment: .live
            )
        )
    }
}
