//
//  FavoriteView.swift
//  Counter
//
//  Created by 한상진 on 2022/08/20.
//

import SwiftUI
import ComposableArchitecture

struct FavoriteView: View {
    
    let store: Store<FavoriteState, FavoriteAction>
    @ObservedObject var viewStore: ViewStore<FavoriteState, FavoriteAction>
    
    // MARK: Body
    
    init(store: Store<FavoriteState, FavoriteAction>) {
        self.store = store
        self.viewStore = ViewStore(self.store)
    }
    
    var body: some View {
        List {
            ForEach(viewStore.favoriteNumbers, id: \.self) { number in
                Text("\(number)")    
            }
            .onDelete { viewStore.send(.deleteFavoriteNumberTapped($0)) }
        }
        .navigationTitle("Favorite Number List")
    }
}

// MARK: Preview

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView(
            store: .init(
                initialState: .init(favoriteNumbers: [1, 3, 6, 9]), 
                reducer: favoriteReducer, 
                environment: .init()
            )
        )
    }
}
