//
//  FavoriteFeature.swift
//  Counter
//
//  Created by 한상진 on 2022/08/20.
//

import Foundation
import ComposableArchitecture

struct FavoriteState: Equatable {
    var favoriteNumbers: [Int]
}

enum FavoriteAction: Equatable {
    case deleteFavoriteNumberTapped(IndexSet)
}

struct FavoriteEnvironment: Equatable { }

let favoriteReducer = Reducer<FavoriteState, FavoriteAction, FavoriteEnvironment> { state, action, environment in
    switch action {
    case let .deleteFavoriteNumberTapped(index):
        state.favoriteNumbers.remove(atOffsets: index)
        return .none
    }
}

