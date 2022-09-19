//
//  FavoriteView.swift
//  Counter
//
//  Created by 한상진 on 2022/08/20.
//

import SwiftUI
import ComposableArchitecture

public struct FavoriteView: View {
    
    private let store: Store<FavoriteState, FavoriteAction>
    @ObservedObject private var viewStore: ViewStore<FavoriteState, FavoriteAction>
    
    // MARK: Body
    
    public init(store: Store<FavoriteState, FavoriteAction>) {
        self.store = store
        self.viewStore = ViewStore(self.store)
    }
    
    public var body: some View {
        if viewStore.favoriteNumbers.isEmpty {
            Text("아직 추가된 숫자가 없어요!")
                .navigationTitle("Favorite Number List")
        } else {
            List {
                ForEach(viewStore.favoriteNumbers, id: \.self) { number in
                    Text("\(number)")    
                }
                .onDelete { viewStore.send(.deleteFavoriteNumberTapped($0)) }
            }
            .navigationTitle("Favorite Number List")    
        }
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
